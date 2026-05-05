include "globals.mzn"; % Wymagane dla lex_less i at_most

% --- PARAMETRY ---
int: items_n;
int: knapsacks_n;
int: capacity;
array[1..items_n] of int: values;
array[1..items_n] of int: weights;

% --- ZMIENNE DECYZYJNE ---
% Macierz: taken[i, j] = 1 oznacza, że przedmiot j jest w plecaku i
array[1..knapsacks_n, 1..items_n] of var 0..1: taken;

% --- OGRANICZENIA ---

% 1. Każdy przedmiot trafia do MAKSYMALNIE jednego plecaka
% Suma po kolumnie (dla przedmiotu j) nie może przekroczyć 1
constraint forall(j in 1..items_n) (
    sum(i in 1..knapsacks_n)(taken[i, j]) <= 1
);

% 2. Nie przekraczamy pojemności każdego z plecaków
constraint forall(i in 1..knapsacks_n) (
    sum(j in 1..items_n)(taken[i, j] * weights[j]) <= capacity
);

% 3. ŁAMANIE SYMETRII (lex_less)
% Skoro plecaki są identyczne, zmuszamy solver, by wypełniał je w określonej kolejności
% Zapobiega to sprawdzaniu tych samych układów w innych torbach
constraint forall(i in 1..knapsacks_n-1) (
    lex_less(row(taken, i), row(taken, i+1))
);

% --- CEL ---
% Maksymalizujemy sumę wartości wszystkich spakowanych przedmiotów
var int: total_value = sum(i in 1..knapsacks_n, j in 1..items_n) (
    taken[i, j] * values[j]
);

solve maximize total_value;

% --- WYNIK ---
output [
    "Całkowita wartość: \(total_value)\n",
    "Plecaki:\n"
] ++ [
    "Plecak \(i): " ++ show([j | j in 1..items_n where taken[i, j] == 1]) ++ "\n"
    | i in 1..knapsacks_n
];