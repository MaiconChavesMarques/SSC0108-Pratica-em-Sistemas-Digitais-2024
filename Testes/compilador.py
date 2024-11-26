#Aqui vai o nome do arquivo com o código
file_codigo_in = open("codigo.txt", "r")

linhas = file_codigo_in.read().split("\n")
file_codigo_in.close()

tabela_instruções = {
    'add':'0000', 'sub':'0001', 'and':'0010', 'or':'0011', 'not':'0100',
    'cmp':'0101', 'jmp':'0110', 'jeq':'0111', 'jgr':'1000', 'load':'1001',
    'store':'1010', 'mov':'1011', 'in':'1100', 'out':'1101', 'wait':'1110', 'my':'1111'
}

file_codigo_out =  open("codigo_compilado.mif", "w")

cabeçalho = '''DEPTH = 256;
WIDTH = 8;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN
'''

file_codigo_out.write(cabeçalho)

labels = {}

cont_linhas = 0

for linha in linhas:
    #Ignora comentários e linhas vazias
    if(linha.startswith("#") or linha ==""):
        continue

    itens_linha = linha.lower().split(" ")
    buffer_linha = ''
    buffer_prox_linha = '' #Para pegar o valor imediato/endereço

    #Identifica qual é a instrução, checando se é uma palavra reservada
    if(itens_linha[0] in tabela_instruções):
        buffer_linha += tabela_instruções[itens_linha[0]]

        if(itens_linha[0] in ['jmp', 'jeq', 'jgr']):
            buffer_linha += '0000' #Tag para endereço
            buffer_prox_linha = labels[itens_linha[1]]
        

            #Instruções que sempre tem um registrador e um endereço
        if(itens_linha[0] in ['store', 'load']):
            
            #Ve o primeiro parâmetro
            if(itens_linha[1] == 'a'):
                buffer_linha += '00'
            else:
                if(itens_linha[1] == 'b'):
                    buffer_linha+= '01'
                else:
                    if(itens_linha[1] == 'r'):
                        buffer_linha += '10'
                    else:
                        buffer_linha += '11'
        
            buffer_linha += '11' #Tag de endereço

            buffer_prox_linha = itens_linha[2]
        


            #Instruções que sempre tem 1 registrador como parâmetro
        if(itens_linha[0] in ['not', 'in', 'out']):
            
            #Ve o primeiro parâmetro
            if(itens_linha[1] == 'a'):
                buffer_linha += '00'
            else:
                if(itens_linha[1] == 'b'):
                    buffer_linha+= '01'
                else:
                    if(itens_linha[1] == 'r'):
                        buffer_linha += '10'
                    else:
                        buffer_linha += '00'
            
            buffer_linha += '00' #Padding pra completar 8 bits
        
            #Instruções com 2 parâmetros (1º é sempre registrador e o 2º pode ser registrador ou valor imediato)
        if(itens_linha[0] in ['add', 'sub', 'and', 'or', 'cmp', 'mov']):
            
            #Ve o primeiro parâmetro
            if(itens_linha[1] == 'a'):
                buffer_linha += '00'
            else:
                if(itens_linha[1] == 'b'):
                    buffer_linha+= '01'
                else:
                    if(itens_linha[1] == 'r'):
                        buffer_linha += '10'
                    else:
                        print("Parâmetro errado")
            
            #Ve o segundo parâmetro
            if(itens_linha[2] == 'a'):
                buffer_linha += '00'
            else:
                if(itens_linha[2] == 'b'):
                    buffer_linha+= '01'
                else:
                    if(itens_linha[2] == 'r'):
                        buffer_linha += '10'
                    else:
                        buffer_linha += '11'
                        buffer_prox_linha = itens_linha[2]

            #wait e my ?
        if(itens_linha[0] in ['wait']):
            buffer_linha += '0000' #padding
    #Se não é nem comentário e nem uma das palavras reservadas é label
    else:
        labels[itens_linha[0]] = cont_linhas
        continue
    
    file_codigo_out.write(hex(cont_linhas).replace("0x", "").rstrip("L").upper() + "  : " + buffer_linha + ";\n")
    cont_linhas+=1

    if(buffer_prox_linha != ''):
        file_codigo_out.write(hex(cont_linhas).replace("0x", "").rstrip("L").upper() + "  : " + buffer_prox_linha + ";\n")
        cont_linhas+=1
    
while cont_linhas < 256:
    file_codigo_out.write(hex(cont_linhas).replace("0x", "").rstrip("L").upper() + "  : 00000000;\n")
    cont_linhas+=1

    
file_codigo_out.write("END;")
file_codigo_out.close()
