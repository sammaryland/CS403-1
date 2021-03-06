; Password for Submit: 16andcounting

(define (author)
    (println "AUTHOR: Kyle Galloway ckgalloway@crimson.ua.edu")
)

; (define (exprTest # $expr target)
;     (define result (catch (eval $expr #)))
;     (if (error? result)
;         (println $expr " is EXCEPTION: " (result'value)
;             " (it should be " target ")")
;         (println $expr " is " result
;             " (it should be " target ")")
;     )
; )

(define (exprTest # $expr target)
    (define result (catch (eval $expr #)))
    (println)
    (cond
        ((error? result)
            (println $expr " is EXCEPTION:")
            (println (result'value))
            (println "It should be:")
            (println target))
        (else
            (println $expr " is: ")
            (println result ", it should be: ")
            (println target)
        )
    )
)

; Task 1
(define (loop f L)
    ; If list is empty
    (if (null? L)
        ; Return null
        nil
        ; If the first part is less than the second part of the list
        (if (< (car L) (cadr L))
            (begin
                ; Call the function on the first part
                (f (car L))
                ; And recursively call loop on the rest of the sequence
                (loop f (list (+ (car L) 1) (cadr L)))
            )
        )
    )
)

; Task 2
(define (curry @)
    ; Checks if the arg is the function itself or if it is nested further down
    (if (is? (car @) 'CONS)
        ; If it is nested call the nested part L
        (define L (car @))
        ; Otherwise call the whole thing L
        (define L @)
    )
    ; Define need as the amount of parameters needed for the function in L
    (define (need) (length (get 'parameters (car L))))
    ; If length of cdr L (# of args) is less than needed
    (if (< (length (cdr L)) (need))
        ; Make a lambda that recalls the function with a more flattened list
        (lambda (@) (curry (append L @)))
        ; Else, apply the function to the rest of the list.
        (apply (car L) (cdr L))
    )
)

; Task 3
; Returns the top element of the stack
(define (peek S)
    (if (null? S)
        '()
        (car S)
    )
)
; Returns the stack without the top element
(define (pop S)
    (if (null? S)
        '()
        (cdr S)
    )
)
; Adds an element to the front of a S
(define (push S el)
    (if (null? S)
        (list el)
        (append (list el) S)
    )
)
; Returns true if op1 has higher precedence than op2
(define (checkPrec op1 op2)
    (define prList '(^ / * - +))
    (define (iter prList)
        (cond
            ((== (car prList) op1) #t)
            ((== (car prList) op2) #f)
            (else (iter (cdr prList)))
        )
    )
    (iter prList)
)
; Adds all of the given list to a stack (basically reverses it)
(define (pushAll L)
    (define (iter LL S)
        (if (null? LL)
            S
            (iter (cdr LL) (push S (car LL)))
        )
    )
    (iter L '())
)
; Makes an expression from the element and the top 2 items of the stack
(define (makeExpr S el)
    (append (list (list el (car S) (cadr S))) (cddr S))
)
; Empties the ops stack onto the output stack and returns the output
(define (emptyStack output ops)
    ; (println output " : " ops)
    (if (null? ops)
        output
        (if (>= (length ops) 2)
            (emptyStack (makeExpr output (car ops)) (cdr ops))
            (emptyStack (makeExpr output (car ops)) nil)
        )
    )
)

(define (infix->prefix Expr)
    (define (iter in out ops)
        ; (println in " : " out " : " ops)
        (if (null? in)
            (car (emptyStack out ops))
            (cond
                ((integer? (car in))
                    (iter (cdr in) (push out (car in)) ops)
                )
                ((symbol? (car in))
                    (if (null? ops)
                        (iter (cdr in) out (push ops (car in)))
                        (if (checkPrec (car in) (car ops))
                            (iter (cdr in) out (push ops (car in)))
                            (iter in (makeExpr out (car ops)) (cdr ops))
                        )
                    )
                )
            )
        )
    )
    (iter (pushAll Expr) nil nil)
)

; Task 4

; (list def ((lambda params body) args))

(define (no-locals orig)
    (define (iter curr params args)
        (define spot (car curr))
        (if (list? spot)
            (if (== (car spot) 'define)
                (if (== (length params) 0)
                    (if (== (length args) 0)
                        (iter (cdr curr) (list (cadr spot)) (list (caddr spot)))
                        (iter (cdr curr) (list (cadr spot)) (append args (list (caddr spot))))
                    )
                    (if (== (length args) 0)
                        (iter (cdr curr) (append params (list (cadr spot))) (list (caddr spot)))
                        (iter (cdr curr) (append params (list (cadr spot))) (append args (list (caddr spot))))
                    )
                )
                (append (list (list 'lambda params spot)) args)
            )
            (append (list (list 'lambda params spot)) args)
        )
    )
    (list (car orig) (cadr orig) (iter (cddr orig) '() '()))
)
; Task 5

(define (fix L)
    (define (fix ly)
        (if (not (null? ly))
            (if (integer? (car ly))
                ly
                (list (append (car ly) (fix (cdr ly))))
            )
            nil
        )
    )
    (fix L)
)

(define (convert Expr)
    (define (iter exp curr)
        (if (not (null? (cdr exp)))
            (iter (cdr exp) (append curr (list (list 'lambda (list (car exp))))))
            (append curr (list (list 'lambda (list (car exp)))))
        )
    )
    (car (fix (append (iter (cadr Expr) '()) (list (caddr Expr)))))
)

; Task 6
;{(define (replace-paren L)
    (define (replace-iter L newL)
        ; If L is a list
        (if (and (list? L) (not (null? L)))
            ; If (car L) is not a list
            (if (not (list? (car L)))
                ; Recur with L=>(cdr L) & newL=>(newL (car L))
                (replace-iter (cdr L)
                              (append newL (list (car L)))
                )
                ; Else, recur with L=>(cdr L) &
                ;     newL=>(newL (replace (car L)))
                (replace-iter (cdr L) (append newL (replace-paren (car L))))
            )
            ; Else, return (newL 'r)
            (append newL (list 'r))
        )
    )
    ; Call replace-iter with L and ('l)
    (replace-iter L (list 'l))
)

(define (rewrite L)
    (define (rewrite-iter L newL)
        (if (and (list? L) (not (null? L)))
            (cond
                ; If (car L) is 'l make newL a list
                ; Cool function that inserts deep needs to go here
                ((== (car L) 'l) (rewrite-iter (cdr L) (list newL)))
                ; If (car L) is an integer (append newL (list (car L)))
                ((integer? (car L))
                    (rewrite-iter (cdr L) (append (list (car L)) newL))
                )
                ; Else, make newL a list
                (#t (rewrite-iter (cdr L) (cons '() newL)))
            )
            newL
        )
    )
    (car (rewrite-iter L '()))
)

(define (reverse* L)
    ; (replace-paren L)
    ; (rewrite (replace-paren L))
) ;}

; I tried to do the iterative version.... it didn't go well
(define (reverse* L)
    (define (recur LL newL)
        (if (null? LL)
            newL
            (if (list? (car LL))
                (recur (cdr LL) (cons (reverse* (car LL)) newL))
                (recur (cdr LL) (cons (car LL) newL))
            )
        )
    )
    (recur L '())
)

; Task 7
; Same as in book
(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence))
        )
    )
)
; Same as in book
(define (accumulate-n op init seqs)
    (if (null? (car seqs))
        nil
        (cons (accumulate op init (map car seqs))
              (accumulate-n op init (map cdr seqs))
        )
    )
)
; Same as in book
(define (transpose mat)
    (accumulate-n cons nil mat)
)
; Same as in book
(define (dot-product v w)
    (accumulate + 0 (map * v w))
)
; Same as in book but transpose the matrix at the beginning
(define (matrix-*-vector m v)
    (map (lambda (row) (dot-product row v)) (transpose m))
)
; Same as in book but don't transpose the matrix at the beginning
(define (matrix-*-matrix m n)
    (map (lambda (row) (matrix-*-vector n row)) m)
)


; Task 8
(define (node value left right)
    (define (display) (print value))
    this
)

(define (displayTree root indent)
    (if (valid? root)
        (begin
            (displayTree (root'right) (string+ indent "    "))
            (print indent)
            ((root'display))
            (println)
            (displayTree (root'left) (string+ indent "    "))
        )
    )
)

(define (insertInTree Tree item)
    (cond
        ; If Tree is empty make a root
        ((null? Tree) (node item '() '()))
        ; Else if the value is the same return the tree
        ((= item (Tree'value)) Tree)
        ; If less than, make a new Tree and recur left
        ((< item (Tree'value))
            (node (Tree'value)
                    (insertInTree (Tree'left) item)
                    (Tree'right)
            )
        )
        ; If less than, make a new Tree and recur right
        ((> item (Tree'value))
            (node (Tree'value)
                        (Tree'left)
                        (insertInTree (Tree'right) item)
            )
        )
    )
)

; Task 9
(define (clean x)
    (define (allZero? n)
        ; If (length n) == 1
        (if (== 1 (length n))
            (if (!= 0 (car n))
                #f ; (car n != 0)
                #t ; (car n == 0)
            )
            ;else
            (if (!= 0 (car n))
                #f ; (car n != 0)
                (allZero? (cdr n)) ; (car n == 0)
            )
        )
    )
    (if (== (car x) '-)
        ; Fixes '(- 0 0 0)
        (if (allZero? (cdr x))
            '(0)
            x
        )
        ; Fixes '(0 0 0)
        (if (allZero? x)
            '(0)
            x
        )
    )
)

(define (big+ a b)
    (define (iter a b total addin)
        (if (> (length a) 0)
            (if (> (length b) 0)
                (begin
                    (define s (+ (car a) (car b) addin))
                    (if (> s 9)
                        (if (> (length total) 0)
                            (iter (cdr a) (cdr b) (append total (list (- s 10))) 1)
                            (iter (cdr a) (cdr b) (list (- s 10)) 1)
                        )
                        (if (> (length total) 0)
                            (iter (cdr a) (cdr b) (append total (list s)) 0)
                            (iter (cdr a) (cdr b) (list s) 0)
                        )
                    )
                )
                (if (> (length total) 0)
                    (if (== addin 0)
                        (append total a)
                        (if (> (length a) 1)
                            (append total (+ 1 (car a)) (cdr a))
                            (append total (+ 1 (car a)))
                        )
                    )
                    (if (== addin 0)
                        a
                        (if (> (length a) 1)
                            (append (+ 1 (car a)) (cdr a))
                            (+ 1 (car a))
                        )
                    )
                )
            )
            (if (> (length total) 0)
                (if (== addin 0)
                    (append total b)
                    (if (> (length b) 1)
                        (append total (+ 1 (car b)) (cdr b))
                        (append total (+ 1 (car b)))
                    )
                )
                (if (== addin 0)
                    b
                    (if (> (length b) 1)
                        (append (+ 1 (car b)) (cdr b))
                        (+ 1 (car b))
                    )
                )
            )
        )
    )
    (if (== (car a) '-)
        (if (== (car b) '-)
            (clean (reverse (append (iter (reverse (cdr a)) (reverse (cdr b)) nil 0) '(-))))
            (clean (big- b (cdr a)))
        )
        (if (== (car b) '-)
            (clean (big- a (cdr b)))
            (clean (reverse (iter (reverse a) (reverse b) nil 0)))
        )
    )
)
(define (invert n)
    (big- '(0) n)
)
(define (big- a b)
    (define (iter a b diff borrow)
        (if (> (length a) 0)
            (if (> (length b) 0)
                (begin
                    (define d (- (car a) borrow (car b)))
                    (if (>= d 0)
                        (if (> (length diff) 0)
                            (iter (cdr a) (cdr b) (append diff (list d)) 0)
                            (iter (cdr a) (cdr b) (list d) 0)
                        )
                        (if (> (length diff) 0)
                            (iter (cdr a) (cdr b) (append diff (list (+ 10 d))) 1)
                            (iter (cdr a) (cdr b) (list (+ 10 d)) 1)
                        )
                    )
                )
                (if (> (length diff) 0)
                    (if (== borrow 1)
                        (append (append diff a) '(-))
                        (append diff a)
                    )
                    (if (== borrow 1)
                        (append a '(-))
                        a
                    )
                )
            )
            (if (> (length b) 0)
                (if (> (length diff) 0)
                    (if (== borrow 1)
                        (append (invert (append diff b)) '(-))
                        (append (append diff b) '(-))
                    )
                    (if (== borrow 1)
                        (append (invert b) '(-))
                        (append b '(-))
                    )
                )
                diff
            )
        )
    )
    (if (== (car a) '-)
        (if (== (car b) '-)
            (clean (reverse (iter (reverse b) (reverse (cdr a)) '() 0)))
            (clean (append '(-) (big+ (cdr a) b)))
        )
        (if (== (car b) '-)
            (clean (big+ a (cdr b)))
            (clean (reverse (iter (reverse a) (reverse b) '() 0)))
        )
    )
)

(define (big* a b)
    (println "Big* not implemented.")
)

; Task 10


; Tests
(define (run1)
    (loop (lambda (x) (inspect x)) '(0 5))
    (loop (lambda (x) (println (* x x))) '(1 11))
    (loop (lambda (x) (println (+ x x x))) '(1 11))
    (loop (lambda (x) (println (sqrt x))) '(1 10))
)

(define (plus a b c d e)
      (+ a b c d e)
)
(define (run2)
    (inspect (curry plus 1 2 3 4 5))
    (inspect ((curry plus 1) 2 3 4 5))
    (inspect ((curry plus 1 2) 3 4 5))
    (inspect ((curry plus 1 2 3) 4 5))
    (inspect ((curry plus 1 2 3 4) 5))
    (inspect (((curry plus 1) 2) 3 4 5))
    (inspect (((curry plus 1) 2 3) 4 5))
    (inspect (((curry plus 1) 2 3 4) 5))
    (inspect (((((curry plus 1) 2) 3) 4) 5))
)

(define (run3)
    (inspect (eval (infix->prefix '(1 * 2 + 3)) this))
    (inspect (eval (infix->prefix '(1 + 2 * 3)) this))
    (inspect (eval (infix->prefix '(1 - 2 * 3)) this))
    (inspect (eval (infix->prefix '(1 - 2 * 3 + 4)) this))
    (inspect (eval (infix->prefix '(1 + 2 * 3 + 4)) this))
    (inspect (eval (infix->prefix '(1 + 1)) this))
)

(define (run4)
    (exprTest (no-locals
        '(define (nsq a) (define x (+ a 1)) (define y (- a 1)) (* x y)))
        '(define (nsq a) ((lambda (x y) (* x y)) (+ a 1) (- a 1)))
    )
    (exprTest (no-locals
        '(define (nsq a) (define x (+ a 1)) (define y (- a 1)) (define z a) (* x y z)))
        '(define (nsq a) ((lambda (x y z) (* x y z)) (+ a 1) (- a 1) a))
    )
    (exprTest (no-locals
        '(define (nsq a) (define (iter x) (+ a 1)) (define y (- a 1)) (* x y)))
        '(define (nsq a) ((lambda ((iter x) y) (* x y)) (+ a 1) (- a 1)))
    )
    (exprTest (no-locals '(define (f) (define x 3) 1))
        '(define (f) ((lambda (x) 1) 3))
    )
)

(define (run5)
    (println (convert (quote (lambda (a b) (+ a b)))))
    (println (convert (quote (lambda (a b c) (+ a b c)))))
    (println (convert (quote (lambda (a b c d) (+ a b c d)))))
)

(define (run6)
    (exprTest (reverse* (list 1 (list 2 (list 3  (list 4 5)))))
        '((((5 4) 3) 2) 1))
    (exprTest (reverse* (list 1 2 3 (list 4 5))) '((5 4) 3 2 1))
    (exprTest (reverse* (list 1 (list 2 3) (list 4 5))) '((5 4) (3 2) 1))
    (exprTest (reverse* '(1 2 3 4 5)) '(5 4 3 2 1))
    (exprTest (reverse* (list 1 (list 2 (list 3)) (list 4 5))) '((5 4) ((3) 2) 1))
)

(define (run7)
    (define v1 '(1 2 3))
    (define w1 '(4 5 6))
    (define m1 '((1 4) (2 5) (3 6)))
    (define m2 '((1 2 3) (2 3 4) (3 4 5) (4 5 6)))
    (define m3 '((10 10) (10 10) (10 10)))
    (define m4 '((1 4 6) (2 5 7) (3 6 8) (4 7 9)))
    (define m5 '((4 6 9 1) (3 6 8 4) (2 5 7 6)))
    (define m6 '((1 2 3)(10 20 30)(100 200 300)))
    (define I3 '((1 0 0) (0 1 0) (0 0 1)))
    (exprTest (dot-product v1 w1) 32)
    (exprTest (matrix-*-vector m1 v1) '(14 32))
    (exprTest (matrix-*-matrix m2 m3) '((60 60) (90 90) (120 120) (150 150)))
    (exprTest (matrix-*-matrix m4 m5) '((28 60 83 53) (37 77 107 64) (46 94 131 75) (55 111 155 86)))
    (exprTest (matrix-*-matrix m5 m4) '((47 107 147) (55 118 160) (57 117 157)))
    (exprTest (matrix-*-matrix m6 I3) '((1 2 3)(10 20 30)(100 200 300)))
    (exprTest (dot-product '(0) '(0)) 0)
    (exprTest (transpose '((0))) '((0)))
    (exprTest (matrix-*-vector '((0)) '(0)) '(0))
    (exprTest (matrix-*-matrix '((0)) '((0))) '((0)))
)

(define (run8)
    (define t0 (node 5 nil nil))
    (define t1 (insertInTree t0 2))
    (define t2 (insertInTree t1 8))
    (define t3 (insertInTree t2 7))
    (define t4 (insertInTree t3 10))
    (define t5 (insertInTree t4 1))
    (define t6 (insertInTree t5 3))
    (displayTree t6 "   ")
)

(define (run9)
    (exprTest (big+ '(4 5 8 9) '(3 0 2)) '(4 8 9 1))
    (exprTest (big+ '(3 0 2) '(4 5 8 9)) '(4 8 9 1))
    (exprTest (big+ '(1 1 1 1) '(1 1 1 1)) '(2 2 2 2))
    (exprTest (big+ '(- 1 1 1 1) '(1 1 1 1)) '(0))
    (exprTest (big+ '(1 1 1 1) '(- 1 1 1 1)) '(0))
    (exprTest (big+ '(- 1 1 1 1) '(- 1 1 1 1)) '(- 2 2 2 2))
    (exprTest (big- '(1 1 1 1) '(1 1 1 1)) '(0))
    (exprTest (big- '(- 1 1 1 1) '(1 1 1 1)) '(- 2 2 2 2))
    (exprTest (big- '(1 1 1 1) '(- 1 1 1 1)) '(2 2 2 2))
    (exprTest (big- '(- 1 1 1 1) '(- 1 1 1 1)) '(0))
    (exprTest (big- '(1 1 1 1) '(1 1 1)) '(1 0 0 0))
    (exprTest (big- '(1 0 0) '(1 1 0 0)) '(- 1 0 0 0))
)

; (define (run10))

; Run tests
; DONE (run1)
; DONE (run2)
; DONE (run3)
; DONE (run4)
; DONE (run5)
; DONE (recursive...) (run6)
; DONE (run7)
; DONE (run8)
; 2/3 DONE (run9)
; (run10)
(println "assignment 2 loaded!")
