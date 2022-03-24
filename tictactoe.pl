:- dynamic(player/1).
:- dynamic(computer/1).

:- dynamic(player_side/1).

same(A, A).

different(A, B) :- \+ same(A,B).

full(A) :- player(A).
full(A) :- computer(A).

empty(A) :- \+ full(A).

get_value(1, 2).
get_value(2, 7).
get_value(3, 6).
get_value(4, 9).
get_value(5, 5).
get_value(6, 1).
get_value(7, 4).
get_value(8, 3).
get_value(9, 8).

all_full :- full(1), full(2), full(3), full(4), full(5), full(6), full(7), full(8), full(9).

is_winning_combination(A, B, C) :- 
    get_value(A, ValueA), get_value(B, ValueB), get_value(C, ValueC),
    15 is ValueA + ValueB + ValueC,
    different(A, B), different(B, C), different(A, C).

done :- computer(A), computer(B), computer(C),
        is_winning_combination(A, B, C),
        write('Computer won'), nl, close.

done :- player(A), player(B), player(C),
        is_winning_combination(A, B, C),
        write('You won!'), nl,  close.

done :- all_full, write('Draw'), nl, close.

close :- sleep(10), halt.

%reset :- retract(computer(_)), retract(player(_)), retract(player_side(_)).


print_square(N) :- player(N), player_side(1), write('| x |').
print_square(N) :- player(N), player_side(2), write('| o |').
print_square(N) :- computer(N), player_side(2), write('| x |').
print_square(N) :- computer(N), player_side(1), write('| o |').
print_square(N) :- empty(N), write('|    |').

print_board :- print_square(1), print_square(2), print_square(3), nl,
                print_square(4), print_square(5), print_square(6), nl,
                print_square(7), print_square(8), print_square(9), nl.

play :- get_side, start. 

get_side :- repeat, write('Choose the playing side: '), nl, write('1) x'), nl, write('2) o'), nl,
            read(X), X >= 1, X =< 2, assert(player_side(X)).

start :- player_side(1), repeat, get_move, make_move, print_board, done.

start :- player_side(2), repeat, make_move, print_board, not(done), get_move, done.

get_move :- repeat, write('Please, enter a move: '), read(X),
            integer(X), X >= 1, X =< 9, empty(X), assert(player(X)), !.

make_move :- move(X), assert(computer(X)).
make_move :- all_full.

move(A) :- good(A), empty(A), !.

good(A) :- win(A).
good(A) :- block_win(A).
good(A) :- fork(A).
good(A) :- block_fork(A).
good(A) :- build(A).
good(5).
good(1). good(3). good(7). good(9).
good(2). good(4). good(6). good(8).


win(A) :- computer(B), computer(C), is_winning_combination(A, B, C).

block_win(A) :- player(B), player(C), is_winning_combination(A, B, C).

fork(A) :- computer(B), computer(C), different(B, C), 
           is_winning_combination(A, B, D), is_winning_combination(A, C, E),
           empty(D), empty(E).

block_fork(A) :- player(B), player(C), different(B, C), 
                 is_winning_combination(A, B, D),  is_winning_combination(A, C, E),
                 empty(D), empty(E).

build(A) :- player(B), is_winning_combination(A,B,C), empty(C).