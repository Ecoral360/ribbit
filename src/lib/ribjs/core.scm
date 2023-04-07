;; Built on top of dompling, Ribjs is a fully reactive scheme framework to build 
;; web applications. It is inspired by React and Vue.js.
;;
;; To start, you need to get the app element using the function

(define (list . args) args)

(define (starts-with str prefix)
  (and (string? str)
       (and (string? prefix)
            (let ((len (string-length prefix)))
              (and (<= len (string-length str))
                   (string=? (substring str 0 len) prefix))))))

(define (ends-with str postfix)
  (and (string? str) 
       (and (string? postfix)
            (let ((plen (string-length postfix)) (slen (string-length str)))
              (and (<= plen slen)
                   (string=? postfix (substring str (- slen plen) slen))
                          ))))
  )

(define (set-attrs-inner el attr-name value)
  (cond 
    ((starts-with attr-name "on-raw:")
     (add-event el (substring attr-name 7 (string-length attr-name)) value))

    ((starts-with attr-name "on:")
     (let ((event-name (substring attr-name 3 (string-length attr-name))))
       (add-event el event-name (lambda (e) (value)))))

    ((starts-with attr-name "bind:")
     (let ((bind-attr (substring attr-name 5 (string-length attr-name))))
       (cond 
         ((starts-with bind-attr "value")
          (let ((type (cond
                        ((ends-with bind-attr "~number") "number")
                        ((ends-with bind-attr "~boolean") "boolean")
                        ((ends-with bind-attr "~string") "string")
                        ((ends-with bind-attr "~array") "array")
                        (else "string"))))
                (add-event el "input" (lambda (e) (value (<-string (js-get (js-get e "target") "value") type))))
                (if (and $REACTIVE_MODULE$ ($reactive? value))
                  (value '$add-listener (lambda (new-value) (js-set el "value" (->string new-value))))
                  )
                ))
         ((string=? bind-attr "checked")
          (add-event el "input" (lambda (e) (value (js-get (js-get e "target") "checked")))))
         (else (error (string-append "Unknown bind attribute: " bind-attr)))
         )
       ))

    ((starts-with attr-name "bind-attr:")
     (let ((bind-attr (substring attr-name 10 (string-length attr-name))))
       (observe-node el value (cons bind-attr '()))
       ))

    (else (set-attr el attr-name value)))
  )

(define (set-attrs el attrs)
  (if (pair? attrs)
    (if (pair? (car attrs))     ; syntax: (attribute "value")
      (let* ((attr (caar attrs))
              (value (cdr (car attrs)))
              (rest (cdr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))
        (set-attrs-inner el attr-name value)
        (set-attrs el rest))
      (let* ((attr (car attrs)) ; syntax: attribute "value"
              (value (cadr attrs))
              (rest (cddr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))

          (set-attrs-inner el attr-name value)
          (set-attrs el rest))
      )))

(define (add-children el children)
  (cond
    ;; Check if the reactive module is enabled. If so, check if the value is reactive
    ((and $REACTIVE_MODULE$ ($reactive? children))
     (let ((child (create-element "span")) (value (children)))
       (add-children child value)
       (children '$add-listener (lambda (new-value) (set-text child "") (add-children child new-value)))
       (append-node el child)
     ))
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



(define ($typeof x)
  (cond 
    ((string? x) "string")
    ((integer? x) "number")
    ((boolean? x) "boolean")
    ((pair? x) "array")
    (else "null")
    )
  )

(define (<-string value type)
    (cond
      ((string=? type "string") value)
      ((string=? type "number") (string->number value))
      ((string=? type "boolean") (string=? value "true"))
      ((string=? type "array") (eval value))
      (else "null")
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




