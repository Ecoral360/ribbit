;; Built on top of dompling, Ribjs is a fully reactive scheme framework to build 
;; web applications. It is inspired by React and Vue.js.
;;
;; To start, you need to get the app element using the function

(define (set-attrs el attrs)
  (if (pair? attrs)
    (if (pair? (car attrs))     ; syntax: (attribute "value")
      (let* ((attr (caar attrs))
              (value (cdr (car attrs)))
              (rest (cdr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))
        (if (string=? (substring attr-name 0 3) "on:")
          (add-event el (substring attr-name 3 (string-length attr-name)) (eval value))
          (set-attr el attr-name (eval value))
          )
        (set-attrs el rest))
      (let* ((attr (car attrs)) ; syntax: attribute "value"
              (value (cadr attrs))
              (rest (cddr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))
        (if (string=? (substring attr-name 0 3) "on:")
          (add-event el (substring attr-name 3 (string-length attr-name)) (eval value))
          (set-attr el attr-name value)
          )
        (set-attrs el rest))
      )))

(define (add-children el children)
  (cond
    ((or (integer? children) (string? children))
      (append-node el (to-html-node children))
      )
    ((pair? children)
      (for-each
        (lambda (child) (add-children el child)) ; (console.log child))
        children)
      )
    ((html-element? children)
      (append-node el children)
      )
    ))

(define (component name args)
  (let ((el (create-element name)))
    (if (pair? args)
      (let* ((attrs&children (split-attrs&children args))
              (attrs (car attrs&children))
              (children (cdr attrs&children)))
        (set-attrs el attrs)
        (add-children el children)
        )
      )
    el
    ))

(define (<div> . args) (component "div" args))
(define (<span> . args) (component "span" args))
(define (<p> . args) (component "p" args))
(define (<a> . args) (component "a" args))
(define (<img> . args) (component "img" args))
(define (<input> . args) (component "input" args))
(define (<button> . args) (component "button" args))
(define (<h1> . args) (component "h1" args))
(define (<h2> . args) (component "h2" args))
(define (<h3> . args) (component "h3" args))
(define (<h4> . args) (component "h4" args))
(define (<h5> . args) (component "h5" args))
(define (<h6> . args) (component "h6" args))
(define (<nav> . args) (component "nav" args))
(define (<form> . args) (component "form" args))
(define (<label> . args) (component "label" args))
(define (<ol> . args) (component "ol" args))
(define (<ul> . args) (component "ul" args))
(define (<li> . args) (component "li" args))
(define (<style> . args) (component "style" args))

(define <br> (lambda () (create-element "br")))

(define (split-attrs&children attrs)
  (define collected-attrs '())
  (let loop ((next attrs))
    (if (and (pair? next) (and (symbol? (car next)) (string=? (substring (symbol->string (car next)) 0 1) "@")))
      (let* ((attr (car next)) ; syntax: @attribute "value"
              (value (cadr next))
              (rest (cddr next))
              (attr-name (symbol->string attr)))
        (set! collected-attrs
          (append collected-attrs
            (cons
              (substring attr-name 1 (string-length attr-name))
              (cons value '()))
            ))
        ; (console.log collected-attrs)
        (loop rest)
        )
      ; add children
      (cons collected-attrs next))
    )
  )

(define (html-tag? symbol)
  (and (symbol? symbol)
    (let ((s (symbol->string symbol)))
      (and
        (string=? (substring s 0 1) "<")
        (string=? (substring s (- (string-length s) 1) (string-length s)) ">")))
    ))

(define (inline-expr? e)
  (and (pair? e)
    (and (symbol? (car e))
      (string=? (symbol->string (car e)) "[...]")
      )
    )
  )


(define $rid$ 0)

(define ($typeof x)
  (cond 
    ((string? x) "string")
    ((integer? x) "number")
    ((boolean? x) "boolean")
    ((pair? x) "array")
    (else "null")
    )
  )

(define ($from-html-node el)
  (let ((type (get-attr el "r-type")))
    (cond
      ((string=? type "string") (get-text el))
      ((string=? type "number") (string->number (get-text el)))
      ((string=? type "boolean") (string=? (get-text el) "true"))
      ((string=? type "array") (eval (get-text el)))
      (else "null")
      )
    )
  )

(define (->string value)
  (cond
    ((string? value) value)
    ((integer? value) (number->string value))
    ((boolean? value) (if value "true" "false"))
    ((pair? value) (list->string value))
    (else "null")
    )
  )




