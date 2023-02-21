;; A simple DOM manipulation library for ribbit programs targetting js

(cond-expand
  ((host js)
    (define-primitive (query-selector query)
      (use foreign rib_to_str)
      "() => push(foreign(document.querySelector(rib_to_str(pop())))),"
      )
    (define-primitive (element-by-id id)
      (use foreign rib_to_str)
      "() => push(foreign(document.getElementById(rib_to_str(pop())))),"
      )
    (define-primitive (get-attr element attr)
      (use foreign rib_to_str)
      ;; If v is an object and not an array, we push it as is. Else, we convert it to a foreign rib.
      "() => {let attr = pop(); let v = pop()[1][rib_to_str(attr)]; return push(any_to_rib(v))},"
      )
    (define-primitive (set-attr element attr-name attr-value)
      (use any_to_rib rib_to_str)
      ;; If v is an object and not an array, we push it as is. Else, we convert it to a foreign rib.
      "prim3((value, name, e) => (e[1][rib_to_str(name)] = rib_to_any(value))),"
      )
    (define-primitive (add-event element attr-name attr-value)
      (use any_to_rib rib_to_str)
      ;; If v is an object and not an array, we push it as is. Else, we convert it to a foreign rib.
      "prim3((value, name, e) => (e[1].addEventListener(rib_to_str(name), eval(rib_to_any(value))))),"
      )
    (define-primitive (console.log msg)
      (use rib_to_str)
      "() => push(console.log(rib_to_str(pop()))),"
      )
    )
  )



