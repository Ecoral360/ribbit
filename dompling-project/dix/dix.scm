(global-style 
  "body { font-family: sans-serif; }
  ")

(define (TodoItem text)
  (<li> text))

(define main
  (let ((items (reactive (list "Buy milk" "Buy eggs" "Buy bread")))
        (new-item (reactive "")))
    (<div> '@style "display: flex; flex-direction: column; 
           align-items: center; justify-content: center;"
      (<h1> "Todo List")
      (<ul>
        (rmap TodoItem items)
        )
      (<input> '@type "text" '@bind:value new-item '@placeholder "New item")
      (<button> '@on:click (lambda () 
                             (items (append (items) (list (new-item)))) 
                             (new-item ""))
                "Add item")
      )
    ))

(render main)
