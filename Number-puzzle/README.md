A number puzzle is a square grid of squares, each to be filled in with a single digit 1–9 satisfying these constraints:
1. Each row and each column contains no repeated digits.
2. All squares on the diagonal line from upper left to lower right contain the same value.
3. the heading of reach row and column holds either the sum or the product of all the digits in that row or column.
i.e.
   14 10 35
14 7  2   1
15 3  7   5
28 4  1   7

The main algorithm for the solution is filling the diagonal firstly, then filling one row or one column with smallest 
possible remaining solutions. Note that this process would cost quite a lot time when the problem size grows large.
