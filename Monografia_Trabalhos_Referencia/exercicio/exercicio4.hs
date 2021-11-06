data Arvore a = Galho a (Arvore a) (Arvore a) | Folha deriving Show

-- Função que conta a quatidade de Folhas em uma Arvore
contaFolha :: Arvore a -> Int
contaFolha Folha         = 1
contaFolha (Galho _ e d) = (contaFolha e) + (contaFolha d)

a1 = Galho 10 (Galho 20 Folha Folha) (Galho 30 Folha Folha)

main = print (contaFolha a1)