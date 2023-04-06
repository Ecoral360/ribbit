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

(define (component-no-args name)
  (lambda (children)
    (define el (create-element (symbol->string name)))
    (add-children el children)
    el
    ))

(define <div> (component 'div))
(define <span> (component 'span))
(define <p> (component 'p))
(define <pre> (component 'pre))

(define <br> (lambda () (create-element "br")))

(define <input> (component 'input))
(define <button> (component 'button))
(define <h1> (component 'h1))
(define <h2> (component 'h2))
(define <h3> (component 'h3))
(define <h4> (component 'h4))
(define <h5> (component 'h5))
(define <h6> (component 'h6))
(define <nav> (component 'nav))
(define <form> (component 'form))
(define <label> (component 'label))
(define <ol> (component 'ol))
(define <ul> (component 'ul))
(define <li> (component 'li))
(define <style> (component-no-args 'style))


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

(define (parse-node node)
  (if (or (integer? node) (string? node))
    (to-html-node node)
    (let*
      ((node-tag (symbol->string (car node)))
        (attrs&children (split-attrs&children (cdr node)))
        (attrs (car attrs&children))
        (children (cdr attrs&children))
        (parsed-node (create-element (substring node-tag 1 (- (string-length node-tag) 1)))) ; removes the '<' and '>' from the tag
        )
      ; (console.log attrs)
      (set-attrs parsed-node attrs)
      ; (console.log children)
      (for-each
        (lambda (child)
          (cond
            ((or (integer? child) (string? child))
              (append-node parsed-node (to-html-node child))
              )

            ((symbol? child)
              (append-node parsed-node (parse-node (eval child))))

            ((and (pair? child) (inline-expr? child))
              (append-node parsed-node (parse-node (eval (cadr child))))
              )

            ((pair? child)
              (append-node parsed-node (parse-node child))
              ))
          )
        children)
      parsed-node)
    ))

(define (html root)
  (parse-node root))



(define (parse-node-dyn node)
  (if (or (integer? node) (string? node))
    (to-html-node node)
    (let*
      ((node-tag (symbol->string (car node)))
        (attrs&children (split-attrs&children (cdr node)))
        (attrs (car attrs&children))
        (children (cdr attrs&children))
        (parsed-node (create-element (substring node-tag 1 (- (string-length node-tag) 1)))) ; removes the '<' and '>' from the tag
        )
      ; (console.log attrs)
      (set-attrs parsed-node attrs)
      ; (console.log children)
      (for-each
        (lambda (child)
          (cond
            ((or (integer? child) (string? child))
              (append-node parsed-node (to-html-node child))
              )

            ((symbol? child)
              (append-node parsed-node (parse-node (eval child))))

            ((and (pair? child) (inline-expr? child))
              (append-node parsed-node (parse-node (eval (cadr child))))
              )

            ((pair? child)
              (append-node parsed-node (parse-node child))
              ))
          )
        children)
      parsed-node)
    ))

(define (html-dyn root)
  (parse-node-dyn root))
