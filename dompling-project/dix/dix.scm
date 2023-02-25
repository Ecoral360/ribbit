(define app (element-by-id "app"))

(append-node (query-selector "head")
  (<style> "
   .main {
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
   }
  "))

(define main
  (html
    '(<div> @class "main"
       (<h1> "Test")
       (<p> "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aut autem corporis, deleniti deserunt dolores eius facilis fuga illo, impedit incidunt itaque molestiae molestias necessitatibus, nulla placeat possimus praesentium qui sit?")
       (<button> @on:click )
       )
    ))

(append-node app main)
