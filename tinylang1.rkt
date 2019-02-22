#lang racket

(require (for-syntax racket/syntax))
(require (for-syntax racket/stxparam))
(require (for-syntax racket/set))
(require (for-syntax racket/base syntax/parse))

(provide 
 (except-out
  (all-from-out racket)
  #%module-begin)
 ; Rename out our core forms
 (rename-out
  [my-module-begin #%module-begin]))

(define-syntax (my-module-begin stx)
  (syntax-parse stx
      [(#%module-begin body ...)
       (define l (syntax->list #`(body ...)))
       (with-syntax
         ([transformed
           (datum->syntax #f (append
                              (list #`#%plain-module-begin)
                              (list #`(define (id x) x))
                              (map (lambda (var) #`(print (id #,var))) l)))])
         #`transformed)]))
