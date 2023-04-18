(define (canvas-ctx canvas ctx-type)
  (js-call canvas "getContext" (list ctx-type))
  )


;; This functions calls `beginPath()` and then calls the functions in args
(define (ctx-make-path ctx . args)
  (begin-path ctx)
  (let ((curr_func '())
		(curr_args '()))
	(for-each 
	  (lambda (arg) 
		(if (symbol? arg)
		  (begin 
			(if (not (null? curr_func))
			  (js-call ctx curr_func curr_args))
			(set! curr_func arg)
			(set! curr_args '())
			)
		  (set! curr_args (cons arg curr_args))
		  )
		)
	  args)
	(if (not (null? curr_func))
	  (js-call ctx curr_func curr_args))
	))

(define (ctx-props ctx . args)
  (let loop ((prop (car args))
			 (val (cadr args))
			 (rest (cddr args)))
	(js-set ctx prop val)
	(if (not (null? rest))
	  (loop (car rest) (cadr rest) (cddr rest))
	  )
	)
  )

(define (set-canvas-prop! canvas prop val)
  (js-set canvas prop val)
  )

(define (begin-path ctx)
  (js-call ctx "beginPath" '())
  )

(define (line-to ctx x y)
  (js-call ctx "lineTo" (list x y))
  )

(define (move-to ctx x y)
  (js-call ctx "moveTo" (list x y))
  )

(define (stroke ctx)
  (js-call ctx "stroke" '())
  )

(define (stroke-text ctx text x y)
  (js-call ctx "strokeText" (list text x y))
  )

(define (fill ctx)
  (js-call ctx "fill" '())
  )

(define (fill-text ctx text x y)
  (js-call ctx "fillText" (list text x y))
  )

(define (fill-rect ctx x y w h)
  (js-call ctx "fillRect" (list x y w h))
  )

(define (arc ctx x y r start-angle end-angle)
  (js-call ctx "arc" (list x y r start-angle end-angle))
  )

(define (arc-to ctx x1 y1 x2 y2 r)
  (js-call ctx "arcTo" (list x1 y1 x2 y2 r))
  )

(define (bezier-curve-to ctx cp1x cp1y cp2x cp2y x y)
  (js-call ctx "bezierCurveTo" (list cp1x cp1y cp2x cp2y x y))
  )

(define (quadratic-curve-to ctx cpx cpy x y)
  (js-call ctx "quadraticCurveTo" (list cpx cpy x y))
  )

(define (rect ctx x y w h)
  (js-call ctx "rect" (list x y w h))
  )

(define (clear-rect ctx x y w h)
  (js-call ctx "clearRect" (list x y w h))
  )

(define (close-path ctx)
  (js-call ctx "closePath" '())
  )

(define (clip ctx)
  (js-call ctx "clip" '())
  )
