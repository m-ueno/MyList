package Cell;
sub new{
    my ($class,$value) = @_;
    bless {value=>$value, next=>undef}, $class;
}
sub has_next{
    my ($self) = @_;
    $self->next;
}
sub value{
    my ($self) = @_;
    $self->{value};
}
sub next{
    my ($self) = @_;
    return $self->{next};
}
# ----------------
package My::List::Iterator;
use strict;

sub new{
    my ($class,$obj) = @_;
    bless {obj=>$obj}, $class;
}
sub next{                       # !
    my ($self) = @_;
    if( $self->has_next ){
        $self->{obj} = ${ $self->{obj}->next };
    }else{
        undef;
    }
}
sub has_next{
    my ($self) = @_;
    $self->{obj}->next;
}
# ----------------
package My::List;
use strict;
use warnings;
use 5.10.0;

sub new{
    # head,tail（先頭・最後尾セル）はreference
    my ($class)=@_;
    my ($head,$tail);
    my $newcell = Cell->new;    # 先頭セル(valueをもたない)
    $head = $tail = \$newcell;
    bless{head=>$head, length=>0, tail=>$tail}, $class;
}
sub append{
    my ($self,$value) = @_;
    my $newcell = Cell->new($value);

    $self->{length}++;
    ${ $self->{tail} }->{next} = \$newcell;
    $self->{tail} = \$newcell;
}
sub iterator{
    my ($self) = @_;
    My::List::Iterator->new(${$self->{head}});
}
# 独自拡張
# &insert(val,n) : 実行後、n番目(n=0,1,...)にvalがある状態になる。
# &appendは insert(val,length)と書き直せる。
sub insert{
    my ($self,$value,$n) = @_;
    if( $n>$self->length ){ return $self->append($value); }
    $n=0 if $n<0;

    my $newcell = Cell->new($value);
    $newcell->{next} = \$self->nth($n);
    $self->nth($n-1)->{next}=\$newcell;
    if( $n==0 ){
        ${$self->{head}}->{next} = \$newcell;
    }
    $self->{length}++;
    $self;
}
sub length{
    my ($self) = @_;
    $self->{length};
}
sub nth{                               # 0から
    my ($self,$n) = @_;

    my $iter = $self->iterator;
    while($n>0){ $iter->next; $n--;}
    $iter->next;                        # ref to cell
}
sub remove{
    my ($self,$n) = @_;
    $self->nth($n-1)->{next} = $self->nth($n+1);
    $self->{length}--;
    $self;
}
# ----------------
package Main;
use strict;
use warnings;
use 5.10.0;
use Data::Dumper;
use Test::Class;
local $Data::Dumper::Indent = 1;
local $Data::Dumper::Purity = 1;
local $Data::Dumper::Terse = 1;

sub test1{
    my ($x,$y,$refx);
    $x=My::List->new;
    $refx = \$x;
    say Dumper $refx;
    say Dumper $$refx;
}
sub test2{
    say "** test2";
    my $list = My::List->new;

    $list->append("Hello");
    $list->append("World");
    $list->append(2011);
    say Dumper $list;

    my $iter = $list->iterator;
    while ($iter->has_next ) {
        say $iter->next->value;
    }
}
sub test3{
    say "** test3";
    my $list = My::List->new;
    foreach my $i (1..400000){
        $list->append($i);
    }
    my $iter = $list->iterator;
    say ${$iter->next}->value;
    say ${$iter->next}->value;
}
sub test4{
    my $list = My::List->new;
    $list->append(undef);
    $list->append(0);
    $list->append(100**3);
    $list->append([1,2,3]);
    $list->append((1,2,3));
    $list->append("string");
    $list->append({ k=>"value",
                    num=>10,
                    ary=>[1,2,3],
                    hash=>{'a',10,'b',20} });
    $list->append();
    my $iter = $list->iterator;
    my $value;
    while( $value = $iter->next ){
        say Dumper "dbg", $value;
    }
}
sub test_cell{
    my @a = (1,2,3);
    my $x = Cell->new( @a );
    my $y = Cell->new( \@a );
    say Dumper $x->value;
    say Dumper $y->value;
}
sub test_ref{
    my $a = [0, [10,20,30], undef, {}];
    foreach my $e (@$a){
        say "elem: ",Dumper $e;
    }
    say Dumper "本体",@$a;

    my $len = @$a;
    say "length: ", $#$a;
}
sub main{
    &test_ref();
}

$ARGV[0] ? &main() : 0;

1;
