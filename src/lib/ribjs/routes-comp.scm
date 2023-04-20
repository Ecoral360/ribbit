(define $ROUTER_MODULE$ #t)

;; A router is a vector that contains a list of routes.
;; A route is a list composed of a symbol (the method), a string (the path) and a procedure (the handler).
;; 
;; > NOTE: The first element of the vector is the 404 handler.
;;
;; A handler is a procedure that takes a request and returns a response.
;;	 Request take the form: '(path query-string)
;;	 Response is a valid Ribjs component.

;; ---------------------------------------------------------------- ;;
;; ------------------------- ROUTES ------------------------------- ;;
;; ---------------------------------------------------------------- ;;

(define (route path handler)
  (list path handler))

(define (match-route route request)
  (string=? (car route) (car request))) ; check if the path matches

;; ---------------------------------------------------------------- ;;
;; ------------------------- ROUTER ------------------------------- ;;
;; ---------------------------------------------------------------- ;;

(define (make-router route-404 . routes)
  (let ((router (list route-404))) ; the 404 handler is the first element of the vector
	(for-each (lambda (route) (set! router (append router (list route)))) routes)
	(list->vector router)
  )) 

(define (add-route! router route)
  (vector-set! router (vector-length router) route))

(define (call-route router request)
  (let ((handler (get-route-handler router request))) ; get the handler for the request
	(handler request))) ; call the handler with the request

(define (get-route-handler router request)
  (let loop ((i 1))
	(if (>= i (vector-length router))
	  (cadr (vector-ref router 0)) ; if no route matches, return the 404 handler
	  (let ((route-handler (vector-ref router i)))
		(if (match-route route-handler request) ; if the route matches
		  (cadr route-handler) ; return the handler
		  (loop (+ i 1))))) ; otherwise, try the next route
	))


;; ---------------------------------------------------------------- ;;
;; ------------------------- RENDER ------------------------------- ;;
;; ---------------------------------------------------------------- ;;

(define (render-route router)
  (let ((response (call-route router (list (current-path-name)))))
	response))

