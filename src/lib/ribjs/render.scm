(define $RENDER_MODULE$ #t)

(define (render main)
  (append-node (element-by-id "app") main)
  )

(define (global-style style)
  (append-node (query-selection "head") (<style> style))
  )


