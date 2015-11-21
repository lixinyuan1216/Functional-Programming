A "combination" is defined as a composer of one letter from {A, B, C, D, E, F, G} and one digit from {1, 2, 3}, i.e. A3, G1.

The game is initialized by selecting three distinct combination as a target, i.e. [A2, B1, G2]. 
1. The application will guess the target.
2. The application will get the corresponding feedback.
3. According to the feedback, the application makes the next guess, repeats step 2 until it gets the target.

Feedback rule:
Feedback contains three number.
The first one means the number of right letters and right digits.
The second one means the number of right letters and wrong digits.
The third one means the number of wrong letters and right digits.
i.e.
Target      Guess    Feedback
A1,B2,A3  A1,A2,B1    1,2,1
A1,B2,C3  A1,A2,A3    1,0,2
A1,B1,C1  A2,D1,E1    0,1,2
A3,B2,C1  C3,A2,B1    0,3,3


The main algorithm for the solution is computing the worst situation with largest remaining targets set for each possible guess.
