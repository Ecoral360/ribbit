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

