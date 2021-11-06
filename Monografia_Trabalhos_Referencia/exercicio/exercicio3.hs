def fmap(funcao_aplicada, array_aplicado): 
    resultado = [] 
    for i in array_aplicado: 
        resultado.append(funcao_aplicada(i)) 
    return resultado 
    
def dobro(n):
    return 2 * n

numeros = (1, 2, 3, 4)
resultado = fmap(dobro, numeros)
print(list(resultado))