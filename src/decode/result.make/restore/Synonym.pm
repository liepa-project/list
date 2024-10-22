#!/usr/bin/perl

package Synonym;

use strict;
use warnings;



# sub replace_synonyms_del {
#     my ($lats_ref) = @_;

#     for ( my $i = 0 ; $i < scalar @$lats_ref ; $i++ ) {
#         for ( my $j = 0 ; $j < scalar @{ $$lats_ref[$i]->{_e} } ; $j++ ) {
#             my $word_id    = $$lats_ref[$i]->{_e}->[$j]->{word_id};
#             my $synonym_id = main::int2synonym($word_id);

#             #print "$word_id -> $synonym_id\n";
#             $$lats_ref[$i]->{_e}->[$j]->{word_id} = $synonym_id;
#         }
#     }
# }


sub replace_word_ids {
    my ($lats_ref, %word_id2word_id) = @_;
    for ( my $i = 0 ; $i < scalar @$lats_ref ; $i++ ) {
        for ( my $j = 0 ; $j < scalar @{ $$lats_ref[$i]->{_e} } ; $j++ ) {
            my $word_id    = $$lats_ref[$i]->{_e}->[$j]->{word_id};
            my $synonym_id = $word_id2word_id{$word_id};
            if (exists $word_id2word_id{$word_id}){
                $$lats_ref[$i]->{_e}->[$j]->{word_id} = $synonym_id;
            }
        }
    }
}

sub replace_synonyms {
    my ( $lats_ref, $lats2_ref ) = @_;
    my %phoneme_hash  = create_ph2wordId($lats_ref);
    my %word_id2word_id = create_wordId2wordId(%phoneme_hash);
    replace_word_ids($lats_ref, %word_id2word_id);
    replace_word_ids($lats2_ref, %word_id2word_id);


}

sub create_wordId2wordId {
    my  (%phoneme_hash)  = @_;

    my %wordId2wordId  = ();
    foreach my $phonemes ( keys %phoneme_hash ) {
        my $word_ids = $phoneme_hash{$phonemes};
        $word_ids = remove_duplicates($word_ids);
        if ( scalar @{$word_ids} > 1 ) {
            my %word_str_hash = ();
            foreach my $word_id ( @{$word_ids} ) {
                my $word_str = main::int2word($word_id);
                $word_str_hash{$word_str} = $word_id;
            }
            my $max_length   = undef;
            my $longest_word = undef;
            foreach my $word_str ( keys %word_str_hash ) {
                my $length = length($word_str);

                if ( !defined $max_length || $length > $max_length ) {
                    $longest_word = $word_str;
                    $max_length   = $length;
                }
            }
            my $longest_word_id = $word_str_hash{$longest_word};

            #print "Word $longest_word \n";

            foreach my $word_str ( keys %word_str_hash ) {
                my $word_id = $word_str_hash{$word_str};
                if ( $word_id != $longest_word_id ) {
                    $wordId2wordId{$word_id} = $longest_word_id;
                }
            }
        }
    }
    return %wordId2wordId;
}

sub remove_duplicates {
    my ($array_ref) = @_;
    my %seen;
    return [ grep { !$seen{$_}++ } @$array_ref ];    # filter duplicates
}

sub create_ph2wordId {
    my ( $lats_ref ) = @_;
    
    my %ph2wordId  = ();

    for ( my $i = 0 ; $i < scalar @$lats_ref ; $i++ ) {
        for ( my $j = 0 ; $j < scalar @{ $$lats_ref[$i]->{_e} } ; $j++ ) {

            # space-separated phone list (non-BESI)
            my $phonmes = $$lats_ref[$i]->{_e}[$j]->{ph};
            my $word_id = $$lats_ref[$i]->{_e}[$j]->{word_id};
            push @{ $ph2wordId{$phonmes} }, $word_id;
        }
    }
    return %ph2wordId;
}


1;
