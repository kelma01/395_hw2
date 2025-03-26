
:- dynamic(variable/2).

precedence('+', 1).
precedence('-', 1).
precedence('*', 2).
precedence('/', 2).

replace_whitespace(Input, Cleaned) :-
    atom_chars(Input, Chars),
    exclude(whitespace_char, Chars, CleanedChars),
    atom_chars(Cleaned, CleanedChars).

whitespace_char(Char) :-
    char_type(Char, space).

infix_to_postfix(Infix, Postfix) :-
    string_chars(Infix, Chars),
    infix_to_postfix_helper(Chars, [], [], Postfix).

infix_to_postfix_helper([], [], Output, Output).
infix_to_postfix_helper([], [Op|Ops], Output, Postfix) :-
    append(Output, [Op], NewOutput),
    infix_to_postfix_helper([], Ops, NewOutput, Postfix).
infix_to_postfix_helper([Char|Chars], Ops, Output, Postfix) :-
    (   char_type(Char, digit) ->
        collect_number([Char|Chars], Number, RestChars),
        append(Output, [Number], NewOutput),
        infix_to_postfix_helper(RestChars, Ops, NewOutput, Postfix)
    ;   char_type(Char, alpha) ->
        append(Output, [Char], NewOutput),
        infix_to_postfix_helper(Chars, Ops, NewOutput, Postfix)
    ;   precedence(Char, _) ->
        handle_operator(Char, Ops, Output, NewOps, NewOutput),
        infix_to_postfix_helper(Chars, NewOps, NewOutput, Postfix)
    ;   Char = '(' ->
        infix_to_postfix_helper(Chars, [Char|Ops], Output, Postfix)
    ;   Char = ')' ->
        handle_closing_parenthesis(Ops, Output, NewOps, NewOutput),
        infix_to_postfix_helper(Chars, NewOps, NewOutput, Postfix)
    ).

collect_number([Char|Chars], Number, RestChars) :-
    char_type(Char, digit),
    collect_number_helper(Chars, [Char], Digits, RestChars),
    atom_chars(Atom, Digits),
    atom_number(Atom, Number).

collect_number_helper([Char|Chars], Acc, Digits, RestChars) :-
    char_type(Char, digit),
    append(Acc, [Char], NewAcc),
    collect_number_helper(Chars, NewAcc, Digits, RestChars).
collect_number_helper(RestChars, Digits, Digits, RestChars).

handle_operator(Op, [], Output, [Op], Output).
handle_operator(Op, [Top|Ops], Output, [Op|[Top|Ops]], Output) :-
    precedence(Op, P1),
    precedence(Top, P2),
    P1 > P2.
handle_operator(Op, [Top|Ops], Output, NewOps, NewOutput) :-
    precedence(Op, P1),
    precedence(Top, P2),
    P1 =< P2,
    append(Output, [Top], NewOutput),
    handle_operator(Op, Ops, NewOutput, NewOps, _).

handle_closing_parenthesis(['('|Ops], Output, Ops, Output).
handle_closing_parenthesis([Top|Ops], Output, NewOps, NewOutput) :-
    append(Output, [Top], NewOutput),
    handle_closing_parenthesis(Ops, NewOutput, NewOps, _).

evaluate_postfix(Postfix, Result) :-
    evaluate_postfix_helper(Postfix, [], Result).

evaluate_postfix_helper([], [Result], Result).
evaluate_postfix_helper([Token|Tokens], Stack, Result) :-
    (   number(Token) ->
        evaluate_postfix_helper(Tokens, [Token|Stack], Result)
    ;   char_type(Token, alpha) ->
        (   variable(Token, Value) ->
            evaluate_postfix_helper(Tokens, [Value|Stack], Result)
        ;   throw(error(unknown_variable(Token)))
        )
    ;   member(Token, ['+', '-', '*', '/']) ->
        [Right, Left|Rest] = Stack,
        evaluate_operator(Token, Left, Right, Res),
        evaluate_postfix_helper(Tokens, [Res|Rest], Result)
    ).

evaluate_operator('+', Left, Right, Result) :- Result is Left + Right.
evaluate_operator('-', Left, Right, Result) :- Result is Left - Right.
evaluate_operator('*', Left, Right, Result) :- Result is Left * Right.
evaluate_operator('/', Left, Right, Result) :-
    (   Right =:= 0 ->
        throw('Error: cannot divide by zero')
    ;   Result is Left // Right
    ).

parse_and_evaluate(Input, Result) :-
    replace_whitespace(Input, CleanedInput), 
    atom_string(CleanedAtom, CleanedInput), 
    (   variable(CleanedAtom, Value) -> 
        Result = Value
    ;   sub_string(CleanedInput, Before, 1, After, "=") ->
        sub_string(CleanedInput, 0, Before, _, VarString),
        sub_string(CleanedInput, _, After, 0, Expr),
        atom_string(Var, VarString), 
        infix_to_postfix(Expr, Postfix),
        evaluate_postfix(Postfix, Value),
        retractall(variable(Var, _)), 
        assertz(variable(Var, Value)),
        Result = Value
    ;   infix_to_postfix(CleanedInput, Postfix),
        evaluate_postfix(Postfix, Result)
    ).

main :-
    write('Basic Arithmetic Calculator, type "exit." to exit'), nl,
    repeat,
    write('Enter expression below: '),
    read_line_to_string(user_input, Input),
    (   Input = "exit" ->
        write('Goodbye!'), nl, !
    ;   catch(parse_and_evaluate(Input, Result),
              Error,
              (write('> '), write(Error), nl, fail)),
        write('> '), write(Result), nl,
        fail
    ).