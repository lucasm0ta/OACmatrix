# Autores : Felipe da Costa Malaquias e Lucas Mota Ribeiro
# OAC 2/2016

.data
matrix: .space 72
matrix_u: .space 36
matrix_l: .space 36
msg1: .asciiz "Qual o numero de linhas? <ENTER>\n"
msg2: .asciiz "Qual o numero de colunas? <ENTER>\n"
elemento: .asciiz "Elemento "
barra: .asciiz "-"
dois_pontos: .asciiz ": "
quebra_linha: .asciiz "\n"
space: .asciiz "  "


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
sdc1 $f0, matrix($t4)

addi $t2, $t2, 1 # Vai pro proximo elemento da linha
bne $t2, $s0, LOOP_LINHA

li $t2, 0 # Volta pro primeiro elemento da linha
addi $t3, $t3, 1 # Vai pra proxima coluna
bne $t3, $s1, LOOP_LINHA

# Nesse ponto a matriz ja esta pronta, $t0 guarda o numero de linhas e $t1 o numero de colunas
move $a0, $s0
move $a1, $s1
jal IMPRIME_MATRIZ
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
ldc1 $f12, matrix($t4) # Carrega valor que vai ser impresso em lw

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


# Funcao que troca duas linhas da matriz de lugar (pivoting)
# Recebe $a0 = num de linhas, $a1 = num de colunas, $a2 = linha1, $a3 = linha2
TROCA_LINHA:
#TODO


jr $ra # Fim da fucao


# Realiza a decoposicao LU
# Recebe $a0 = num de linhas, $a1 = num de colunas
MATRIZ_LU:
#Stacking


#Body
li $t0,0 # Contador da diagona principal
li $t1,0 # Contador de elementos da linha
li $t2,0 # Contador de coluna

MATRIZ_LU_MAIN_LOOP:
lwc1 $f12, matrix($t0) # Pega o primeiro elemento da diagonal principal
li $v0, 3
syscall
#beq $t1, $a1, MATRIZ_LU_MAIN_LOOP # Se nao tiver percorrido a diagonal principal inteira, volta

#Unstacking
jr $ra # Fim da fucao

EXIT:




