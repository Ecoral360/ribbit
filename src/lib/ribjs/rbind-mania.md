# The Suprising Versatility of Reactive Bindings

### What is a reactive binging?

A reactive binding (`rbind` for short) is a particular type of reactive variable 
that has the following properties:
- It is a _readonly_ reactive variable (i.e. you can get its value and attach 
listeners like a normal reactive variable, but you cannot set its value manually)

- It is defined by a function that doesn't take any argument (its _update-function_)
and a list of dependencies. Each dependency must be a reactive variable (of 
any kind, including another reactive binding). 

- The _update-function_ is called once when the reactive binding is created to set 
its internal value.

- The _update-function_ will NOT be called each time you call the reactive 
binding. Instead, the _update-function_ will ONLY be called to update the 
internal value of the reactive binding **when one of its dependency changes**. 
This means that, when you call a reactive binding, you only get the up-to-date 
internal value of the reactive binding.


## How can they be used?

Reactive bindings are very versatile, especially when it comes to the handling 
of reactive list. In fact, reactive lists can be completely implemented using the
power of reactive bindings.


## Implementing Reactive Lists Using Reactive Bindings

The idea is to store a list in a reactive variable and use reactive bindings to
manipulate it in a clear, efficient and useful way.

First, we will need to store our list somewhere. To do so, we will create the 
reactive variable that will contain our list.

```scheme
(define groceries (reactive (list "apple" "orange" "milk")))
```

Nice! Now that we have that, the real fun begins.

### Reactive Mapping (`rmap`)

What can we do with our list? Well, let's say we want to render each element of
our list as an HTML `<li>` inside a `<ul>`, we would do something like this:

```scheme
(define main
 (let ((groceries (reactive (list "apple" "orange" "milk"))))
  (<div>
   (<ul>
    (map (lambda (food) (<li> food)) (groceries)))
   (<button> '@on:click 
    (lambda () (groceries (append (groceries) (list "potato"))))
    "Add potato to the list")
   )
 ))
```

It works! So it was as simple as that? Not quite. It only works now because we 
are not changing the list. If we were to add or remove an element from 
`groceries` (like by clicking the button), the change would not be reflected 
in the web page. That is because `map` produces a _non-reactive_ list.

How can we fix this? Introducting `rmap`.

`rmap` is a function that works like a normal map, except it returns a reactive
value. To be precise, it returns a reactive bind of the initial list. To 
understand it better, lets look at its implementation:

```scheme
(define (rmap f reactive-list)
  (let ((reactive-mapper
          (rbind (lambda () (map f (reactive-list)))
                 (list reactive-list))))
    reactive-mapper
  ))
```

`rmap` takes a function and a reactive variable containing a list. It then 
creates a reactive binding to that variable which recomputes the mapping each 
time the reactive list changes.

Let's use it in our example:
```scheme
(define main
 (let ((groceries (reactive (list "apple" "orange" "milk"))))
  (<div>
   (<ul>
    (rmap (lambda (food) (<li> food)) (groceries)))
   (<button> '@on:click 
    (lambda () (groceries (append (groceries) (list "potato"))))
    "Add potato to the list")
   )
 ))
```

And just like that, it works! 

#### Addressing the performance concerns
If the function mapped is expensive, you should use `rmap-change` which will save
a copy of the old list and only compute the mapping if an element from the new 
list differs from the old one.

Otherwise, you should use the normal `rmap`, as it is more efficient and uses
less memory that `rmap-change` for cheap functions.

`rmap-change` implementation:
```scheme
(define (rmap-change f reactive-list)
  (let ((old-list (reactive-list))
        (reactive-mapper
          (rbind (lambda ()
                   (let ((new-list
                           (map (lambda (pair)
                                  (if (not (equal? (car pair) (cadr pair)))
                                    (f (car pair)) ; if old != new
                                    (car pair))
                                  ) 
                                ; zips both lists until the first one 
                                ; is over. Pads with '() when the second list 
                                ; is over but not the first one
                                (zip-l1 (reactive-list) old-list))))
                     (set! old-list (reactive-list))
                     new-list
                     ))
                 (list reactive-list))))
    reactive-mapper
  ))
```

### Reactive list-tail (`rlist-tail`) and list-ref (`rlist-ref`)

They both pretty much are, to `list-tail` and `list-ref`, what `rmap` is to `map`.

```scheme
(define (rlist-tail reactive-list i)
  (let ((reactive-tail 
          (rbind (lambda ()
                   (if (>= i (list-length (reactive-list)))
                     ; if i is greater than the length of the list, return the whole list
                     (reactive-list)                    
                     (list-tail (reactive-list) i))
                   )
                 (list reactive-list))))
    reactive-tail
    ))

(define (rlist-ref reactive-list i)
  (let ((reactive-ref 
          (rbind (lambda ()
                   (if (>= i (list-length (reactive-list)))
                     ; if i is greater than the length of the list, return '()
                     '()
                     (list-ref (reactive-list) i))
                   )
                 (list reactive-list))))
    reactive-ref
    ))


```
