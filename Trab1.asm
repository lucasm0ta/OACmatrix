.data
matrix: .space 36
msg1: .asciiz "Qual o numero de linhas? <ENTER>\n"
msg2: .asciiz "Qual o numero de colunas? <ENTER>\n"
msg3: .asciiz "Introduza as componentes separadas por <TAB> e por linha <ENTER>:\n"
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

# Pega os valores da matriz usando espaco para novo valor
# na msm linha e enter para nova linha
# Valor1 <SPACE> Valor2 <SPACE> Valor3 <ENTER>

li $t2, 0 # Loop counter para linha
li $t3, 0 # Loop counter para coluna



LOOP_LINHA:
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

li $v0, 5
syscall

sll $s2, $t2, 2
mul
add $s0, $s2, $zero
sw $v0, matrix($s0)
addi $t2, $t2, 1
bne $t2, $t0, LOOP_LINHA

li $t2, 0
addi $t3, $t3, 1
bne $t3, $t1, LOOP_LINHA










