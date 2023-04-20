(define $RENDER_MODULE$ #t)

(define (render main)
  (append-node (element-by-id "app") main)
  )


(define (global-style style)
  (append-node (query-selector "head") (<style> style))
  )

(define (set-title! title) 
  (set-text (query-selector "head > title") title)
            )

