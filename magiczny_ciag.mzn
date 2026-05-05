% 1. Parametr n - liczba elementów
int: n;
set of int: range = 0..n-1;

% 2. Definicja tablicy - wartości od 0 do n-1
array[range] of var range: magic;

% --- WARUNEK GŁÓWNY (samoreferencyjny) ---
% Dla każdej liczby i, magic[i] musi być równe liczbie wystąpień i w tablicy
constraint forall(i in range) (
    magic[i] = sum(j in range) (bool2int(magic[j] == i))
);

% --- OGRANICZENIA NADMIAROWE (Redundant Constraints) ---
% Odkomentuj/zakomentuj te linie, aby porównać czas działania

% Ograniczenie sumy elementów: suma(magic[i]) = n
%constraint sum(magic) = n;

% Ograniczenie ważonej sumy: suma(magic[i] * i) = n
%constraint sum(i in range) (magic[i] * i) = n;


% --- CEL ---
solve satisfy;

% --- WYNIK ---
output ["magic = ", show(magic)];