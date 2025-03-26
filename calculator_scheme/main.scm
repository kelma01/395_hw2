#lang racket

(define env (make-hash))  ;; make-hash kullanımı

(define (evaluate expr)
  (cond
    ((number? expr) expr)
    ((symbol? expr) (or (hash-ref env expr #f)
                         (error "Undefined variable" expr)))
    ((not (list? expr)) (error "Invalid expression" expr))
    ((eq? (car expr) 'define) 
     (if (and (symbol? (cadr expr)) (= (length expr) 3))
         (begin (hash-set! env (cadr expr) (evaluate (caddr expr)))
                (cadr expr))
         (error "Invalid assignment syntax")))
    (else 
     (let ((op (car expr))
           (args (map evaluate (cdr expr))))
       (case op
         ((+) (apply + args))
         ((-) (apply - args))
         ((*) (apply * args))
         ((/) (if (not (zero? (cadr expr)))
                   (apply / args)
                   (error "Division by zero")))
         (else (error "Unknown operator" op)))))))

(define (read-eval-print-loop)
  (display "> ")
  (flush-output)
  (let ((input (read)))
    (unless (eof-object? input)
      (with-handlers ((exn:fail? (lambda (e) (displayln (exn-message e))))) 
        (displayln (evaluate input)))
      (read-eval-print-loop))))

(displayln "Type expressions, examples can be seen in below:")
(displayln "Expression example: (+ 1 2)")
(displayln "Assignment example: (define x 3)")
(displayln "Variable example: x")
(displayln "Operators: + - * /")
(displayln "Ctrl+D to exit.")
(read-eval-print-loop)
