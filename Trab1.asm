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

addi $t3, $t3, 1 # Vai pra proxima coluna
li $t2, 0 # Volta pro primeiro elemento da linha
bne $t3, $t1, LOOP_LINHA






