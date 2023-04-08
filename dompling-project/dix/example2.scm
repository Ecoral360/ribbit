(global-style "body { font-family: sans-serif; }")

(set-title "Todos!")

(define (TodoItem text)
  (let ((checked (reactive #f)))
    (<p>
      (<input> '@type "checkbox" '@bind:checked checked
               '@on:change (lambda () 
                             (if (checked)
                               (console.log (string-append text " is selected!"))
                               (console.log (string-append text " is not selected!"))
                             )))
      text)
  ))

(define main
  (let ((items (reactive (list "Milk" "Eggs" "Bread")))
        (new-item (reactive "")))
    (<div> '@style "display: flex; flex-direction: column; 
           align-items: center; justify-content: center;"
      (<h1> "Todo List")
      (<h3> "Buy:")
      (<ul>
        (rmap TodoItem items)
        )
      (<input> '@type "text" '@bind:value new-item '@placeholder "New item")
      (<button> '@on:click (lambda ()
                             (if (not (string=? "" (new-item)))
                               (begin
                                 (items (append (items) (list (new-item)))) 
                                 (new-item ""))))
                "Add item")
      )
    ))

(render main)


