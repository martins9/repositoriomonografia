-- Definicao de arvore
data Arvore a = Galho (Arvore a) a (Arvore a) | Folha deriving Show
    
-- Definicao de lista
data Lista a = No a (Lista a) | Vazia deriving Show

-- Cricao de lista
--a1 = Galho (Galho Folha 2 Folha) 4 (Galho Folha 6 (Galho Folha 8 (Galho Folha 12 Folha)))
a1= Galho (Galho Folha 2 Folha)4(Galho Folha 6 (Galho Folha 8 Folha))
 
-- Funcao pegando parte da arvore de esquerda   
lista :: Arvore a -> Lista a    
lista Folha = Vazia 
lista (Galho esq num dir) = No num (lista esq)

-- Funcao pegando parte da arvore de direita
lista2 :: Arvore a -> Lista a
lista2 Folha = Vazia 
lista2 (Galho esq num dir) = No num (lista2 dir)

-- Aplicao da funcao
z = lista a1
z1 =  lista2 a1

-- Concatenando o resultado das listas
z2 = concat[show z, show z1]

main = print(z2)