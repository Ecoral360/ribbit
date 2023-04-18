(set-title "Game")

(define (draw-grid ctx box-size)
  (ctx-props 
	ctx 
	'lineWidth 1
	)
  (for-each
	(lambda (x)
	  (ctx-make-path
		ctx 
		'moveTo x 0
		'lineTo x 500
		'stroke
		)
	  )
	(range box-size 500 box-size)
	)
  (for-each
	(lambda (y)
	  (ctx-make-path
		ctx 
		'moveTo 0 y
		'lineTo 500 y
		'stroke
		)
	  )
	(range box-size 500 box-size)
	)
  )


(define main
  (let* ((canvas (<canvas> '@id "canvas" '@width 500 '@height 500 '@style "border: 1px solid"))
		 (ctx (canvas-ctx canvas "2d")))
	(draw-grid ctx 25)
	(<div>
	  (<h1>  "My game")
	  canvas
	  )
	))

(render main)
