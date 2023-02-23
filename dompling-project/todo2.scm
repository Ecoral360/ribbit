(define app (element-by-id "app"))
(append-node (query-selector "head")
  (style
    ".main {
      font-family: \"Arial\";
    }"))

(define counter 0)


(define main
  (div '(class "main" style "
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  ")
    '((h1 '() "Hello World!")
       (p '() counter)
       (button '(on:click (lambda (e) (set! counter (+ counter 1)) (console.log counter))) "Click me!"))
    )
  )


(append-node app main)
