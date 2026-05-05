% --- DEKLARACJE DANYCH (Zgodne z Twoim plikiem .dzn) ---
int: nodesNumber;
int: minColorsNumber;
array[1..minColorsNumber] of int: maxClique; % W dzn masz listę [1,2,3], więc to tablica
array[1..nodesNumber, 1..nodesNumber] of bool: edges;

% --- ZMIENNE ---
array[1..nodesNumber] of var 1..nodesNumber: nodes;
var 1..nodesNumber: colorsNumber;

% --- OGRANICZENIA ---

% 1. Kolorowanie grafu na podstawie MACIERZY sąsiedztwa
% Jeśli edges[i,j] jest true, to wierzchołki i oraz j muszą mieć różne kolory
constraint forall(i in 1..nodesNumber, j in 1..nodesNumber) (
    if edges[i, j] then nodes[i] != nodes[j] else true endif
);

% 2. Definicja liczby kolorów
constraint colorsNumber = max(nodes);

% 3. ŁAMANIE SYMETRII (zgodnie z Twoimi danymi)
% maxClique to lista wierzchołków [1, 2, 3], które tworzą klikę
% Przypisujemy im kolory 1, 2, 3...
constraint forall(i in 1..minColorsNumber) (
    nodes[maxClique[i]] = i
);

% --- CEL ---
solve minimize colorsNumber;

% --- WYNIK ---
output ["Liczba kolorów: \(colorsNumber)\nNodes: \(nodes)"];