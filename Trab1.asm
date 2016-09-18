# Autores : Felipe da Costa Malaquias e Lucas Mota Ribeiro
# OAC 2/2016

.data
# Mota, mudei pra 72 pq double ocupa dobro de espaco,
# No final do programa, a matriz U vai estar em matriz e a matriz L em matriz_l (duh)
matriz: .space 72
matriz_l: .space 72
msg1: .asciiz "Qual o numero de linhas? <ENTER>\n"
msg2: .asciiz "Qual o numero de colunas? <ENTER>\n"
elemento: .asciiz "Elemento "
barra: .asciiz "-"
dois_pontos: .asciiz ": "
quebra_linha: .asciiz "\n"
space: .asciiz "  "
limpa_console: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n" # Imprime isso pra limpar o console


.text
# Pegando o numero de linhas
li $v0, 4
la $a0, msg1
syscall

li $v0, 5
syscall

add $s0, $v0, $zero # Guarda o valor no s0

# Pega o numero de colunas
li $v0, 4
la $a0, msg2
syscall

li $v0, 5
syscall

add $s1, $v0, $zero # Guarda o valor no s1

# Pega os valores da matriz um por vez

li $t2, 0 # Loop counter para linha
li $t3, 0 # Loop counter para coluna

# Loop que pega uma linha inteira da matriz
LOOP_LINHA:
# Imprimindo Elemento x-y: 
li $v0,4
la $a0, elemento
syscall

li $v0,1
add $a0, $t3, $zero
syscall

li $v0,4
la $a0, barra
syscall
 
li $v0, 1
add $a0, $t2, $zero
syscall

li $v0, 4
la $a0, dois_pontos
syscall
# Acabou de imprimir Elemento x-y:

# Pega o elemento
li $v0, 7
syscall

# Posicao do proximo elemento na linha em words
sll $t0, $t2, 3

# Calculando o offset pro numero cair na coluna certa
sll $t1, $s1, 3
mult $t1, $t3
mflo $t1

# Soma da posicao na linha + offset
add $t4, $t0, $t1
sdc1 $f0, matriz($t4)

addi $t2, $t2, 1 # Vai pro proximo elemento da linha
bne $t2, $s0, LOOP_LINHA

li $t2, 0 # Volta pro primeiro elemento da linha
addi $t3, $t3, 1 # Vai pra proxima coluna
bne $t3, $s1, LOOP_LINHA

# Nesse ponto a matriz ja esta pronta, $s0 guarda o numero de linhas e $s1 o numero de colunas
move $a0, $s0
move $a1, $s1
jal IMPRIME_MATRIZ

move $a0, $s0
move $a1, $s1
jal MATRIZ_LU
li $v0,4
la $a0, limpa_console
syscall
move $a0, $s0
move $a1, $s1
jal IMPRIME_MATRIZ

li $v0,4
la $a0, quebra_linha
syscall

move $a0, $s0
move $a1, $s1
jal IMPRIME_MATRIZ_L
j EXIT




# Subrotina que imprime a matriz
# Recebe $a0 = Numero de Linhas, $a1 = Numero de Colunas
IMPRIME_MATRIZ:
# Stacking
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $t4, 16($sp)
sw $t5, 20($sp)


# Body
move $t0, $a0
move $t1, $a1

li $t2, 0 # Contador de linhas
li $t3, 0 # Contador de colunas



IMPRIME_MATRIZ_LOOP: # Loop da funcao

# Calculando linha do elemento
sll $t4, $t2, 3

# Calculando coluna
sll $t5, $t3, 3
mult $t5, $t1
mflo $t5

add $t4, $t4, $t5
ldc1 $f12, matriz($t4) # Carrega valor que vai ser impresso em lw

# Imprime valor + espaco
li $v0, 3
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1 # Vai pro proximo elemento da linha
bne $t2, $t0, IMPRIME_MATRIZ_LOOP # Se n tiver acabado volta pro loop

# Imprime quebra de linha pra mudar de coluna
li $v0, 4
la $a0, quebra_linha
syscall

addi $t3, $t3, 1 # Muda a coluna
li $t2, 0 # Zera o contador do elemento na linha
bne $t3, $t1, IMPRIME_MATRIZ_LOOP # Se n tiver acabado volta pro loop

#Unstacking
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t5, 20($sp)
addi $sp, $sp, 24

jr $ra # Fim da funcao



# Subrotina que imprime a matriz
# Recebe $a0 = Numero de Linhas, $a1 = Numero de Colunas
IMPRIME_MATRIZ_L:
# Stacking
addi $sp, $sp, -24
sw $t0, 0($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)
sw $t4, 16($sp)
sw $t5, 20($sp)
# Body
move $t0, $a0
move $t1, $a1

li $t2, 0 # Contador de linhas
li $t3, 0 # Contador de colunas



IMPRIME_MATRIZ_L_LOOP: # Loop da funcao

# Calculando linha do elemento
sll $t4, $t2, 3

# Calculando coluna
sll $t5, $t3, 3
mult $t5, $t1
mflo $t5

add $t4, $t4, $t5
ldc1 $f12, matriz_l($t4) # Carrega valor que vai ser impresso em lw

# Imprime valor + espaco
li $v0, 3
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1 # Vai pro proximo elemento da linha
bne $t2, $t0, IMPRIME_MATRIZ_L_LOOP # Se n tiver acabado volta pro loop

# Imprime quebra de linha pra mudar de coluna
li $v0, 4
la $a0, quebra_linha
syscall

addi $t3, $t3, 1 # Muda a coluna
li $t2, 0 # Zera o contador do elemento na linha
bne $t3, $t1, IMPRIME_MATRIZ_L_LOOP # Se n tiver acabado volta pro loop

#Unstacking
lw $t0, 0($sp)
lw $t1, 4($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t5, 20($sp)
addi $sp, $sp, 24

jr $ra # Fim da funcao




# Funcao que troca duas linhas da matriz de lugar (pivoting)
# Recebe $a0 = num de linhas, $a1 = num de colunas, $a2 = linha1, $a3 = linha2
TROCA_LINHA:
# Stacking
addi $sp, $sp, -36
sdc1 $f0, 0($sp)
sdc1 $f2, 8($sp)
sw $t0, 16($sp)
sw $t1, 20($sp)
sw $t2, 24($sp)
sw $t3, 28($sp)
sw $t4, 32($sp)
# Body
li $t0, 0

sll $t1, $a1, 3
mult $t1, $a2
mflo $t1 # Primeiro elemento da linha 1

sll $t2, $a1, 3
mult $t2, $a3
mflo $t2 # Primeiro elemento da linha 2

TROCA_LINHA_LOOP:
sll $t4, $t0, 3

add $t3, $t1, $t4
ldc1 $f0, matriz($t3) # Pega elemento da linha 1

add $t3, $t2, $t4
ldc1 $f2, matriz($t3) # Pega elemento da linha 2

sdc1 $f0, matriz($t3)

add $t3, $t1, $t4

sdc1 $f2, matriz($t3)

addi $t0, $t0, 1
bne $t0, $a0, TROCA_LINHA_LOOP

# Unstacking
ldc1 $f0, 0($sp)
ldc1 $f2, 8($sp)
lw $t0, 16($sp)
lw $t1, 20($sp)
lw $t2, 24($sp)
lw $t3, 28($sp)
lw $t4, 32($sp)
addi $sp, $sp, 36

#TODO
jr $ra # Fim da fucao


# Funcao que troca duas linhas da matriz de lugar (pivoting)
# Recebe $a0 = num de linhas, $a1 = num de colunas, $a2 = linha1, $a3 = linha2
TROCA_LINHA_L:
# Stacking
addi $sp, $sp, -36
sdc1 $f0, 0($sp)
sdc1 $f2, 8($sp)
sw $t0, 16($sp)
sw $t1, 20($sp)
sw $t2, 24($sp)
sw $t3, 28($sp)
sw $t4, 32($sp)
# Body
li $t0, 0

sll $t1, $a1, 3
mult $t1, $a2
mflo $t1 # Primeiro elemento da linha 1

sll $t2, $a1, 3
mult $t2, $a3
mflo $t2 # Primeiro elemento da linha 2

TROCA_LINHA_L_LOOP:
# Se $t0 for = $a2 ou $a3 eh por que estamos mexendo na diagonal principal
# Como n se pode mexer na diagonal principal da matriz_l usamos esses branchs
# Pra evitar isso
beq $t0, $a2, TLL_NEXT_ITERATION
beq $t0, $a3, TLL_NEXT_ITERATION

sll $t4, $t0, 3

add $t3, $t1, $t4
ldc1 $f0, matriz_l($t3) # Pega elemento da linha 1

add $t3, $t2, $t4
ldc1 $f2, matriz_l($t3) # Pega elemento da linha 2

sdc1 $f0, matriz_l($t3)

add $t3, $t1, $t4

sdc1 $f2, matriz_l($t3)

TLL_NEXT_ITERATION: addi $t0, $t0, 1
bne $t0, $a0, TROCA_LINHA_L_LOOP

# Unstacking
ldc1 $f0, 0($sp)
ldc1 $f2, 8($sp)
lw $t0, 16($sp)
lw $t1, 20($sp)
lw $t2, 24($sp)
lw $t3, 28($sp)
lw $t4, 32($sp)
addi $sp, $sp, 36

#TODO
jr $ra # Fim da fucao




# Funcao que realiza a operacao L2 = L2 - (lambda)*L1
# Onde L2 e L1 sao todos os elementos de linhas quaisquer da matriz
# Recebe $a0 = tamanho da matriz (Sempre quadrada), $a1 = L1, $a2 = L2, $f12 = lambda
OPERA_LINHAS:
# Stacking
addi $sp, $sp, -44
sdc1 $f0, 0($sp)
sdc1 $f2, 8($sp)
sdc1 $f4, 16($sp)
sw $t0, 24($sp)
sw $t1, 28($sp)
sw $t2, 32($sp)
sw $t3, 36($sp)
# Body
li $t0, 0

# Calculando coluna da linha1
sll $t1, $a1, 3
mult $t1, $a0
mflo $t1

# Calculando coluna da linha2
sll $t2, $a2, 3
mult $t2, $a0
mflo $t2

OPERA_LINHAS_LOOP:
sll $t3, $t0, 3
add $t3, $t3, $t1
ldc1 $f0, matriz($t3) # Elemento da linha1

sll $t3, $t0, 3
add $t3, $t3, $t2
ldc1 $f2, matriz($t3) # Elemento da linha2

mul.d $f4, $f0, $f12 # $f4 = L1*lambda
sub.d $f4, $f2, $f4 # $f4 = L2 - L1*lambda

sdc1 $f4, matriz($t3) # Guarda na matriz

addi $t0, $t0, 1
bne $t0, $a0, OPERA_LINHAS_LOOP
# Unstacking
ldc1 $f0, 0($sp)
ldc1 $f2, 8($sp)
ldc1 $f4, 16($sp)
lw $t0, 24($sp)
lw $t1, 28($sp)
lw $t2, 32($sp)
lw $t3, 36($sp)
addi $sp, $sp, 44

jr $ra # Fim da funcao





# Realiza a decoposicao LU
# Recebe $a0 = num de linhas, $a1 = num de colunas
# Ainda falta a logica de pivoteamento
MATRIZ_LU:
#Stacking
addi $sp, $sp, -44
sdc1 $f0, 0($sp)
sdc1 $f12, 8($sp)
sw $t0, 16($sp)
sw $t1, 20($sp)
sw $t2, 24($sp)
sw $t3, 28($sp)
sw $t4, 32($sp)
sw $t5, 36($sp)
#Body

li $t0,0 # Contador da diagona principal
li $t1,0 # Contador de elementos na coluna
move $t2, $a0 # Passando numero de linhas (Igual ao num de colunas)

MATRIZ_LU_MAIN_LOOP:
# Calculando coluna
sll $t3, $t0, 3
# Calculando linha
sll $t4, $t0, 3
mult $t4, $t2
mflo $t4

add $t3, $t4, $t3 # Posicao do elemento na diagonal principal
PEGA_ELEMENTO_DIAG: ldc1 $f0, matriz($t3) # Pega o elemento na diagonal principal

# A Logica de pivoteamento vai aqui
# Registrador $f30 vai ser sempre zero pra ter com o que comparar
c.eq.d $f0, $f30 
bc1f END_PIVOTING # Se o elemento da diag. princ. nao for 0, pulamos para NOT_PIVOTING

addi $t5, $t0, 1 # Vamos comecar olhando da linha abaixo
PROCURA_LINHA_P_PIVOT:
beq $t5, $t2, ERRO # se ja tivermos olhado todas as linhas
# E nao der pra pivotear com nenhuma, teve algum erro

sll $t6, $t5, 3
mult $t6, $t2
mflo $t6

add $t6, $t3, $t6

ldc1 $f12, matriz($t6)

c.eq.d $f12, $f30 # Se for zero 
bc1t PLPP_NEXT_ITERATION # Passa pra proxima

# Se n nao for zero faz o pivoteamento
move $a0, $t2
move $a1, $t2
move $a2, $t5
move $a3, $t0

addi $sp, $sp, -4
sw $ra, 0($sp)

jal TROCA_LINHA

jal TROCA_LINHA_L

lw $ra, 0($sp)
addi $sp, $sp, 4
j PEGA_ELEMENTO_DIAG # Volta pra pegar de novo o elemento da diag princ.
# No caso aqui daria pra so trocar o valor de $f0 e ja ir direto
# Mas acho que mandar pegar e comparar de novo eh mais seguro

PLPP_NEXT_ITERATION: addi $t5, $t5, 1
bne $t5, $t2, PROCURA_LINHA_P_PIVOT

END_PIVOTING:
div.d $f12, $f0, $f0 # Melhor jeito que eu achei de carregar 1 no reg
sdc1 $f12, matriz_l($t3) # Coloca 1 na diagonal principal da matriz L

addi $t1, $t0, 1 # Mais 1 pq comecamos do elemento abaixo da diagonal principal
beq $t1, $t2 EXIT_MATRIZ_LU # Acabou
ELIMINA_COLUNA_LOOP: # loop para eliminar coluna
# $t0 = contador da diagonal, $t1 = contador de elementos na coluna

sll $t3, $t0, 3 # calculando coluna
# calculando linha
sll $t4, $t1, 3
mult $t4, $t2
mflo $t4

add $t3, $t4, $t3
ldc1 $f2, matriz($t3)

div.d $f12, $f2, $f0 # Lambda
sdc1 $f12, matriz_l($t3) # escreve lambda na matriz L

addi $sp, $sp, -4
sw $ra, 0($sp)
move $a1, $t0
move $a2, $t1

jal OPERA_LINHAS

lw $ra, 0($sp)
addi $sp, $sp, 4

addi $t1, $t1, 1
bne $t1, $t2, ELIMINA_COLUNA_LOOP

addi $t0, $t0, 1
bne $t0, $t2, MATRIZ_LU_MAIN_LOOP


#Unstacking
ldc1 $f0, 0($sp)
ldc1 $f12, 8($sp)
lw $t0, 16($sp)
lw $t1, 20($sp)
lw $t2, 24($sp)
lw $t3, 28($sp)
lw $t4, 32($sp)
lw $t5, 36($sp)
addi $sp, $sp, 44


EXIT_MATRIZ_LU:
jr $ra # Fim da fucao

ERRO: # Se tiver algum erro

EXIT:




