;; A simple DOM manipulation library for ribbit programs targetting js

;; Todos:
;;    - create a tree like:
;;        (div '()
;;            (ol '() (
;;              (li '() "Hello!")
;;              (li '() (a '(href "https://www.google.com"))
;;            )
;;        )
;;    -

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
      "prim2((attr, e) => any_to_rib(e[1][rib_to_str(attr)])),"
      )
    (define-primitive (set-attr element attr-name attr-value)
      (use any_to_rib rib_to_str)
      "prim3((value, name, e) => any_to_rib((e[1][rib_to_str(name)] = rib_to_any(value)))),"
      )
    ;(define-primitive (set-attrs element attrs)
    ;  (use any_to_rib rib_to_str list_to_rib rib_to_list)
    ;  "prim3((values, name, e) => list_to_rib(rib_to_list(values).map(([name, value]) => any_to_rib((e[1][name] = value))))),"
    ;  )
    (define-primitive (set-style element style-name style-value)
      (use any_to_rib rib_to_str)
      "prim3((value, name, e) => any_to_rib((e[1].style[rib_to_str(name)] = rib_to_any(value)))),"
      )
    (define-primitive (add-event element attr-name attr-value)
      (use any_to_rib rib_to_str)
      "prim3((value, name, e) => (e[1].addEventListener(rib_to_str(name), eval(rib_to_any(value))))),"
      )

    (define-primitive (create-element tag)
      (use rib_to_str)
      "() => push(foreign(document.createElement(rib_to_str(pop())))),"
      )
    (define-primitive (append-node parent element)
      (use foreign rib_to_str)
      "prim2((element, parent) => parent[1].append(element[1])),"
      )
    (define-primitive (html-element? element)
      (use bool_to_rib)
      "prim1((e) => bool_to_rib(Array.isArray(e) && e[1] instanceof HTMLElement)),"
      )

    (define-primitive (console.log msg)
      (use rib_to_str)
      "() => push(console.log(rib_to_any(pop()))),"
      )
    (define-primitive (get-document)
      "() => push(foreign(document)),"
      )
    )
  (else
    (exit -1)
    )
  )

