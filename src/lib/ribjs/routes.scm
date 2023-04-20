(define $ROUTER_MODULE$ #t)

;; A router is a vector that contains a list of routes.
;; A route is a list composed of a symbol (the method), a string (the path) and a procedure (the handler).
;; 
;; > NOTE: The first element of the vector is the 404 handler.
;;
;; A handler is a procedure that takes a request and returns a response.
;;	 Request take the form: '(method path body query-string headers)
;;	 Response take the form: '(status-code body headers) or '(list status-code body)

;; ---------------------------------------------------------------- ;;
;; ------------------------- ROUTES ------------------------------- ;;
;; ---------------------------------------------------------------- ;;

(define (route method path handler)
  (list method path handler))

(define (route-get path handler)
  (route 'GET path handler))

(define (route-post path handler)
  (route 'POST path handler))

(define (match-route route request)
  (and (eq? (car route) (request-method request)) ; check if the method matches
	 (string=? (cadr route) (request-path request)))) ; check if the path matches

;; ---------------------------------------------------------------- ;;
;; ------------------------- ROUTER ------------------------------- ;;
;; ---------------------------------------------------------------- ;;

(define (make-router route-404 . routes)
  (let ((router (list->vector (list route-404)))) ; the 404 handler is the first element of the vector
	(for-each (lambda (route) (add-route! router route)) routes)
	router
  )) 

(define (add-route! router route)
  (vector-set! router (vector-length router) route))

(define (call-route router request)
  (let ((handler (get-route-handler router request))) ; get the handler for the request
	(handler request))) ; call the handler with the request

(define (get-route-handler router request)
  (let loop ((i 1))
	(if (>= i (vector-length router))
	  (vector-ref router 0) ; if no route matches, return the 404 handler
	  (let ((route-handler (vector-ref router i)))
		(if (match-route route-handler request) ; if the route matches
		  (caddr route-handler) ; return the handler
		  (loop (+ i 1))))) ; otherwise, try the next route
	))

;; ---------------------------------------------------------------- ;;
;; ------------------------- REQUESTS ----------------------------- ;;
;; ---------------------------------------------------------------- ;;

;; A request is a list of the form: '(method path body query-string headers)
;;	A method is one of the following symbols: 'GET, 'POST, 'PUT, 'DELETE, 'HEAD, 'OPTIONS, 'PATCH;
;;	A path is a string;
;;	A body is a string;
;;	A query-string is a string;
;;	A headers is a list of pairs of strings.
(define (make-request method path body query-string headers)
  (list method path body query-string headers))

;; Returns the method of the request
(define (request-method request)
  (car request))

;; Returns the path of the request 
(define (request-path request)
  (car (cdr request)))

;; Returns the body of the request 
(define (request-body request)
  (car (cdr (cdr request))))

;; Returns the query-string of the request 
(define (request-query-string request)
  (car (cdr (cdr (cdr request)))))

;; Returns the headers of the request 
(define (request-headers request)
  (car (cdr (cdr (cdr (cdr request))))))


;; ---------------------------------------------------------------- ;;
;; ------------------------- RESPONSES ---------------------------- ;;
;; ---------------------------------------------------------------- ;;

;; A response is a list of the form: '(status-code body headers)
;;	A status-code is a number;
;;	A body is a string;
;;	A headers is a list of pairs of strings.

(define (response status-code body . headers)
  (list status-code body headers))

;; Returns the status-code of the response
(define (response-status-code response)
  (car response))

;; Returns the body of the response
(define (response-body response)
  (car (cdr response)))

;; Returns the headers of the response 
(define (response-headers response)
  (car (cdr (cdr response))))

(define (resp-ok body headers)
  (response 200 body . headers))

(define (resp-not-found body . headers)
  (response 404 body headers))

(define (resp-internal-server-error body . headers)
  (response 500 body headers))

