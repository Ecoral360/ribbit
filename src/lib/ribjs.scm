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

(define set-text (lambda (el txt) (set-attr el "innerText" txt)))

(define (set-attrs el attrs)
  (if (pair? attrs)
    (let* ((attr (car attrs))
            (rest (cdr attrs))
            (attr-name (if (string? (car attr)) (car attr) (symbol->string (car attr)))))
      (set-attr el attr-name (cadr attr))
      (set-attrs el rest))
    ()
    ))

(define (add-children el children)
  (cond
    ((string? children)
      (define x (create-element "span"))
      (set-text x children)
      (append-node el x)
      )
    ((pair? children)
      (for-each
        (lambda (child) (add-children el child))
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
