
(define main
  (let ((counter (reactive 0)))
    (<div>
      (<h1> "Hello, world!")
      (<p> "You clicked " counter " times")
      (<button> '@on:click (lambda (e) (counter (+ (counter) 1)))
                "Click me"))
    )
  )

(render main)

