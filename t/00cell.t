package test::cell;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use MyList;
use Data::Dumper;

sub init : Test(1) {                    # init?
    new_ok 'My::List';                    # ??
}
sub cell : Tests{
    my @a = (1,2,3);
    my $ref_a = \@a;
    my $x = Cell->new( \@a );
    my $y = Cell->new( \@a );

    is $x->value, \@a;
    is $y->value, \@a;
    is $x->value, $y->value;
    is $x->value, $ref_a;
}

__PACKAGE__->runtests;

1;
