{-
Professor esse exercício tem a ver com lista usando indice e encontrei 
o mesmo no meu replit guardado;
-}

type Autores = [String]
type Musica  = (String, Int, Int)

bandas :: [Autores]
bandas = [ ["Gilberto Gil"],
           ["Victor","Leo"],
           ["Gonzagao"],
           ["Claudinho","Bochecha"] ]

musicas :: [Musica]
musicas = [ ("Aquele Abraco", 1, 100),
            ("Esperando na Janela", 1, 150),
            ("Borboletas", 2, 120),
            ("Asa Branca", 3, 120),
            ("Assum Preto", 3, 140),
            ("Vem Morena", 3, 200),
            ("Nosso Sonho", 4, 150),
            ("Quero te Encontrar", 4, 100) ]


map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (h:t) = f h:map' f t

filter' :: (a -> Bool) -> [a] -> [a]
filter' f [] = []
filter' f (h:t) = if (f h) then h:filter' f t else filter' f t

foldr' :: (b -> a -> a) -> a -> [b] -> a
foldr' f acc [] = acc
foldr' f acc (h:t) = f h (foldr' f acc t)

--Somente o nome das músicas
--["Aquele Abraco", "Esperando na Janela", ...]

nomes = map' namesOnly musicas

namesOnly :: Musica -> String
namesOnly (nome, _, _) = nome

--main = print (nomes)

--Somente músicas com >= 2min:
--[("Esperando...",1,150), ("Borboletas",2,120), ... ]

maior2 = filter' doisOnly musicas

doisOnly :: Musica -> Bool
doisOnly (nome, autor, duracao) = duracao >= 120

maior = foldr' checarMaiorDuracao 0 musicas

checarMaiorDuracao :: Musica -> Int -> Int
checarMaiorDuracao (nome, autor, duracao) acc = if duracao > acc then duracao else acc


--Nomes com >= 2min:
--["Esperando...", "Borboletas",, ... ]

nomesMaior = map' somenteNomesMaior maior2

somenteNomesMaior :: Musica -> String
somenteNomesMaior (nome, _, _) = (nome)

--Pretty-print música:
prettyPrint = map' bonito musicas

bonito :: Musica -> String
bonito (nome, autor, duracao) = "Nome: " ++ nome ++ "\n" ++
                                "Autores: " ++ (findAutor autor) ++ "\n" ++
                                "Duracao: " ++ (show duracao) ++ "\n" ++ "------------"

findAutor id = getAutores (bandas !! (id - 1))

getAutores [] = []
getAutores (h:t) = if t /= [] then h ++ " e " ++ getAutores t else h

main = putStrLn (unlines prettyPrint)