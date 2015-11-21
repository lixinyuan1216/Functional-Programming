%  File     : main.pl
%  Author   : Xinyuan Li
%  Problem  : Fill in a Puzzle square with numbers 1-9 and fulfill following constraints
%             1. each row column contains no repeated digits;
%	            2. all squares on the main diagonal line contain the same value;
%	            3. the heading of reach row and column holds either the sum or the product 
%		          of all the digits in that row or column.
%  Solution : The problem can be settled in two steps: filling diagonal and filling rows/columns
%	      1. Filling diagonal can be devided into two parts:
%		      1). All elements in the diagonal are digits of 1-9;
%		      2). All elements in the diagonal are the same.
% 	    2. Filling rows/columns can be devided into parts:
%		      1). Get all possible values sets for each row/column;
%		      2). Choose the row/column with least possible values sets;
%		      3). For each possible set, fill it in the Puzzle and get NPuzzle;
%		      4). Valid NPuzzle if it fulfills constriant 3;
%		      5). Repeat 1),2),3),4) until every elements in NPuzzle s filled by digit. 
%  Assumption: Every Puzzle only haves one solution, so the program will stop as long as 
%  it gets one corrent result.  

:- ensure_loaded(digit).
:- ensure_loaded(library(clpfd)).

% puzzle_solution(Puzzle) 
% puzzle_solution/1 calls puzzle_solution_help to get the results.
puzzle_solution(Puzzle) :-
	puzzle_solution_help(Puzzle, Result),
	Puzzle = Result.
	
% puzzle_solution_help/(Puzzle, Result)
% puzzle_solution_help/2 holds when all the squares are filled with numbers.
puzzle_solution_help(Result, Result) :-
	ground(Result).	
puzzle_solution_help(Puzzle, Result) :-
	sets(Puzzle, NPuzzle),
	puzzle_solution_help(NPuzzle, Result).

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Fill one row or one column.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
% sets(Puzzle, NPuzzle)
% sets/2 will fill in one row or column according to implementation strategy.
% That is: At first, fill in diagonal squares. Then transpose the Puzzle. 
% Compute least remaining solution sets for orginal and transposed Puzzle.
% Comapre the two sets and choose the smaller one and fill in that row.
% At last, valid each row and column in the new Puzzle.
% Note that if one row is filled, then only columns need to be valided,
% if one column is filled, then only rows need to be valided.
sets(Puzzle, NPuzzle) :-
	valid_diagonal(Puzzle),
	transpose(Puzzle, TPuzzle),	
	sets_help(Puzzle, Set1, Index1),
	sets_help(TPuzzle, Set2, Index2),
	length(Set1, Len1),
	length(Set2, Len2),
	(Len1 > Len2 -> (replace(TPuzzle, Index2, Ele, NTPuzzle), member(Ele, Set2), transpose(NTPuzzle, NPuzzle));
	(replace(Puzzle, Index1, Ele, NPuzzle), member(Ele, Set1))),
	transpose(NPuzzle, TPuzzle),
	valid_rows(TPuzzle).	

% sets_help(Puzzle, Set, Index) 
% sets_help/3 intends to initial the min set to [] and corresponding index to -1.	
sets_help(Puzzle, Set, Index) :-
	sets_help(Puzzle, [], -1, 0, Set, Index).
	
% set_help(Puzzle, Set0, Index0, I0, Set, Index)
% set_help/6 will get the minimum solution set and corresponding index.
sets_help([], Set, Index, _, Set, Index) .
sets_help([Head|Tail], Set0, Index0, I0, Set, Index) :-
	I1 is  I0+1,
	(ground(Head) -> sets_help(Tail, Set0, Index0, I1, Set, Index);
	(get_solutions(Head, TmpSet), 
	next_set(Set0, Index0, TmpSet, I0, NTmpSet, NTmpIndex), 
	sets_help(Tail, NTmpSet, NTmpIndex, I1, Set, Index))),
	!.		

% next_set(Set1, Index1, Set2, Index2, Set, Index)
% next_set/6 compare two sets and return the min one. 	 
next_set([], _, Set, Index, Set, Index). 	
next_set(Set1, Index1, Set2, Index2, Set, Index) :-
	length(Set1, Len1),
	length(Set2, Len2),
	(Len1 > Len2 -> (Set = Set2, Index = Index2);
	(Set = Set1, Index = Index1)).	

% replace(List0, Index, Ele, List)
% replace/4 replaces element according to the index.
replace([_|Tail], 0, Ele, [Ele|Tail]).
replace([Head|Tail], Index, Ele, [Head|Rest]) :- 
	Index > -1,
	NIndex is Index-1, 
	replace(Tail, NIndex, Ele, Rest), 
	!.

% get_solutions(Row, Set)
% get_solutions/2 gets all possible puzzle for one row.
% I uses setof instead of bagof because set of will remove duplicate elements.
% For example, 6 = 1 + 2 + 3, 6 = 1 * 2 * 3.
get_solutions(Row, Set) :-
	setof(Row, valid_row(Row), Set).

% valid_rows(Puzzle)
% valid_rows/1 valids rows after each replacement.
% A row needs to be valided only when it is filled completely. 
valid_rows([]).
valid_rows([Head|Tail]) :-
	(ground(Head) -> (valid_row(Head), valid_rows(Tail));
	valid_rows(Tail)).

% valid_row(List)	 
% valid_row/1 valids a row when the heading equals to 
% either the sum or the product of all the digits.
valid_row([0|_]).
valid_row([Head|Tail]) :-
	digits(Tail),
	is_set(Tail),
	(sum_list(Tail, Head);
	product_list(Tail, Head)).
	
% product_list(List, Product) 
% product_list/2 products all the elements in a list.
% I do not implement sum_list because it is a default predication.
product_list([], 1).
product_list([Head|Tail], Product) :-
	product_list(Tail, Rest),
   	Product is Head * Rest.
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Unify all the squares on the diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
% valid_diagonal(List)
% valid_diagonal/1 valids the main diagonal of the List.
% diagonal_formal/2 gets all the elements except for the first one in the main diagonal,
% digits/1 makes sure all the diagonal elements are among [1-9], 
% all_same/1 holds when all elements are same.
valid_diagonal(List) :-
	diagonal_formal(List, Diagonal),
	digits(Diagonal),
	all_same(Diagonal).

% digits(List)   	
% digits/1 holds when each element of the list is digit 1-9
digits(List) :- 
	maplist(digit, List).

% diagonal_formal(List, Diagonal)
% diagonal_formal/2 gets diagonal list without head element.
diagonal_formal([[Ele]],[Ele]) :-
	number(Ele).
diagonal_formal(List, Diagonal) :-
	diagonal(List, Diagonal0),
	list_split(Diagonal0, _, Diagonal).
	
% list_solit(List, Head, Tail)
% list_split/3 splits list into head and tail.	
list_split([Head|Tail], Head, Tail).

% diagonal(List, Diagonal)	
% diagonal/2 holds when the second list is the set of diagonal square of first list.
diagonal([],[]).
diagonal([[Head|_]|Rest],[Head|Tail]) :- 
	remove_heads(Rest, RRest), 
	diagonal(RRest, Tail).

% remove_heads(List0, List)
% remove_heads/2 holds when the first matrix removes head column to get the second matrix. 
remove_heads([],[]).
remove_heads([[_|Tail]|Rest],[Tail|RTail]) :- 
	remove_heads(Rest, RTail).

% all_same(List)
% all_same/1 holds when every element of List is identical.	
all_same(List) :-
	list_of(_, List).

% list_of(Ele, List).	
% list_of/2 holds when every element of List is Elt.
list_of(_, []).
list_of(Ele, [Ele|List]) :-
	list_of(Ele, List).
