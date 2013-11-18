# -*- mode: cperl; -*-
package Set::Jaccard::SimilarityCoefficient;

# VERSION

# ------ pragmas
use utf8;
use autodie;
use warnings;
use strict;
use Exception::Class qw(
    BadArgumentException
    DivideByZeroException
);
use Readonly qw( Scalar );
use Set::Scalar;

#

# ------ Error messages
Readonly::Scalar my $BAD_SET_A
    => 'must have either ArrayRef or Set::Scalar value for set A';
Readonly::Scalar my $BAD_SET_B
    => 'must have either ArrayRef or Set::Scalar value for set B';
Readonly::Scalar my $DIVIDE_BY_ZERO
    => 'Cannot calculate when size(Union(A B)) == 0';

#

=function

Calculate the Jaccard Similarity Coefficient.

=cut

sub calc {
    my ($set_a_arg, $set_b_arg) = @_;
    my $set_a;
    my $set_b;

    if (!defined $set_a_arg
    || (ref $set_a_arg ne 'ARRAY' && ref $set_a_arg ne 'Set::Scalar')) {
        BadArgumentException->throw($BAD_SET_A);
    }

    if (!defined $set_b_arg
    || (ref $set_b_arg ne 'ARRAY' && ref $set_b_arg ne 'Set::Scalar')) {
        BadArgumentException->throw($BAD_SET_B);
    }

    if (ref $set_a_arg eq 'Set::Scalar') {
        $set_a = $set_a_arg->clone();
    } else {
        $set_a = Set::Scalar->new(@{$set_a_arg});
    }

    if (ref $set_b_arg eq 'Set::Scalar') {
        $set_b = $set_b_arg->clone();
    } else {
        $set_b = Set::Scalar->new(@{$set_b_arg});
    }

    my $intersection = $set_a->intersection($set_b);
    my $union        = $set_a->union(       $set_b);

    if ($union->size <= 0) {
        DivideByZeroException->throw($DIVIDE_BY_ZERO);
    }

    return $intersection->size / $union->size;
}

# COPYRIGHT

1;

=encoding utf8

=head1 NAME

Set::Jaccard::SimilarityCoefficient - Calculate the Jaccard Similarity Coefficient of 2 sets

=head1 VERSION

# VERSION

=head1 SYNOPSIS

$res = Set::Jaccard::SimilarityCoefficient::calc(\@set_a, \@set_b);

OR

my $a = Set::Scalar->new(@set_a);
my $b = Set::Scalar->new(@set_b);
$res = Set::Jaccard::SimilarityCoefficient::calc($a, $b);

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

=head1 LICENSE AND COPYRIGHT

=cut
