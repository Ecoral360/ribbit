(define (list . args)
  args)

(define server 
  (make-server 
	(lambda (req res)
	  (res-head! res 200 '(Content-Type text/plain))
	  (res-end! res "Hello world!\n")
	  ))
  )


(server-listen server 3000)

