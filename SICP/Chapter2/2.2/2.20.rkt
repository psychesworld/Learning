#lang planet neil/sicp
(define (same-parity x . y)
  (cons x (let ((remainder-first (remainder x 2)))
            (define (iter items)
              (cond ((null? items) items)
                    ((= remainder-first (remainder (car items) 2))
                     (cons (car items) (iter (cdr items))))
                    (else (iter (cdr items)))))
            (iter y))))
(list 1 2 3 4 )
(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)