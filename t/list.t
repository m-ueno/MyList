package test::Sorter;
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
}

# sub long_list : Tests{
#     my $list = My::List->new;
#     my $n = 1000;
#     foreach my $i (0..$n){
#         $list->append($i**2);
#     }
#     my $iter = $list->iterator;
#     foreach my $i (0..$n){
#         is $i**2, $iter->next->value;
#     }
# }


# sub values : Tests {
#     my $sorter = Sorter->new;
#     is_deeply [$sorter->get_values], [];

#     $sorter->set_values;
#     is_deeply [$sorter->get_values], [];

#     $sorter->set_values(1);
#     is_deeply [$sorter->get_values], [1];

#     $sorter->set_values(1,2,3,4,5);
#     is_deeply [$sorter->get_values], [1,2,3,4,5];
# }

# sub sort : Tests {
#     my $sorter = Sorter->new;
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [];

#     $sorter->set_values(1);
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [1];

#     $sorter->set_values(5,4,3,2,1);
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [1,2,3,4,5];

#     $sorter->set_values(-1,-2,-3,-4,-5);
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [-5,-4,-3,-2,-1];

#     $sorter->set_values(1,2,3,4,5);
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [1,2,3,4,5];

#     $sorter->set_values(5,5,4,4,4,3,2,1);
#     $sorter->sort;
#     is_deeply [$sorter->get_values], [1,2,3,4,4,4,5,5];

#     for (0..4) {
#         my @random_values = ();
#         push(@random_values, int(rand() * 100) - 50)  for 0..99;
#         $sorter->set_values(@random_values);
#         $sorter->sort;
#         is_deeply [$sorter->get_values], [sort { $a <=> $b } @random_values];
#     }
# }

__PACKAGE__->runtests;

1;
