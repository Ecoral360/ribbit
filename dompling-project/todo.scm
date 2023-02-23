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

(append-node (query-selector "head") style)


(define app (element-by-id "app"))
(define todos (create-element "ol"))

(define new-todo (lambda ()
                   (let ((box (create-element "input")) (item (create-element "li")) (text (create-element "span")))
                     (set-attr box "type" "checkbox")
                     (set-text text (get-attr input "value"))
                     (append-node item box)
                     (append-node item text)
                     (append-node todos item)
                     (set-attr input "value" "")
                     )
                   )
  )

(define input (create-element "input"))
(set-attr input "type" "text")

(define button (create-element "button"))
(add-event button "click" new-todo)
(set-text button "New Todo!")

(append-node app todos)
(append-node app input)
(append-node app button)

