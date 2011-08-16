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
        return $self->{obj} = ${ $self->{obj}->next };
    }else{
        return undef;
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
sub insert{
    my ($self,$value,$n) = @_;
    if( $n>$self->length ){ return $self->append($value); }
    $n=0 if $n<0;

    my $newcell = Cell->new($value);
    $newcell->{next} = \$self->nth($n);
    $self->nth($n-1)->{next} = \$newcell;
    $self->{length}++;
    $self;
}
sub length{
    my ($self) = @_;
    $self->{length};
}
sub nth{ # 0から数えてn番目のCellを返す。
    my ($self,$n) = @_;

    my $iter = $self->iterator;
    if( $n<0 ){
        return ${ $self->{head} };      # デリファレンス
    }
    while($n>0){ $iter->next; $n--;}
    return $iter->next;                 # NOT a ref
}
sub remove{
    my ($self,$n) = @_;
    $self->nth($n-1)->{next} = \$self->nth($n+1);
    $self->{length}--;
    $self;
}

1;

__END__

=head1 NAME

Cell, My::List, My::List::Iterator - 単方向リストとその部品

=head1 USAGE

my $list = My::List->new;

$list->append("Hello");
$list->append("World");
$list->append(2011);

# => $list : ("Hello" "World" 2011)

$list->insert("こんにちは",2);
# => $list : ("Hello" "World" "こんにちは" 2011)

$list->remove(1); #第1要素を削除（0から数える）
# => $list : ("Hello" "こんにちは" 2011)

print $list->nth(3); #第3要素を参照する
# => 2011


=head1 DESCRIPTION

insertの仕様
リスト長より大きい位置を指定すると、最後尾に追加する。
負の値を指定すると、頭に追加する。

=head1 AUTHOR

UENO Masaru( id:uenop )
<Hatena Intern 2011>

=cut

