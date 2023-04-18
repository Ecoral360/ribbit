(set-title "My blog!")

(define main
  (let ((canvas (<canvas> '@width 500 '@height 500 '@style "border: 2px solid")))

	(<div>
	  (<h1> "Welcome to my blog!") 
	  (<p>)
	  canvas
	  (<page1>)
	  )
	))

(render main)
