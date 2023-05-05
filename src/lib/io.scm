(cond-expand
  ((host js)

   (define-primitive 
     (open-input-file filename)
     (use io scm2str)
     "prim1(filename => make_input_port(node_fs.openSync(scm2str(filename), 'r'))),"
     )

   (define-primitive
     (open-output-file filename)
     (use io scm2str)
     "prim1(filename => make_output_port(node_fs.openSync(scm2str(filename), 'w'))),"
     )

   (define-primitive
     (##read-char port)
     (use io)
     "prim1(port => {
        let buf=Buffer.alloc(1); 
        let ch = node_fs.readSync(port[0], buf, {position: port[0] === 0 ? null : port[1][0]++}) === 0 ? NIL : buf[0]; 
        return ch;
      }),"
   )

   (define-primitive
     (##write-char ch port)
     (use io)
     "prim2((port, ch) => node_fs.writeSync(port[0], String.fromCodePoint(ch), null, 'utf8')),"
   )

   (define-primitive
     (close-input-port port)
     (use io)
     "prim1(port => { if (port[1][2] === TRUE) {
        node_fs.closeSync(port[0]);
        port[1][2] = FALSE;
     }}),"
     )

   (define-primitive
     (close-output-port port)
     (use io)
     "prim1(port => { if (port[1] === TRUE) {
        node_fs.closeSync(port[0]);
        port[1] = FALSE;
     }}),"
     )))

(define ##eof (rib 0 0 5))

(define (eof-object? obj)
  (eqv? obj ##eof))

(define default-input-port
  (rib 0 (rib 0 '() #t) 8)) ;; stdin

(define default-output-port
  (rib 1 #t 9))  ;; stdout

(define (current-input-port)
  default-input-port)

(define (current-output-port)
  default-output-port)

;; ---------------------- INPUT ---------------------- ;;

(define (input-port? port)
  (eqv? (field2 port) 8))

(define (call-with-input-file filename proc)
  (let* ((port (open-input-file filename))
         (result (proc port)))
    (close-input-port port)
    result))

(define (input-port-close? port)
  (eqv? (field2 (field1 port)) #f))


(define (read (port (current-input-port)))
  (if (input-port-close? port)
    (error "Cannot read from a closed port")
    (error "TODO")))

(define (##get-last-char port)
  (field1 (field1 port)))

(define (##set-last-char port ch)
  (field1-set! (field1 port) ch))

(define (read-char (port (current-input-port))) ;; ????????
  (if (input-port-close? port)
    (error "Cannot read from a closed port"))
  (if (eqv? (##get-last-char port) '())
    (let ((ch (##read-char port)))
      (if (eqv? ch '())
        ##eof 
        ch))
    (let ((ch (##get-last-char port)))
      (##set-last-char port '())
      ch)))

(define (peek-char (port (current-input-port)))
  (if (input-port-close? port)
    (error "Cannot read from a closed port"))
  (if (eqv? (##get-last-char port) '())
    (let* ((ch (##read-char port)) (ch (if (eqv? ch '()) ##eof ch)))
      (##set-last-char port ch)
      ch)
    (##get-last-char port)))

;; ---------------------- OUTPUT ---------------------- ;;

(define (output-port? port)
  (eqv? (field2 port) 9))

(define (call-with-output-file filename proc)
  (let* ((port (open-output-file filename))
         (result (proc port)))
    (close-output-port port)
    result))

(define (write-char ch (port (current-output-port)))
  (##write-char ch port))

(define (newline (port (current-output-port)))
  (write-char 10 port))

(define (write o (port (current-output-port)))
  (cond ((eqv? (field2 o) 3) ;; string?
         (write-char 34 port)
         (write-chars (string->list o) port)
         (write-char 34 port))
        (else
         (display o port))))

(define (display o (port (current-output-port)))
  (cond ((eqv? o #f)
         (write-char 35 port)
         (write-char 102 port)) ;; #f
        ((eqv? o #t)
         (write-char 35 port)
         (write-char 116 port)) ;; #t
        ((eof-object? o)
         (display "#!eof" port))
        ((eqv? o '())
         (write-char 40 port)
         (write-char 41 port)) ;; ()
        ((eqv? (field2 o) 0) ;; pair?
         (write-char 40 port)  ;; #\(
         (write (field0 o) port) ;; car
         (write-list (field1 o) port) ;; cdr
         (write-char 41 port)) ;; #\)
        ((eqv? (field2 o) 2) ;; symbol?
         (display (field1 o) port)) ;; name
        ((eqv? (field2 o) 3) ;; string?
         (write-chars (field0 o) port)) ;; chars
;;        ((vector? o)
;;         (write-char 35) ;; #\#
;;         (write (vector->list o)))
        ((eqv? (field2 o) 1) ;; procedure?
         (write-char 35 port)
         (write-char 112 port)) ;; #p
        (else
         ;; must be a number
         (display (number->string o) port))))

(define (write-list lst port)
  (if (eqv? (field0 lst) 0) ;; pair?
      (begin
        (write-char 32 port) ;; #\space
        (if (eqv? (field2 lst) 0) ;; pair?
            (begin
              (write (field0 lst) port) ;; car
              (write-list (field1 lst) port))  ;; cdr
            #f)) ;; writing dotted pairs is not supported
      #f))

(define (write-chars lst port)
  (if (eqv? (field2 lst) 0) ;; pair?
      (let ((c (field0 lst))) ;; car
        (write-char c port)
        (write-chars (field1 lst) port)) ;; cdr
      #f))

;; ---------------------- UTIL ---------------------- ;;

(define (number->string x)
  (list->string
   (if (< x 0)
       (rib 45 (number->string-aux (- 0 x) '()) 0) ;; cons
       (number->string-aux x '()))))

(define (number->string-aux x tail)
  (let ((q (quotient x 10)))
    (let ((d (+ 48 (- x (* q 10)))))
      (let ((t (rib d tail 0))) ;; cons
        (if (< 0 q)
            (number->string-aux q t)
            t)))))

(define (list->string lst) (rib lst (length lst) 3)) ;; string

(define (length lst)
  (if (eqv? lst '())
    0
    (+ 1 (length (field1 lst)))))
