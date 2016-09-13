# Autores : Felipe da Costa Malaquias e Lucas Mota Ribeiro
# OAC 2/2016

.data
matrix: .space 36
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

add $t0, $v0, $zero # Guarda o valor no t0

# Pega o numero de colunas
li $v0, 4
la $a0, msg2
syscall

li $v0, 5
syscall

add $t1, $v0, $zero # Guarda o valor no t1

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
li $v0, 5
syscall

# Posicao do proximo elemento na linha em words
sll $s0, $t2, 2 

# Calculando o offset pro numero cair na coluna certa
sll $s1, $t1, 2
mult $s1, $t3
mflo $s1

# Soma da posicao na linha + offset
add $t4, $s0, $s1
sw $v0, matrix($t4)

addi $t2, $t2, 1 # Vai pro proximo elemento da linha
bne $t2, $t0, LOOP_LINHA

li $t2, 0 # Volta pro primeiro elemento da linha
addi $t3, $t3, 1 # Vai pra proxima coluna
bne $t3, $t1, LOOP_LINHA

# Nesse ponto a matriz ja esta pronta, $t0 guarda o numero de linhas e $t1 o numero de colunas
move $a0, $t0
move $a1, $t1
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
sll $t4, $t2, 2

# Calculando coluna
sll $t5, $t3, 2
mult $t5, $t1
mflo $t5

add $t4, $t4, $t5
lw $t4, matrix($t4) # Carrega valor que vai ser impresso em lw

# Imprime valor + espaco
li $v0, 1
move $a0, $t4
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

EXIT:




