-- Definicao de Lista
data Lista a = No a (Lista a) | Vazia deriving Show

-- Definicao da funcao fold'
fold' :: (a -> b -> b) -> b -> Lista a -> b
fold' f acc Vazia = acc
fold' f acc (No h t) = f h (fold' f acc t)

-- Definicao da funcao soma
soma :: Int -> Int -> Int
soma v1 v2 = v1+v2


main = print (fold' soma 0 (No 1 (No 2 (No 3 (No 4 Vazia)))))