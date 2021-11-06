-- Definicao da arvore
data Arvore a = Galho (Arvore a) a (Arvore a) | Folha deriving Show

-- Criando uma arvore
a1 =  Galho (Galho Folha 10 Folha) 20 (Galho Folha 30 (Galho Folha 40 (Galho Folha 50 Folha)))

-- Definicao do Map
map' :: (a -> b) -> Arvore a -> Arvore b
map' f a1 =
    case a1 of
        Folha -> Folha
        (Galho num esquerda direita) -> Galho (map' f num) (f esquerda) (map' f direita)     

-- Aplicacao da funcao que sera aplicada pelo map
funcaoB v = v + 10

main = print( map' funcaoB a1)
