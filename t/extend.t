# 拡張機能のテスト
package test::extend;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use MyList;

sub init : Test(1) {
    new_ok 'My::List';
}

sub length : Tests{
    my $list = My::List->new;

    $list->append("Hello");
    is $list->length, 1;

    $list->append("World");
    is $list->length, 2;

    $list->append(2011);
    is $list->length, 3;
}
sub insert : Tests{
    my $list = My::List->new;
    my $data = ["Hello", "World", 2011];
    foreach my $elem (@$data){
        $list->append($elem);
    }
    $list->insert("Hey", 0);
    is $list->nth(0)->value, "Hey";
    is $list->length, 4;

    $list->insert("foo", 2);
    is $list->nth(2)->value, "foo";
    is $list->length, 5;

    $list->insert("bar",100);
    is ${$list->{tail}}->value, "bar";
    is $list->length, 6;
}
sub nth : Tests{
    my $list = My::List->new;
    my @data = ("Hello", "World", 2011);
    foreach my $elem (@data){
        $list->append($elem);
    }
    foreach my $i(0..$#data){
        is $list->nth($i)->value, $data[$i];
    }
}

sub remove : Tests{
    my @data = ("Hello", "World", 2011);
    my $list = My::List->new;
    foreach my $elem (@data){ $list->append($elem); }

    $list->remove(0);

    my $iter = $list->iterator;
    is $iter->next->value, "World" ;
#    is $iter->next->value, 2011 ;
}

sub mixed : Tests{
    my $list = My::List->new;
    $list->append("Hello");
    $list->append("World");
    $list->append(2011);

    is $list->length, 3; # ("Hello" "World" 2011);

    $list->insert("こんにちは", 0);
    is $list->nth(0)->value, "こんにちは";

    my $iter = $list->iterator;
    is $iter->next->value, "こんにちは";
    is $iter->next->value, "Hello";
    is $iter->next->value, "World";
    is $iter->next->value, 2011;
    is $list->length, 4;

    $list->remove(0);
    $iter = $list->iterator;
    is $iter->next->value, "Hello";
    is $iter->next->value, "World";
    is $iter->next->value, 2011;
    is $list->length,3;

    $list->insert("こんばんは",100);
    $iter = $list->iterator;
    is $iter->next->value, "Hello";
    is $iter->next->value, "World";
    is $iter->next->value, 2011;
    is $iter->next->value, "こんばんは";
    is $list->length, 4;
}
__PACKAGE__->runtests;

1;
