(define app (element-by-id "app"))
(define d (span '((style "color: blue")) "TEST!"))
(define nav
  (div '()
    '((span '() "hey!")
       (span '() "you")
       "AAAA")
    )
  )

(console.log d)
(console.log nav)
(append-node app d)
(append-node app nav)
