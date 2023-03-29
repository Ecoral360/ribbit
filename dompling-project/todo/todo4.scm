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

(define counter 10)
(define (get-counter) counter)
;(console.log main)

(define (add-to-counter)
  (set! counter (+ counter 1))
  (set-text (element-by-id "counter") (number->string counter))
  ;  (console.log counter)
  )

;(define x (html-dyn
;            '(<div> @class "main" @style "color: black;"
;               (<h1> "hello world!")
;               (<p> @id "counter" counter)
;                 ;"hey!"
;                )
;            ))
;
; (console.log (html '(<div> "h")))

; (console.log x)
; (console.log (eval x))
; (define main (eval x))
(define main
  (let ((x counter))
    (html-dyn
      '(<div> @class "main" @style "color: black;"
         (<h1> "hello world!")
         (<p> @id "counter" [x])
         (<button> @on:click add-to-counter "Click me!")
         ))))

#|(let ((x 12))
  (console.log (eval-env 'x )))|#

(append-node app main)
