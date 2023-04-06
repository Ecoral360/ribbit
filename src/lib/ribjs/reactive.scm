(define $REACTIVE_MODULE$ #t)
#|
Reactive values are values that can be used in the same way as normal values, but that can be updated when the value changes.
They are, internally, a pair of the form '($reactive$ value id), where value is the actual value and id is a unique identifier.
|#

(define $listeners$ '())
(define $rid$ 0)

(define ($reactive? value)
    (procedure? value)
  )

;; callback is a function that takes the new value as an argument, it will only be called if the value has changed
(define ($reactive-add-listener rid callback)
  (if (> (length $listeners$) rid)
    (let ((listeners (list-ref $listeners$ rid)))
      (set-car! listeners (cons callback (car listeners))))
    (set! $listeners$ (cons (cons callback '()) $listeners$))
    )
  )

(define ($reactive-update rid new-value)
  (let ((listeners (list-ref $listeners$ rid)))
    (if (pair? listeners)
      (for-each (lambda (callback) (callback new-value)) listeners)
      '()
    )
  ))

(define (reactive value)
  (let ((rid $rid$))
    (set! $rid$ (+ $rid$ 1))
    (lambda args
      (if (null? args)
        value
        (let ((new-value (car args)))
          (if (eq? new-value '$rid)
            rid
            (if (not (equal? value new-value))
              (begin
                (set! value new-value)
                ($reactive-update rid new-value)
                )
              '()
              ))
          ))
      )))

(define (r-new value)
  (let ((el (create-element "span")))
    (set-text el (->string value))
    (set-attr el "r-id" (set! $rid$ (+ $rid$ 1)))
    (set-attr el "r-type" ($typeof value))
    el
    )
  )

(define (r-getter el)
  (lambda () ($from-html-node el))
  )

(define (r-setter el)
  (lambda (new-value)
    (set-text el (->string new-value))
    (set-attr el "r-type" ($typeof new-value))
    '())
  )


