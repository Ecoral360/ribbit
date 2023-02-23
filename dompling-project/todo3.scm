(define app (element-by-id "app"))
(append-node (query-selector "head")
  (<style>
    ".main {
      font-family: \"Arial\";
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }"))

(define counter 0)
(define (get-counter) counter)
;(console.log main)

(define (add-to-counter)
  (set! counter (+ counter 1))
  (set-text (element-by-id "counter") (number->string counter))
  (console.log counter)
  )

(define main
  (html
    '(<div> @class "main" @style "color: black;"
       (<h1> "hello world!")
       (<p> @id "counter" counter)
       (<button> @on:click add-to-counter "Click me!")
       )))




(append-node app main)
