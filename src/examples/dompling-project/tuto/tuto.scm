(set-title "Ribjs Tutorial")


(define page1
  (<div>
	(<p> "This is Page 1!")
	)
  )

(define page2
  (<div>
	(<p> "This is Page 2!")
	)
  )

(define page-error
  (<div>
	(<p> "This is the error page!")
	)
  )

(define main
  (let* ((curr-page-idx (reactive 1))
		 (curr-page (rbind (lambda ()
							 (cond
							   ((eq? (curr-page-idx) 1) page1)
							   ((eq? (curr-page-idx) 2) page2)
							   (else (<span> page-error " Page " (curr-page-idx) " doesn't exists"))
							   )
							 )
						   curr-page-idx)))
	(<div>
	  (<h1> "Hello, World!")
	  curr-page 
	  (<div> '@style "display: flex; margin-top: 2em;"
			 (<button> '@on:click (lambda () (curr-page-idx (- (curr-page-idx) 1))) "Previous")
			 (<button> '@on:click (lambda () (curr-page-idx (+ (curr-page-idx) 1))) "Next")
			 )
	  )
	))

(render main)
