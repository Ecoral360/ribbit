(define app (element-by-id "app"))
(append-node (query-selector "head")
  (style
    ".main {
      font-family: \"Arial\";
    }"))

(define main
  (div '((class "main") (style "
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  "))
    '((h1 '() "Hello World!")
       (div '()
         (p '(style "max-width: 40ch; text-align: justify;") "Excepturi voluptate sint est tempora dolore necessitatibus ut quam. Quia porro aut voluptatibus est. Eligendi excepturi voluptas iure porro commodi odit molestiae vel. Soluta omnis repellendus omnis explicabo molestiae ut maxime. Vel consequatur officia aspernatur animi dolore in dignissimos.")
         )))
  )


(append-node app main)
