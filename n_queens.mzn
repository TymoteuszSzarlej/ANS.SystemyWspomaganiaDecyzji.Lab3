include "alldifferent.mzn";
include "inverse.mzn";

% 1. Parametr N
int: N; 

% 2. Zmienne decyzyjne
array[1..N] of var 1..N: rows; % rows[i] to wiersz dla królowej w kolumnie i
array[1..N] of var 1..N: cols; % cols[r] to kolumna dla królowej w wierszu r

% --- OGRANICZENIA ---

% A. Podstawowe: Różne wiersze i kolumny
constraint alldifferent(rows);
constraint alldifferent(cols);

% B. Przekątne (wykorzystujemy tablicę rows)
constraint alldifferent([rows[i] + i | i in 1..N]);
constraint alldifferent([rows[i] - i | i in 1..N]);

% C. Przekątne dla kolumn (dodatkowe, opcjonalne, ale przyspiesza)
% constraint alldifferent([cols[i] + i | i in 1..N]);
% constraint alldifferent([cols[i] - i | i in 1..N]);

% D. Klucz programu: Powiązanie tablic (Odwrócenie)
constraint inverse(rows, cols);

% --- CEL ---
solve satisfy;

% --- WYNIK ---
output [
    if fix(rows[c]) == r then "Q " else ". " endif ++
    if c == N then "\n" else "" endif
    | r, c in 1..N
];