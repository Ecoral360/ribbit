(cond-expand
  ((host js)

   (define-primitive (js-get element property)
					 (use scm2host host2scm)
					 "prim2((property, element) => host2scm(element[1][scm2host(property)])),"
					 )

   (define-primitive (js-call element function-name args)
					 (use scm2host host2scm)
					 "prim3((args, function_name, element) => host2scm(element[1][scm2host(function_name)](...scm2host(args)))),"
					 )

   (define-primitive (js-set element property value)
					 (use scm2host host2scm)
					 "prim3((value, property, element) => host2scm(element[1][scm2host(property)] = scm2host(value))),"
					 )

   (define-primitive (to-js-obj array)
					 (use scm2host foreign)
					 "prim1((array) => foreign(Object.fromEntries(scm2host(array)))),"
					 )
   )
  (else (error -1))
  )


;; stands for javascript variadic call
(define (js-vcall element function-name . args)
  (js-call element function-name args)
  )



