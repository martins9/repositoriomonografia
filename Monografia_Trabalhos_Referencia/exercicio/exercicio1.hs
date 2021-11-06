-- Definição da lista parametrica
data Lista a = No a (Lista a) | Vazia deriving Show

--Assinatura da funcao filter1
filter1 :: (a -> Bool) -> Lista a -> Lista a

-- Definicao da funcao filter1
filter1 funcao Vazia = Vazia
filter1 funcao (No h t) = 
    if (funcao h) then No h (filter1 funcao t) 
    else (filter1 funcao t)

-- Calcular o tamanho de cada palavra
funcaoA v = (length v) > 3

l = (No "Banana" (No "Uva" (No "Abacate" Vazia)))

main = print (filter1 funcaoA l)