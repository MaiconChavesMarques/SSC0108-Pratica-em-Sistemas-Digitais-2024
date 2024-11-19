#Aqui vai o nome do arquivo com o código
file_codigo = open("codigo.txt", "r")

linhas = file_codigo.read().split("\n")
file_codigo.close()

tabela_instruções = {
    'add':'0000', 'sub':'0001', 'and':'0010', 'or':'0011', 'not':'0100',
    'cmp':'0101', 'jmp':'0110', 'jeq':'0111', 'jgr':'1000', 'load':'1001',
    'store':'1010', 'mov':'1011', 'in':'1100', 'out':'1101', 'wait':'1110', 'my':'1111'
}

file_binario =  open("codigo_compilado.mif", "w")

cabeçalho = '''DEPTH = 256;
WIDTH = 8;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN
'''

file_binario.write(cabeçalho)

cont_linhas = 0

for linha in linhas:
    if(linha.startswith("#")):
        continue

    itens_linha = linha.split(" ")
    buffer_linha = ''
    buffer_prox_linha = '' #Para pegar o valor imediato/endereço

    #Identifica qual instrução
    if(itens_linha[0].lower() in tabela_instruções):
        buffer_linha += tabela_instruções[itens_linha[0].lower()]
    

        #Instruções que o único parâmetro é um endereço
    if(itens_linha[0].lower() in ['jmp', 'jeq', 'jgr']):
        buffer_linha += '0000' #Tag para endereço
        buffer_prox_linha = itens_linha[1]
    

        #Instruções que sempre tem um registrador e um endereço
    if(itens_linha[0].lower() in ['store', 'load']):
        
        #Ve o primeiro parâmetro
        if(itens_linha[1].lower() == 'a'):
            buffer_linha += '00'
        else:
            if(itens_linha[1].lower() == 'b'):
                buffer_linha+= '01'
            else:
                if(itens_linha[1].lower() == 'r'):
                    buffer_linha += '10'
                else:
                    buffer_linha += '11'
    
        buffer_linha += '11' #Tag de endereço

        buffer_prox_linha = itens_linha[2]
    


        #Instruções que sempre tem 1 registrador como parâmetro
    if(itens_linha[0].lower() in ['not', 'in', 'out']):
        
        #Ve o primeiro parâmetro
        if(itens_linha[1].lower() == 'a'):
            buffer_linha += '00'
        else:
            if(itens_linha[1].lower() == 'b'):
                buffer_linha+= '01'
            else:
                if(itens_linha[1].lower() == 'r'):
                    buffer_linha += '10'
                else:
                    buffer_linha += '11'
        
        buffer_linha += '11' #Padding pra completar 8 bits
    
        #Instruções com 2 parâmetros (1º é sempre registrador e o 2º pode ser registrador ou valor imediato)
    if(itens_linha[0].lower() in ['add', 'sub', 'and', 'or', 'cmp', 'mov']):
        
        #Ve o primeiro parâmetro
        if(itens_linha[1].lower() == 'a'):
            buffer_linha += '00'
        else:
            if(itens_linha[1].lower() == 'b'):
                buffer_linha+= '01'
            else:
                if(itens_linha[1].lower() == 'r'):
                    buffer_linha += '10'
                else:
                    print("Parâmetro errado")
        
        #Ve o segundo parâmetro
        if(itens_linha[2].lower() == 'a'):
            buffer_linha += '00'
        else:
            if(itens_linha[2].lower() == 'b'):
                buffer_linha+= '01'
            else:
                if(itens_linha[2].lower() == 'r'):
                    buffer_linha += '10'
                else:
                    buffer_linha += '11'
                    buffer_prox_linha = itens_linha[2]

        #wait e my ?
    if(itens_linha[0].lower() in ['wait']):
        buffer_linha += '0000' #padding

    print(buffer_linha)
    print(buffer_prox_linha)
    

    file_binario.write(hex(cont_linhas).replace("0x", "").rstrip("L").upper() + "  : " + buffer_linha + ";\n")
    cont_linhas+=1

    if(buffer_prox_linha != ''):
        file_binario.write(hex(cont_linhas).replace("0x", "").rstrip("L").upper() + "  : " + buffer_prox_linha + ";\n")
        cont_linhas+=1
    
file_binario.write("END;")
file_binario.close()