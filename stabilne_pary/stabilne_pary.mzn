include "alldifferent.mzn";

% --- PARAMETRY ---
int: n;

% Tablice z imionami (dodane, aby pasowały do plików .dzn)
array[1..n] of string: m_names;
array[1..n] of string: w_names;

% Macierze rankingów: ranks[osoba_oceniana, osoba_oceniająca]
array[1..n, 1..n] of int: m_ranks; 
array[1..n, 1..n] of int: w_ranks;

% --- ZMIENNE DECYZYJNE ---
array[1..n] of var 1..n: wives;    % wives[m] = która kobieta jest żoną m
array[1..n] of var 1..n: husbands; % husbands[w] = który mężczyzna jest mężem w

% --- PREDYKATY POMOCNICZE (z var int) ---
% Czy osoba s woli p1 bardziej niż p2?
predicate prefers_over(array[1..n, 1..n] of int: ranks, int: s, var int: p1, var int: p2) =
    ranks[p1, s] < ranks[p2, s];

predicate man_prefers_over(int: m, var int: w1, var int: w2) =
    prefers_over(m_ranks, m, w1, w2);

predicate woman_prefers_over(int: w, var int: m1, var int: m2) =
    prefers_over(w_ranks, w, m1, m2);

% --- OGRANICZENIA ---

% 1. Spójność wzajemna
constraint forall(m in 1..n)(husbands[wives[m]] = m);
constraint forall(w in 1..n)(wives[husbands[w]] = w);

% 2. Stabilność par
constraint forall(m in 1..n, w in 1..n) (
    man_prefers_over(m, w, wives[m]) -> woman_prefers_over(w, husbands[w], m)
);

% 3. Ograniczenia nadmiarowe
constraint alldifferent(wives);
constraint alldifferent(husbands);

% 4. Zakotwiczenie (Zadanie 5.4 - opcjonalne, odkomentuj dla testu)
% constraint wives[1] = 2; 

% 5. Łamanie symetrii (Zadanie 5.5 - opcjonalne, zakomentowane by zobaczyć wszystkie imiona naturalnie)
% constraint wives[1] < wives[2];

% --- CEL ---
solve satisfy;

% --- WYNIK (Zaktualizowany o imiona) ---
output [
    "--- STABILNE PARY ---\n"
] ++ [
    "Mąż: \(m_names[m]) \t-> Żona: \(w_names[fix(wives[m])])\n" | m in 1..n
];