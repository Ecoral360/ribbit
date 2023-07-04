;; R4RS as a library for ribbit.

(##include-once "./bool.scm")
(##include-once "./types.scm")
(##include-once "./pair-list.scm")
(##include-once "./vector.scm")
(##include-once "./char.scm")
(##include-once "./number.scm")
(##include-once "./math.scm")

(if-feature
  v-port
  (begin (##include-once "./v-io.scm"))
  (begin (##include-once "./io.scm")))

(##include-once "./error.scm")
(##include-once "./control.scm")
(##include-once "./string.scm")
(##include-once "./compiler.scm")


;;;----------------------------------------------------------------------------

;; Symbols (R4RS section 6.4).

;; (define global-var-ref field0)
;; (define global-var-set! field0-set!)

;;;----------------------------------------------------------------------------
