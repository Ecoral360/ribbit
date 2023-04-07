
(define main
  (let ((name (reactive "John"))
        (counter (reactive 0)))

    (<div>
      (<h1> "Hello, world!")
      (<p> name ", you clicked " counter " times")
      (<input> '@type "text" '@bind:value name '@value (name))
      (<button> '@on:click (lambda () (counter (+ (counter) 1)))
                "Click me (you already clicked " counter " times)")
    )
  ))

(render main)

