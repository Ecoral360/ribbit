;; A simple DOM manipulation library for ribbit programs targetting js

;; Todos:
;;    - create a tree like:
;;        (div '()
;;            (ol '() (
;;              (li '() "Hello!")
;;              (li '() (a '(href "https://www.google.com"))
;;            )
;;        )
;;    -
;; ribjs needs dompling to work


(define (set-attrs el attrs)
  (if (pair? attrs)
    (if (pair? (car attrs))     ; syntax: (attribute "value")
      (let* ((attr (caar attrs))
              (value (cdr (car attrs)))
              (rest (cdr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))
        (set-attr el attr-name value)
        (set-attrs el rest))
      (let* ((attr (car attrs)) ; syntax: attribute "value"
              (value (cadr attrs))
              (rest (cddr attrs))
              (attr-name (if (string? attr) attr (symbol->string attr))))
        (set-attr el attr-name value)
        (set-attrs el rest))
      )))

(define (add-children el children)
  (cond
    ((string? children)
      (define x (create-element "span"))
      (set-text x children)
      (append-node el x)
      )
    ((pair? children)
      (for-each
        (lambda (child) (add-children el (eval child))) ; (console.log child))
        children)
      )
    ((html-element? children)
      (append-node el children)
      )
    ))

(define (component name)
  (lambda (args children)
    (define el (create-element (symbol->string name)))
    (set-attrs el args)
    (add-children el children)
    el
    ))

(define (component-old name)
  (lambda (child)
    (define el (create-element (symbol->string name)))
    (set-text el child)
    el
    ))

(define div (component 'div))
(define span (component 'span))
(define p (component 'p))
(define pre (component 'pre))

(define br (lambda () (create-element "br")))

(define input (component 'input))
(define button (component 'button))
(define h1 (component 'h1))
(define h2 (component 'h2))
(define h3 (component 'h3))
(define h4 (component 'h4))
(define h5 (component 'h5))
(define h6 (component 'h6))
(define nav (component 'nav))
(define form (component 'form))
(define label (component 'label))
(define ol (component 'ol))
(define ul (component 'ul))
(define li (component 'li))

(define style
  (lambda (css)
    (define s (create-element "style"))
    (set-text s css)
    s))