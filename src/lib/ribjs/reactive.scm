#|
Reactive values are values that can be used in the same way as normal values, but that can be updated when the value changes.
They are, internally, a list of the form '($reactive$ value id), where value is the actual value and id is a unique identifier.
|#

(define ($is-reactive? value)
  (and (pair? value) (eq? (car value) '$reactive$))
  )


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


