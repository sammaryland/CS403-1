(include "extras/exprTest.scm")

(define (item v r)
    (define (dispatch m)
        (cond
            ((eq? m 'val) v)
            ((eq? m 'rank) r)
            (else (error "Unknown operation -- Item" m))
        )
    )
    dispatch
)

(define (PRQ comp)
    (define queue '())
    (define (size)
        (define (iter q count)
            (if (null? q)
                count
                (iter (cdr q) (+ count 1))
            )
        )
        (iter queue 0)
    )
    (define (empty? q) (== queue 0))
    (define (pop)
        (if (== queue nil)
            'EMPTY
            ((car queue) 'val)
        )
    )
    (define (insert i)
        (define new (item (car i) (cadr i)))
        (define (iter q nitem)
            (if (== q nil)
                (cons nitem q)
                (if (comp ((car q)'rank) (nitem'rank))
                    (cons (car q) (iter (cdr q) nitem))
                    (cons nitem q)
                )
            )
        )
        (if (== queue nil)
            (set! queue (list new))
            (set! queue (iter queue new))
        )
    )
    (define (remove)
        (if (== queue nil)
            'EMPTY
            (begin
                (define p (pop))
                (set! queue (cdr queue))
                p
            )
        )
    )
    (define (get-value)
        (if (== queue nil)
            'EMPTY
            ((car queue) 'val)
        )
    )
    (define (get-rank)
        (if (== queue nil)
            'EMPTY
            ((car queue) 'rank)
        )
    )

    (define (dispatch m @)
        (cond
            ((eq? m 'insert) (insert @))
            ((eq? m 'remove) (remove))
            ((eq? m 'item) (get-value))
            ((eq? m 'rank) (get-rank))
            ((eq? m 'size) (size))
            ((eq? m 'q) queue)
            ((eq? m 'empty?) (== queue nil))
            (else (error "Unknown operation -- PriorityQueue" m))
        )
    )
    dispatch
)

(define (run3)
    (inspect (define p (PRQ <)))
    (inspect (p 'insert 111 1))
    (exprTest (p 'size) 1)
    (inspect (p 'insert 333 3))
    (exprTest (p 'size) 2)
    (inspect (p 'insert 222 2))
    (exprTest (p 'size) 3)
    (exprTest (p 'empty?) #f)
    (exprTest (p 'item) 111)
    (exprTest (p 'rank) 1)
    (exprTest (p 'remove) 111)
    (exprTest (p 'item) 222)
    (exprTest (p 'rank) 2)
    (exprTest (p 'remove) 222)
    (exprTest (p 'empty?) #f)
    (exprTest (p 'remove) 333)
    (exprTest (p 'empty?) #t)


    (inspect (define q (PRQ >)))
    (inspect (q 'insert 111 1))
    (exprTest (q 'size) 1)
    (inspect (q 'insert 333 3))
    (exprTest (q 'size) 2)
    (inspect (q 'insert 222 2))
    (exprTest (q 'size) 3)
    (exprTest (q 'empty?) #f)
    (exprTest (q 'item) 333)
    (exprTest (q 'rank) 3)
    (exprTest (q 'remove) 333)
    (exprTest (q 'item) 222)
    (exprTest (q 'rank) 2)
    (exprTest (q 'remove) 222)
    (exprTest (q 'empty?) #f)
    (exprTest (q 'remove) 111)
    (exprTest (q 'empty?) #t)
)