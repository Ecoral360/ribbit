(define $REACTIVE_MODULE$ #t)
#|
Reactive values are values that can be used in the same way as normal values, but that can be updated when the value changes.
They are, internally, a pair of the form '($reactive$ value id), where value is the actual value and id is a unique identifier.
|#


(define ($reactive? value)
    (procedure? value)
  )

(define (reactive value)
  (let ((callbacks '()))
    (lambda args
      (if (null? args)
        value

        (let ((new-value (car args)))

          ; call a special method on the reactive value
          (if (symbol? new-value)
            (let ((method new-value)
                  (args (cdr args)))
              (cond
                ((equal? method '$add-listener)
                 (set! callbacks (append callbacks (list1 (car args)))))

                (else (error "Unknown method " method))
                )
              '()
              )
            
            ; set the value if it has changed
            (if (not (equal? value new-value))
              (begin
                (set! value new-value)
                (for-each (lambda (callback) (callback new-value)) callbacks)
                )
              '()
              ))
          ))
      )))

(define ($rbind-eval tokens dependencies)
    (eval (map 
      (lambda (token)
        (if (and (symbol? token) (starts-with (symbol->string token) "$"))
            (let* ((token-str (symbol->string token))
                   (idx (string->number (substring token-str 1 (string-length token-str)))))
              ((list-ref dependencies idx)))
            token)
        )
      tokens))
    )

(define (rbind f dependencies)
  (let* ((callbacks '()) 
         (value (f))
         (factory (lambda (new-value)
                    (set! value (f))
                    (for-each (lambda (callback) (callback value))
                              callbacks))))
    ; when a dependency changes
    (for-each (lambda (dependency) 
                (dependency '$add-listener factory))
              dependencies)

    (lambda args
      (if (null? args)
        value

        (let ((new-value (car args)))

          ; call a special method on the reactive value
          (if (symbol? new-value)
            (let ((method new-value)
                  (args (cdr args)))
              (cond
                ((equal? method '$add-listener)
                 (set! callbacks (append callbacks (list1 (car args)))))

                (else (error "Unknown method " method))
                )
              '()
              )
            
            ; set the value if it has changed
            (error "Binded values can only be changed by changing the value of 
                   one of their dependency.")
                ))
          ))
      ))

(define (rmap f reactive-value)
  (let ((reactive-mapper (reactive (map f (reactive-value)))))
    (reactive-value
      '$add-listener 
      (lambda (new-value)
        (reactive-mapper (map f new-value))
        ))
    reactive-mapper
    )
  )

(define (zip list1 list2)
  (let ((el1 (if (null? list1) '() (car list1)))
        (el2 (if (null? list2) '() (car list2)))
        (rest1 (if (null? list1) '() (cdr list1)))
        (rest2 (if (null? list2) '() (cdr list2))))
    (if (and (null? el1) (null? el2))
      '()
      (cons (list el1 el2) (zip rest1 rest2)))
    ))

;; Zips and stops when list1 is done
(define (zip-l1 list1 list2)
  (let ((el1 (car list1))
        (el2 (if (null? list2) '() (car list2)))
        (rest2 (if (null? list2) '() (cdr list2))))
    (if (null? el1)
      '()
      (cons (list el1 el2) (zip-l1 (cdr list1) rest2)))
    ))

(define (rmap-change f reactive-list)
  (let ((old-list (reactive-list))
        (reactive-mapper
          (rbind (lambda ()
                   (let ((new-list
                           (map (lambda (pair)
                                  (if (not (equal? (car pair) (cadr pair)))
                                    (f (car pair)) ; if old != new
                                    (car pair))
                                  ) 
                                (zip-l1 (reactive-list) old-list))))
                     (set! old-list (reactive-list))
                     new-list
                     ))
                 (list reactive-list))))
    reactive-mapper
  ))


(define (rlist-tail reactive-list i)
  (let ((reactive-tail 
          (rbind (lambda ()
                   (if (>= i (list-length (reactive-list)))
                     ; if i is greater than the length of the list, return the whole list
                     (reactive-list)                    
                     (list-tail (reactive-list) i))
                   )
                 (list reactive-list))))
    reactive-tail
    ))

(define (rlist-ref reactive-list i)
  (let ((reactive-ref 
          (rbind (lambda ()
                   (if (>= i (list-length (reactive-list)))
                     ; if i is greater than the length of the list, return '()
                     '()
                     (list-ref (reactive-list) i))
                   )
                 (list reactive-list))))
    reactive-ref
    ))


