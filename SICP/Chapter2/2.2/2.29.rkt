#lang planet neil/sicp
#|
(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))
(define (mobile? structure)
  (pair? structure))
;a)
(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (car (cdr mobile)))
(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (car (cdr branch)))
|#
;b)
(define (total-weight mobile)
  (if (mobile? mobile)
      (+ (total-weight (branch-structure (left-branch mobile)))
         (total-weight (branch-structure (right-branch mobile))))
      mobile))
;c)
(define (torque branch)
  (* (branch-length branch)
     (let ((structure (branch-structure branch)))
       (if (mobile? structure)
           (total-weight structure)
           structure))))
(define (balanced? mobile)
  (if (mobile? mobile)
      (let ((structure-left (branch-structure (left-branch mobile)))
            (structure-right (branch-structure (right-branch mobile))))
        (and (= (torque (left-branch mobile)) (torque (right-branch mobile)))
             (balanced? structure-left)
             (balanced? structure-right)))
      #t))
;d)
;只用修改构造部分
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))
(define (mobile? structure)
  (pair? structure))
(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cdr mobile))
(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cdr branch))
(define level-1-mobile (make-mobile (make-branch 2 1) 
                                     (make-branch 1 2))) 
(define level-2-mobile (make-mobile (make-branch 3 level-1-mobile) 
                                     (make-branch 9 1))) 
(define level-3-mobile (make-mobile (make-branch 4 level-2-mobile) 
                                     (make-branch 8 2))) 
(total-weight level-3-mobile)
(balanced? level-3-mobile) 