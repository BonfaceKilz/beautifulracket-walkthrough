#lang br/quicklang
(require "parser.rkt")
(require brag/support)

(provide read-syntax)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port)))
  (define module-datum `(module bf-mod bf/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))

(define (make-tokenizer port)
  (define (next-token)
    (define bf-lexer
      (lexer
       [(char-set "><-.,+[]") lexeme]
       [any-char (next-token)]))
    (bf-lexer port))
  next-token)
