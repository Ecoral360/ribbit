
(cond-expand
  ((host js) ; node
   ; needs the lib js/core.scm to work
   (define-feature 
	 require-http
	 (decl "http=require('http');")
	 )

   (define-primitive 
	 (make-server handler)
	 (use foreign scm2host require-http)
	 "prim1((handler) => foreign(http.createServer(scm2host(handler)))),"
	 )

   (define (server-listen server port)
	 (js-vcall server "listen" port)
	 )

   (define (res-head! response status-code . headers)
	 (js-vcall response "writeHead" status-code (make-headers . headers))
	 )

   (define (res-write! response message)
	 (js-vcall response "write" message)
	 )

   (define (res-end! response message)
	 (js-vcall response "end" message)
	 )

   (define (make-headers . headers)
	 (to-js-obj headers)
	 )
   )
  )




