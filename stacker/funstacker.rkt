#lang br/quicklang

(provide read-syntax)
(provide (rename-out [funstacker-module-begin #%module-begin]))
(provide handle-args)
(provide + *)

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum))

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))

(define (handle-args . args)
  (for/fold ([stack-acc empty])
            ([arg (in-list args)]
             #:unless (void? arg))
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result
         (arg (first stack-acc) (second stack-acc)))
       (cons op-result (drop stack-acc 2))])))