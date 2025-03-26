#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

my %variables;

sub precedence {
    my ($op) = @_;
    return 1 if $op eq '+' || $op eq '-';
    return 2 if $op eq '*' || $op eq '/';
    return 0;
}

sub infix_to_postfix {
    my ($expression) = @_;
    my @output;
    my @operators;
    my $num = '';

    my @chars = split //, $expression;

    for my $ch (@chars) {
        if ($ch =~ /\d/) {
            $num .= $ch;
        } 
        elsif ($ch =~ /[a-zA-Z]/) {
            $num .= $ch;
        } 
        else {
            if ($num ne '') {
                if ($num =~ /^\d+$/) {
                    push @output, $num;
                } 
                elsif (exists $variables{$num}) {
                    push @output, $variables{$num};
                } 
                else {
                    die "Error: undefined variable '$num'";
                }
                $num = '';
            }

            if ($ch eq '(') {
                push @operators, $ch;
            } 
            elsif ($ch eq ')') {
                while (@operators && $operators[-1] ne '(') {
                    push @output, pop @operators;
                }
                pop @operators if @operators;
            } 
            elsif ($ch =~ /[+\-*\/]/) {
                while (@operators && precedence($operators[-1]) >= precedence($ch)) {
                    push @output, pop @operators;
                }
                push @operators, $ch;
            }
        }
    }

    if ($num ne '') {
        if ($num =~ /^\d+$/) {
            push @output, $num;
        } 
        elsif (exists $variables{$num}) {
            push @output, $variables{$num};
        } 
        else {
            die "Error: undefined variable '$num'";
        }
    }

    while (@operators) {
        my $op = pop @operators;
        die "Error: parentheses are not valid" if $op eq '(' || $op eq ')';
        push @output, $op;
    }

    return \@output;
}


sub parse_postfix {
    my ($postfix) = @_;
    my @stack;

    for my $token (@$postfix) {
        if ($token =~ /^\d+$/) {
            push @stack, $token;
        } 
        else {
            my $right = pop @stack // die "Error: missing operand";
            my $left  = pop @stack // die "Error: missing operand";

            my $result;
            if($token eq '+') {
                $result = $left + $right; 
            }
            elsif($token eq '-') {
                $result = $left - $right; 
            }
            elsif($token eq '*') {
                $result = $left * $right; 
            }
            elsif($token eq '/') {
                die "Error: cannot divide by zero" if $right == 0;
                $result = int($left / $right);
            } 
            else {
                die "Error: invalid operator";
            }

            push @stack, $result;
        }
    }

    return pop @stack // die "Error: calculation error";
}


sub parse_and_evaluate {
    my ($input) = @_;
    $input =~ s/\s+//g; 
    

    if ($input =~ /^([a-zA-Z]+)=(.+)$/) {
        my ($var, $value_expr) = ($1, $2);
        my $postfix = infix_to_postfix($value_expr);
        my $value = parse_postfix($postfix);
        $variables{$var} = $value;
        return $value;
    }

    my $postfix = infix_to_postfix($input);
    return parse_postfix($postfix);
}


say "Basic Arithmetic Calculator, type 'exit' to exit";

while (1) {
    print "Enter expression below: ";
    my $input = <STDIN>;
    chomp $input;

    last if $input eq 'exit';

    eval {
        my $result = parse_and_evaluate($input);
        say "> $result";
    };
    if ($@) {
        say "> $@";
    }
}