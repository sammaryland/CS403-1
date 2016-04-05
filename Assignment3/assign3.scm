; Password for Submit: 16andcounting

(define (author)
    (println "AUTHOR: Kyle Galloway ckgalloway@crimson.ua.edu")
)

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
(include "task1.scm")

; Task 2
(include "task2.scm")

; Task 3
(include "task3.scm")

; Task 4
(include "task4.scm")

; Task 5
(include "task5.scm")

; Task 6
(include "task6.scm")

; Task 7
(include "task7.scm")

; Task 8
(include "task8.scm")

; Task 9
(include "task9.scm")

; Run tests
(print "PROBLEM 1:\n\n")
(if (defined? 'run1 this)
    (run1)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 2:\n\n")
(if (defined? 'run2 this)
    (run2)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 3:\n\n")
(if (defined? 'run3 this)
    (run3)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 4:\n\n")
(if (defined? 'run4 this)
    (run4)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 5:\n\n")
(if (defined? 'run5 this)
    (run5)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 6:\n\n")
(if (defined? 'run6 this)
    (run6)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 7:\n\n")
(if (defined? 'run7 this)
    (run7)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 8:\n\n")
(if (defined? 'run8 this)
    (run8)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(print "PROBLEM 9:\n\n")
(if (defined? 'run9 this)
    (run9)
    (println "\tNOT IMPLEMENTED")
)
(println "\n")
(display "\n\nassignment 3 loaded!\n\n")