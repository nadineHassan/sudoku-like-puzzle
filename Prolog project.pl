length1([],0).            %helper
length1([H|T],N):-       %checks that agiven list have length N
    length1(T,N1),
     N is N1+1.


    
grid_build(N,G):-  grid_build_helper(N,G,N).        %checks that a matrix is N*N 


grid_build_helper(_,[],0).                 %helper
grid_build_helper(N,[H|T],X):-            %checks a matrix is N*N
      X>0,                         
      X1 is X-1, 
      length(H,N),
      grid_build_helper(N,T,X1).


 
all_elements_valid([],N).            %helper
all_elements_valid([H|T],N):-        %checks that all elemets are in the range of N         
                 H>=1,
                 H=<N,
                all_elements_valid(T,N).
                 


grid_gen(N,[H|T]):-              %checks that all elements are within the range of N  
    grid_build(N,[H|T]),
    grid_fill(N,N,[H|T]),
    grid_gen_helper(N,[H|T]).


grid_gen_helper(_,[]).          %checks that all elements are within the   range of N
grid_gen_helper(N,[H|T]):-
    all_elements_valid(H,N),
    grid_gen_helper(N,T).



num_gen(L,L,[L|[]]).                   
num_gen(F,L,[F|T]):-              %generates a list from F to L
    F=<L,
    F1 is F+1,
    num_gen(F1,L,T).


check_num_grid(G):-
length(G,N),              %checks that if i have X in grid then i must have all numbers from 1 to X-1
get_max_grid(G,1,D),
D=<N,  
num_gen(1,D,V),
check_all_present(V,G).

get_max_grid([],N,N).
get_max_grid([H|T],A,N):-
max_list(H,B),
max(B,A,M),
get_max_grid(T,M,N).

max(M,N,M):-M>=N.        
max(M,N,N):-N>M.


check_all_present([],_).                                        %helper 
check_all_present([H|T],G):-                                %checks a list is present in matrix
            check_element_present(H,G),
            check_all_present(T,G).

check_element_present(H,[F|L]):-
       check_element_present_helper(H,F).
check_element_present(H,[F|L]):-                                %helper
          \+check_element_present_helper(H,F),                  %checks an element  is present in matrix
             check_element_present(H,L).


check_element_present_helper(H,[H|L]).                         %helper
check_element_present_helper(H,[F|L]):-                        %checks a element is present in a row of matrix
F\=H,                        
check_element_present_helper(H,L).



grid_fill(0,_,[]).                   %helper
grid_fill(C,N,[H|T]):-               %fills all grid with all possible values
C>0,
list_fill(N,N,H),
C1 is C-1,
grid_fill(C1,N,T). 

           

list_fill(0,_,[]).                %helper
list_fill(C,N,[H|T]):-            %fills a list with al possible values
C1 is C-1,
C>0,
all_possible(1,N,H),
list_fill(C1,N,T).




all_possible(B,B,B).              %helper
all_possible(A,B,A):-             %brings all possible values of a number between 1 and N
A<B.
all_possible(A,B,H):-
A<B,
A1 is A+1,
all_possible(A1,B,H).



trans([H|T],[]):-                    %gets transpose of  a matrix
H=[].                       
trans([H|T],[F|L]):-
         H=[X|Y],
	get_first([H|T],F),
	remove_first([H|T],M1),
	trans(M1,L).


get_first([H],[F]):-     %gets first eement from each list in a matrix
H=[X|Y],
F=X.
get_first([H,H1|T],[F|L]):-
H=[X|Y],
F=X,
get_first([H1|T],L).




remove_first([H],[F]):-    %removes first element from each list in a  matrix
H=[X|Y],
F=Y.
remove_first([H,H1|T],[F|L]):-
H=[X|Y],
F=Y,
remove_first([H1|T],L).




acceptable_distribution([]).     % checks that no row is the same as a colum with same index
acceptable_distribution(G):-
trans(G,G1),
not_same(G,G1).



not_same([],[]).                  %helper
not_same([H|T],[F|L]):-           %checks a matrix with its transpose that each row is not as the other at same index
H\=F,
not_same(T,L).


distinct_rows([]).            %checks no two rows are the same
distinct_rows([H|T]):-
not_present(H,T),
distinct_rows(T).



not_present(H,[]).         %helper
not_present(H,[A|B]):-     %checks that a given list is not repeated inside a matrix
H\=A,
not_present(H,B).




distinct_columns([]).       %checks no two columns are the same
distinct_columns(G):-
trans(G,[H|T]),
distinct_rows([H|T]).




row_col_match([H|T]):-
trans([H|T],[F|L]),
length1([H|T],N),
row_col_match_helper([H|T],[F|L],1,N).

row_col_match_helper([],_,_,_).             %helper
row_col_match_helper([H|T],[F|L],A,B):-     %checks that a row is present in transpose of a matrix  but not 
remove_nth([F|L],A,M),
\+not_present(H,M),
A1 is A+1,
A=<B,
row_col_match_helper(T,[F|L],A1,B).


remove_nth([H|T],1,T).        %helper
remove_nth([H|T],A,[H|R]):-   %removes Nth list from matrix
A>1,
A1 is A-1,
remove_nth(T,A1,R).



acceptable_permutation([],[]).         % chechs no element in permutation is present in the same place
acceptable_permutation(L,R):-
permutation(L,R),
check_elements_at_diff_positions(L,R).


check_elements_at_diff_positions([],[]).             %helper
check_elements_at_diff_positions([H|T],[F|L]):-      %checks two list does not have the same element at the same position
H\=F,
check_elements_at_diff_positions(T,L).


helsinki(N,G):-           %puzzel
grid_gen(N,G),
check_num_grid(G),
acceptable_distribution(G),
distinct_columns(G),
row_col_match(G),
distinct_rows(G).
