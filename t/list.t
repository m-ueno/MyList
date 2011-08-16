package test::List;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use MyList;

sub init : Test(1) {                    # init?
    new_ok 'My::List';                    # ??
}
sub null_list : Tests{
    my $list = My::List->new;
    is ${$list->{head}}->value, undef;
    is ${$list->{head}}->next, undef;
}
sub two_elements_list : Tests{
    my $list = My::List->new;

    $list->append("Hello");
    is ${$list->{tail}}->value, "Hello";

    $list->append("World");
    is ${$list->{tail}}->value, "World";

    is ${${$list->{head}}->next}->value, "Hello";
    is ${${${$list->{head}}->next}->next}->value, "World";

    is $list->length, 2;
}
sub various_data : Tests{
    my $list = My::List->new;
    my $data = [ undef, 0, [1,2,3], "string",
                 {k=>"value", num=>10, ary=>[1,2,3]} ];
    foreach my $elem (@$data){ $list->append($elem); }

    is( $list->length, $#$data+1 );       # 誤:@$ary -> 正:$ary

    my $iter = $list->iterator;
    foreach my $elem (@$data){
        is $elem, $iter->next->value;
    }
#    note explain $data;
}

sub long_list : Tests{
    my $list = My::List->new;
    my $n = 100;
    foreach my $i (0..$n){
        $list->append($i**2);
    }
    my $iter = $list->iterator;
    foreach my $i (0..$n){
        is $i**2, $iter->next->value;
    }
}


__PACKAGE__->runtests;

1;
