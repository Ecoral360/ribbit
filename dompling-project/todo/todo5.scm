(define app (element-by-id "app"))

(append-node 
  (query-selector "head")
  (<style>
    ".main {
        font-family: Arial, Helvetica, sans-serif;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }"))

(define main
  (let ((counter 0)
         (inc-counter! (lambda (e) (set! counter (+ counter 1)))))

    (<div> '@class "main"
           (<h1> "Hello, World!")
           (<p> "This is a simple example of a web app written in Scheme.")
           (<p> "The counter is currently at " counter ".")
           (<button> '@on:click inc-counter!
                     "Counter + 1"))
    )
  )


(append-node app main)
