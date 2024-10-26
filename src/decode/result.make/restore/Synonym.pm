#!/usr/bin/perl

package Synonym;

use strict;
use warnings;

# Main subroutine for this module. 
sub replace_synonyms {
    my ( $lats_ref, $lats2_ref ) = @_;
    my %phoneme_hash  = create_ph2wordId($lats_ref);
    my ($word_id2word_id, $wordId2grapheme) = create_wordId2wordId(%phoneme_hash);
    replace_word_ids($lats_ref, $word_id2word_id, $wordId2grapheme);
    replace_word_ids($lats2_ref, $word_id2word_id, $wordId2grapheme);
}



sub replace_word_ids {
    my ($lats_ref, $word_id2word_id, $wordId2grapheme) = @_;
    for ( my $i = 0 ; $i < scalar @$lats_ref ; $i++ ) {
        for ( my $j = 0 ; $j < scalar @{ $$lats_ref[$i]->{_e} } ; $j++ ) {
            my $word_id    = $$lats_ref[$i]->{_e}->[$j]->{word_id};
            my $synonym_id = $word_id2word_id->{$word_id};
            # if (exists $word_id2word_id->{$word_id}){
            #     $$lats_ref[$i]->{_e}->[$j]->{synonym_id} = $synonym_id;
            # }
            if(exists $wordId2grapheme->{$word_id}){
                my $grapheme = $wordId2grapheme->{$word_id};
                $$lats_ref[$i]->{_e}->[$j]->{grapheme} = $grapheme;
            }
        }
    }
}


# Find which word in the hash is longest 
sub find_longest_word {
    my  (%word_str_hash)  = @_;
    my $max_length   = undef;
    my $longest_word = undef;
    foreach my $word_str ( keys %word_str_hash ) {
        my $length = length($word_str);

        if ( !defined $max_length || $length > $max_length ) {
            $longest_word = $word_str;
            $max_length   = $length;
        }
    }
    return $longest_word;
}


sub create_wordId2wordId {
    my  (%phoneme_hash)  = @_;

    my %wordId2wordId  = ();
    my %wordId2grapheme  = ();
    foreach my $phonemes ( keys %phoneme_hash ) {
        my $word_ids = $phoneme_hash{$phonemes};
        
        # If there is multiple words in a graph further use only unique ones.
        $word_ids = remove_duplicates($word_ids);

        my %word_str_hash = ();;
        foreach my $word_id ( @{$word_ids} ) {
            my $word_str = main::int2word($word_id);
            if ($word_str =~ /[\.\d]+/ ) { # digits and abbreviations that ends with dot(.)
                my $grapheme = main::p2g_rules($phonemes);
                $wordId2grapheme{$word_id}=$grapheme;
            } elsif (length($word_str) == 1){ # abbreviations that is one symbol length.
                my $grapheme = main::p2g_rules($phonemes);
                if(length($word_str)<length($grapheme)){ # check if it is not one phoneme length word
                    $wordId2grapheme{$word_id}=$grapheme;
                }
            }
            $word_str_hash{$word_str} = $word_id;
        }


        if ( scalar @{$word_ids} > 1 ) {      
            # If there is in the graph words with same phoneme sequence, but different word representation.
            # Find which one is longest word      
            my $longest_word = find_longest_word(%word_str_hash);            
            my $longest_word_id = $word_str_hash{$longest_word};

            foreach my $word_str ( keys %word_str_hash ) {
                my $word_id = $word_str_hash{$word_str};
                if ( $word_id != $longest_word_id ) {
                    $wordId2wordId{$word_id} = $longest_word_id;
                }
            }
        }
    }
    return (\%wordId2wordId, \%wordId2grapheme);
}

# Remove duplicates in the array
sub remove_duplicates {
    my ($array_ref) = @_;
    my %seen;
    return [ grep { !$seen{$_}++ } @$array_ref ];    # filter duplicates
}

# transform from edge to hash  phoneme sequence -> array of word ids
sub create_ph2wordId {
    my ( $lats_ref ) = @_;
    
    my %ph2wordId  = ();

    for ( my $i = 0 ; $i < scalar @$lats_ref ; $i++ ) {
        for ( my $j = 0 ; $j < scalar @{ $$lats_ref[$i]->{_e} } ; $j++ ) {
            my $phonemes = $$lats_ref[$i]->{_e}[$j]->{ph};
            my $word_id = $$lats_ref[$i]->{_e}[$j]->{word_id};
            push @{ $ph2wordId{$phonemes} }, $word_id;
        }
    }
    return %ph2wordId;
}


1;
