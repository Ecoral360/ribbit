
(define (<page1>)
  (<div>
	(<h1> "Page 1")
	(<p> "This is page 1")
	(<a> '@href "/page2" "Go to page 2")
	)
  )
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
