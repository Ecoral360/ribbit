(define router (make-router 
  (route "404" (lambda (path) (<p> (string-append "Not found " (car path)))))
  (route "/" (lambda (path) (<p> "Home")))
  (route "/hello" (lambda (path) (<p> (string-append "Hello, " (query-param "name")))))
  ))


(define main
  (let ((x (reactive "Hello, world!")))
  (<div>
	(<h1> x)
	(render-route router)
	)
  ))

(render main)
