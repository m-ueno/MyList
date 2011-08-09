package Cell;
sub new{
    my ($class,$value) = @_;
    bless {car=>$value, next=>undef}, $class;
}
# sub append{                             # 新objectをくっつける
#     my ($self,$value) = @_;
#     my $cell = Cell->new;
#     $cell->{car} = $value;
#     $self->{next} = $cell;
#     return $cell;
# }
sub has_next{
    my ($self) = @_;
    $self->next;
}
sub car{
    my ($self) = @_;
    $self->{car};
}
sub next{                                # NOT a setf place!
    my ($self) = @_;
    return $self->{next};
}
# ----------------
package MyIterator;                     # next要素をもつobjectの
use Data::Dumper;
sub new{
    my ($class,$obj) = @_;
    bless {obj=>$obj}, $class;
}
sub next{
    my ($self) = @_;
    $self->{obj} = $self->{obj}->next;
}
sub has_next{
    my ($self) = @_;
    $self->{obj}->next;
}

# ----------------
package MyList;
use Clone qw(clone);
use strict;
use warnings;
use 5.10.0;
use Data::Dumper;
local $Data::Dumper::Indent = 1;
local $Data::Dumper::Terse = 1;

sub new{
    my ($class) = @_;
    my ($head,$tail);
    $head = $tail = Cell->new;
    bless{head=>$head, tail=>$tail}, $class;
}
sub append{
    my ($self,$value) = @_;
    $self->{tail}->{next} = Cell->new($value);
    $self->{tail} = $self->{tail}->{next};
}
sub iterator{
    my ($self) = @_;
    MyIterator->new($self->{head});     # フィールド(!=メソッド)
}
# 拡張
sub insert{
    my ($self,$value,$n) = @_;
}
# sub nth{
#     my ($self,$n) = @_;
#     my $iter = $self->iterator;
#     while($n>0){ $iter->next; }
#     $iter;
# }
    
# ----------------
package Main;
use strict;
use warnings;
use 5.10.0;
use Data::Dumper;
use Test::Class;
local $Data::Dumper::Indent = 1;
local $Data::Dumper::Terse = 1;

sub test1{
    say "** test1";
    my $x = Cell->new("Hello");
    my $y = Cell->new("World");
    my $z = Cell->new(2011);

    $x->{next} = $y;
    say "x: ", Dumper $x;
    say "y: ", Dumper $y;
    say Dumper $x->next;
    say Dumper $y->next;
}
sub test2{
    say "** test2";
    my $list = MyList->new;

    $list->append("Hello");
    $list->append("World");
    $list->append(2011);
    say Dumper $list;

    my $iter = $list->iterator;
    while ($iter->has_next ) {
        say $iter->next->car;
    }
}
sub test3{
    say "** test3";
    my ($x,$y,$z);
    $x=[1,2];
    $z = $y = $x;
    say Dumper $y,$z;                          # 1,1

    $x = 2;
    say Dumper $y,$z;                          # 1,1

    $y = 2;
    say Dumper $y,$z;                          # 2,1
}
    
sub main{
    &test2();
}
&main();

1;
