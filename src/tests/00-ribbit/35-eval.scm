(export *)

(write (eval (read)))
(##putchar 10)

;;;run: -l min
;;;run: -l max
;;;variadics-run: -l min -f+ arity-check
;;;variadics-run: -l max -f+ arity-check
;;;r4rs-run: -l r4rs
;;;input:(* 6 7)
;;;expected:
;;;42
