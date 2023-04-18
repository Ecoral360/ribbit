
(define main
  (let* ((x (reactive 40))
        (y (rbind (lambda () (+ (x) 4))
                  x)))
    (<div>
      "y: " y " is 4 + " x "."
      (<p> "x is " x)
      (<input> '@bind:value~number x '@type "number" '@value (x))
      )
  ))

(render main)

