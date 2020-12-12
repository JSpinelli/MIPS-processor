.data 
num0: .word 1 
num1: .word 63 


.text 
main:
   #inicializa constantes
  lw $t1, 0($zero) # lw $r9, 0($r0)
  lw $t0, 4($zero) # lw $r10, 4($r0)
  and $t2, $zero, $zero # reset de contador
  nop
  bit1:
  sw $t1, 8($zero)	# crea la mascara inicialmente en 0x01
  and $t1, $t1, $t0 	# mascara de datos 
  nop
  nop
  beq $t1,$zero, bit2 
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  bit2:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit3 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  bit3:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit4 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  bit4:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit5
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  bit5:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit6 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
    bit6:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit7 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
    bit7:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  sw $t1, 8($zero)	#almacena la mascara actual
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, bit8 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  bit8:  
  lw $t1, 8($zero)	#carga la mascara
  nop
  nop
  add $t1, $t1, $t1 	#crea la mascara de la iteracion
  nop
  nop
  and $t1, $t0, $t1 	# enmascara datos 
  nop
  nop
  beq $t1,$zero, end 
  lw $t1, 0($zero) 	# carga valor 1
  nop
  nop
  add $t2, $t2, $t1	# incrementa el contador
  end: 
  nop
  nop
  sw $t2, 8($zero)
