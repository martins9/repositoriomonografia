--listaAcoes=[(Sigla Acao, Valor Atual Acao, Valorizacao da acao dos ult.12meses)]

listaAcoes=[("BBAS3",23.39,10.99),
            ("AESB3",14.50,13.42),
            ("PETR4",26.99,37.35),
            ("CPLE6",6.47,18.72),
            ("RRRP3",40.90,95.69),
            ("ALUP11",27.14,11.64),
            ("ABEV3",17.85,45.60),
            ("ALSO3",30.03,10.89),
            ("CBEE3",25.06,57.12),
            ("ARZZ3",89.03,109.78),
            ("ALPA4",47.03,83.71),
            ("ANIM3",12.61,66.14),
            ("CRFB3",21.91,22.47),
            ("BAZA3",40.20,32.67),
            ("BGIP4",23.19,2.66)]


-- Sigla da acao 
func1(v1,v2,v3)=v1

-- Valor da acao
func2(v1,v2,v3)=v2

-- Valorizacao da acao dos ult.12meses
func3(v1,v2,v3)=v3

-- >>>> Calculando a media <<<<
listaL2=map func2 listaAcoes

-- Calculando o valor das somas
somaAcoes=foldr (+) 0 listaL2

tamanhoListaAcoes=length listaL2
media = somaAcoes/ fromIntegral tamanhoListaAcoes

-- Acoes que valorizacao menos de 50
funcA(v1,v2,v3)=v3 < 50.0

-- Acoes com preco maior que a media
funcB(v1,v2,v3)=v2 > media

-- Acoes com valores maiores de 20 e menores 50 
funcC(v1,v2,v3)=v2 > 30.00 && v2 < 100.00

-- Filtrando Acoes com valorizacao menor que 50 
a = filter funcA listaAcoes

-- Filtrando Acoes com preco maior que a media
b = filter funcB listaAcoes 

-- Pegando as siglas das acoes
c = map func1 b

-- Pegando as acoes com valores entre 20 e 50
d = filter funcC listaAcoes

-- Simulando a compra de 10 acoes 
funcD(v1,v2,v3)=v2*10
e = map funcD d

-- Calculando o valor total da compra
f = foldr (+) 0 e

main = print f