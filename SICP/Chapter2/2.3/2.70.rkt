#lang planet neil/sicp
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (and (pair? object) (eq? 'leaf (car object))))
(define (symbol-leaf leaf)
  (cadr leaf))
(define (weight-leaf leaf)
  (caddr leaf))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree)
  (car tree))
(define (right-branch tree)
  (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
  (define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit --" bit))))
  (define (iter bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch) (iter (cdr bits) tree))
              (iter (cdr bits) next-branch)))))
  (iter bits tree))
(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))
(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)
                               (cadr pair))
                    (make-leaf-set (cdr pairs))))))
(define (element-of-set? x set)
  (if (null? set)
      #f
      (if (eq? x (car set))
          #t
          (element-of-set? x (cdr set)))))
(define (encode-symbol char tree)
  (define (iter char current-branch)
    (if (leaf? current-branch)
        '()
        (let ((left (left-branch current-branch))
              (right (right-branch current-branch)))
          (if (element-of-set? char left)
              (cons 0 (iter char left))
              (cons 1 (iter char right))))))
  (if (element-of-set? char (symbols tree))
      (iter char tree)
      (error "-- is not in this tree" char)))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (successive-merge leaf-set)
  (define (iter result rest-set)
    (if (null? rest-set)
        result
        (iter (make-code-tree
               (car rest-set) result)
              (cdr rest-set))))
  (iter (car leaf-set) (cdr leaf-set)))
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define tree
 (generate-huffman-tree (list (list 'A 2)
                             (list 'NA 16)
                             (list 'BOOM 1)
                             (list 'SHA 3)
                             (list 'GET 2)
                             (list 'YIP 9)
                             (list 'JOB 2)
                             (list 'WAH 1))))

(length (encode '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom) tree))
