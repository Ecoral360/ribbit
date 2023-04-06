
(define main
  (let ((counter (r-new 0)))
    (<h1> "Hello, world!")
    (<p> "You clicked " counter " times")
    (<button> '@on:click (lambda () (counter (+ (counter) 1)))
              "Click me"))
    
  )

(render main)
