;Visit method
;This is the method to be called when passing the tree
(define (visit node)
  (let ((line 0));sets line to 0
    (cond ((equal? (car node) "S");checks if the first item in the tree is an "S"
           (statements (car (cdr node)) line));calls the statments function with the contents of the statments node
          
          (else (display "Not a statements node") (newline))));displays if fisrt entry is not a statements node
  
  (display ""));stops one from being printed beacuse shceme is dumb

;executes if memeber of the tree is a statemnets node
;acceptes the statemnts node and the line number
(define (statements node line)
  ;conditions to check the node type
  (cond ((= 0 (length node));checks if the list is empty
         (+ line 0));if so returns the line number

        ((equal? (car (car node)) "S"); checks if the next node is a statemnets node
         (let ((line1 (statements (car node) line)));sets line1 to the line value returned by statements node
           (let ((line2 (next node line1)));sets line2 to the line value returned by the next function
             (+ line2 0))));returns the line count
        
        ((equal? (car (car node)) "W");checks if the node is a while node
         (let ((line1 (while (car node) line)))
           (let ((line2 (next node line1)))
             (+ line2 0))))

        ;these conditions checks if the node is a two operand node
        ((equal? (car (car node)) "-");checks if the operations is subtraction
         (sub (car node) line);calls the sub function with the subtraction node 
         (let ((line1 (next node line)))
           (+ line1 0)))
        
        
        ((equal? (car (car node)) "+");checks if the operation is addition
         (add (car node) line)
         (let ((line1 (next node line)))
           (+ line1 0)))
        
        ((equal? (car (car node)) "*");checks if the operation is multiplication
         (mul (car node) line)
         (let ((line1 (next node line)))
           (+ line1 0)))
        
        ((equal? (car (car node)) "/");checks if the operation is divison
         (div (car node) line)
         (let ((line1 (next node line)))
           (+ line1 0)))))

;exiectus if the node in the tree is a subtraction operator
;takes in the two operand node and the line number
(define (sub node line)
  ;checks if the operand is an address or a register and calls the respect function for each possibitly
  (cond ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "A"));checks if operands are both address
         (addressSub (cdr node) line));passes the operands to the addressSub methond
        
        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "R"));checks if opreands are registers
         (registerSub (cdr node) line))

        ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "R"));checks if the first operand is an address and the second a regesiter
         (addressRegisterSub (cdr node) line))

        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "A"));chekcs if the forst operand is a regiest er anf if the second is an address
         (registerAddressSub (cdr node) line))))

;exiects if the node has an add operator
(define (add node line)
  (cond ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "A"))
         (addressAdd (cdr node) line))
        
        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "R"))
         (registerAdd (cdr node) line))

        ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "R"))
         (addressRegisterAdd (cdr node) line))

        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "A"))
         (registerAddressAdd (cdr node) line))))

;exicutes if the node had a multiply operator
(define (mul node line)
  (cond ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "A"))
         (addressMul (cdr node) line))
        
        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "R"))
         (registerMul (cdr node) line))

        ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "R"))
         (addressRegisterMul (cdr node) line))

        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "A"))
         (registerAddressMul (cdr node) line))))

;exectues if the node as a division operator
(define (div node line)
  (cond ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "A"))
         (addressDiv (cdr node) line))
        
        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "R"))
         (registerDiv (cdr node) line))

        ((and (equal? (car (car (cdr node))) "A") (equal? (car (car (cdr (cdr node)))) "R"))
         (addressRegisterDiv (cdr node) line))

        ((and (equal? (car (car (cdr node))) "R") (equal? (car (car (cdr (cdr node)))) "A"))
         (registerAddressDiv (cdr node) line))))

;exicutes of the node is a while node
;takes in the while node and the line number
(define (while node line)
  (let ((jmp line));sets jmp to the current line count
    ;sends the conditions of the while node to the statements method
    (let ((line1 (statements (car (cdr node)) line)));sets line1 to the line number returned by the statements method
      (display line1) (display ": bne $00000000") (newline);displays the end of the statements and beging of the conditions in the while node
      (let ((line2 (+ line1 1)));increases the line count by one
        (let ((line3 (statements (car (cdr (cdr node))) line2)));sets line3 to the value returned by the staments method after passing the conditions through
          (display line3) (display ": jmp $") (display jmp) (newline) (+ line3 0))))));displays the jmp point for the end of the while node

;the following methonds print out the requerid formate bassed on the operartor and the operands within the two operand node
;each of them take in the operands and display them in the fomratted way depending on wether they were a address or a regeister
;the methonds are all named acordingly for weather the operands are address, regeisters or a (address,regeister) pair or a (regeister,address) pair and the operator being preformed on the operands
(define (addressSub node line)
  (display line) (display ": sub $") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressAdd node line)
  (display line) (display ": add $") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressMul node line)
  (display line) (display ": mul $") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressDiv node line)
  (display line) (display ": div $") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerSub node line)
  (display line) (display ": sub R") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerAdd node line)
  (display line) (display ": add R") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerMul node line)
  (display line) (display ": mul R") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerDiv node line)
  (display line) (display ": div R") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressRegisterSub node line)
  (display line) (display ": sub $") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressRegisterAdd node line)
  (display line) (display ": add $") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressRegisterMul node line)
  (display line) (display ": mul $") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (addressRegisterDiv node line)
  (display line) (display ": div $") (display (car (cdr (car node)))) (display ", R") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerAddressSub node line)
  (display line) (display ": sub R") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerAddressAdd node line)
  (display line) (display ": add R") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerAddressMul node line)
  (display line) (display ": mul R") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

(define (registerAddressDiv node line)
  (display line) (display ": div R") (display (car (cdr (car node)))) (display ", $") (display (car (cdr (car (cdr node))))) (newline)
  )

;goes to the next node within the tree
;takes in the tree and the line number
(define (next node line)
  (let ((line1 (+ line 1))) ; increments line by one
    ;passes the preamming nodes with in the tree to the statements method
    (let ((line2 (statements (cdr node) line1)));sets line2 to the value being returned by the statements method
      (+ line2 0))));returns the line number