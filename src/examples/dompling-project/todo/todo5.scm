(ribjs/render)
(ribjs/reactive)

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
  (let* ((counter (r-new 10))
         (get-counter (r-getter counter))
         (set-counter! (r-setter counter)))

    (<div> '@class "main"
           (<h1> "Hello, World!")
           (<p> "This is a simple example of a web app written
                in Scheme.")
           (<p> "The counter is currently at " counter ".")
           (<button> 
             '@on:click (lambda (e) 
                          (set-counter! (+ (get-counter) 1)))
             "Counter + 1"
             )
           ))
    )

(render main)


