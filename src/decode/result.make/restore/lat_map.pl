#!/usr/bin/perl

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#X                                                                  X
#X lat_map.pl, Copyright(C) Gailius Raskinis, 2020                  X
#X                                                                  X
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

use strict;
use warnings;

our $symtab_w; # word symbol table
our $symtab_p; # phone symbol table
our $symtab_synonym; # phone symbol table
our %i2w;
our %i2p;
our %i2synonym;

sub int2word {
   my $a = shift @_;
   if($a !~  m:^\d+$:) { # not all digits..
      die "$0: found noninteger token $a\n";
      }
   my $s = $i2w{$a};
   if(!defined ($s)) {
      die "$0: integer $a not in symbol table $symtab_w.";
      }
   return $s;
}
#-----------------------------

sub int2phone {
   my ( $a, $remove_pd_info ) = @_;
   if($a !~  m:^\d+$:) { # not all digits..
      die "$0: found noninteger token $a\n";
      }
   my $s = $i2p{$a};
   if(!defined ($s)) {
      die "$0: integer $a not in symbol table $$symtab_p.";
      }
   if ($remove_pd_info) {
      $s =~ s/_[BESI]//;
      }
   return $s;
}
#-----------------------------


sub int2synonym {
   my $a = shift @_;
   if($a !~  m:^\d+$:) { # not all digits..
      die "$0: found noninteger token $a\n";
      }
   my $s = $i2synonym{$a};
   if(!defined ($s)) {
      #die "$0: integer $a not in symbol table $symtab_synonym.";
      return $a;
      }
   return $s;
}

#-----------------------------
1
