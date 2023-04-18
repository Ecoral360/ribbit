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
      (use foreign scm2str)
      "() => push(foreign(document.querySelector(scm2str(pop())))),"
      )
    (define-primitive (element-by-id id)
      (use foreign scm2str)
      "() => push(foreign(document.getElementById(scm2str(pop())))),"
      )
    (define-primitive (get-attr element attr)
      (use foreign scm2str)
      "prim2((attr, e) => host2scm(e[1].getAttribute(scm2str(attr)))),"
      )
    (define-primitive (get-text element)
      (use str2scm)
      "prim1((e) => str2scm(e[1].innerText)),"
      )
    (define-primitive (set-attr element attr-name attr-value)
      (use host2scm scm2host)
      "prim3((value, name, e) => host2scm((e[1].setAttribute(scm2str(name), scm2host(value))))),"
      )
    (define-primitive (set-text element text)
      (use host2scm scm2host)
      "prim2((value, e) => host2scm((e[1].innerText = `${scm2host(value)}`))),"
      )
    ;(define-primitive (set-attrs element attrs)
    ;  (use host2scm scm2str list_to_rib rib_to_list)
    ;  "prim3((values, name, e) => list_to_rib(rib_to_list(values).map(([name, value]) => host2scm((e[1][name] = value))))),"
    ;  )
    (define-primitive (set-style element style-name style-value)
      (use host2scm scm2host)
      "prim3((value, name, e) => host2scm((e[1].style[scm2str(name)] = scm2host(value)))),"
      )
    (define-primitive (add-event element attr-name attr-value)
      (use host2scm scm2host)
      "prim3((value, name, e) => {e[1].addEventListener(scm2str(name), scm2host(value)); return true;}),"
      )

    (define-primitive (create-element tag)
      (use scm2str)
      "prim1((tag) => foreign(document.createElement(scm2str(tag)))),"
      )
    (define-primitive (to-html-node tag)
      (use scm2host)
      "() => push(foreign(document.createTextNode(scm2host(pop())))),"
      )
    (define-primitive (append-node parent element)
      (use foreign scm2host)
      "prim2((element, parent) => parent[1].append(scm2host(element))),"
      )
    (define-primitive (html-element? element)
      (use bool2scm)
      "prim1((e) => bool2scm(Array.isArray(e) && e[1] instanceof HTMLElement)),"
      )

    (define-primitive (console.log msg)
      (use scm2host)
      "prim1(e => console.log(scm2host(e))),"
      )
    (define-primitive (get-document)
      "() => push(foreign(document)),"
      )

    (define-primitive (observe-node element callback attribute-filter)
      (use foreign scm2host scm2function)
      "prim3((attributes, callback, el) => {
        const observer = new MutationObserver(mutations => {
          console.log(mutations);
          mutations.forEach(mutation => {
              console.log(mutation);
              scm2function(callback)(mutation.target[mutation.attributeName]);
          });
        });
        observer.observe(scm2host(el), { attributes: true, attributeFilter: scm2host(attributes) });
        return true;
      }),"
      )

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

    )
  (else
    (exit -1)
    )
  )



; (define a (lambda (foo bar baz)
;             (console.log "hey!")
;             (console.log foo)
;             (console.log bar)))
;
