(define style (create-element "style"))
(set-text style "
body {
  background-color: lightgray;
}
ol > li > span {
  color: black;
}
ol {
  list-style-type: none;
}
button {
  color: red;
}
")

(append-node style (query-selector "head"))


(define app (element-by-id "app"))
(define todos (create-element "ol"))

(define new-todo (lambda ()
                   (let ((box (create-element "input")) (item (create-element "li")) (text (create-element "span")))
                     (set-attr box "type" "checkbox")
                     (set-text text (get-attr input "value"))
                     (append-node box item)
                     (append-node text item)
                     (append-node item todos)
                     (set-attr input "value" "")
                     )
                   )
  )

(set! input (create-element "input"))
(set-attr input "type" "text")

(set! button (create-element "button"))
(add-event button "click" new-todo)
(set-text button "New Todo!")

(append-node todos app)
(append-node input app)
(append-node button app)

