(cl:in-package :srfi-43.internal)

(def-suite srfi-43)

(in-suite srfi-43)

(defmacro λ (args &rest body)
  `(lambda ,args ,@body))

(defmacro dotests (&body body)
  (do ((*gensym-counter* 0)
       (tests (reverse body)
                         (cdddr tests) )
       (es '()
           (destructuring-bind (test => res &rest ignore)
                               tests
             (declare (ignore => ignore))
             (cons `(TEST ,(gensym)
                      (IS (EQUALP ,test ,res )))
                   es ))))
      ((endp tests)
       `(progn ,@es)) ))


(dotests
  ;; constructors
  (make-vector 5 3)
  => #(3 3 3 3 3)

  (vector 0 1 2 3 4)
  => #(0 1 2 3 4)

  (vector-unfold (λ (i x) i (values x (- x 1)))
                 10 0)
  => #(0 -1 -2 -3 -4 -5 -6 -7 -8 -9)

  (vector-unfold #'values 8)
  => #(0 1 2 3 4 5 6 7)

  (vector-copy '#(a b c d e f g h i))
  => #(a b c d e f g h i)

  (vector-copy '#(a b c d e f g h i) 6)
  => #(g h i)

  (vector-copy '#(a b c d e f g h i) 3 6)
  => #(d e f)

  (vector-copy '#(a b c d e f g h i) 6 12 'x)
  => #(g h i x x x)

  (vector-reverse-copy '#(5 4 3 2 1 0) 1 5)
  => #(1 2 3 4)

  (vector-append '#(x) '#(y))
  => #(x y)

  (vector-append '#(a) '#(b c d))
  => #(a b c d)

  (vector-append '#(a #(b)) '#(#(c)))
  => #(a #(b) #(c))

  (vector-concatenate '(#(a b) #(c d)))
  => #(a b c d)
  )


(dotests
  ;; Predicates
  (vector? '#(a b c))
  => t

  (vector? '(a b c))
  => nil

  (vector? t)
  => nil

  (vector? '#())
  => t

  (vector? '())
  => nil

  (vector-empty? '#(a))
  => nil

  (vector-empty? '#(()))
  => nil

  (vector-empty? '#(#()))
  => nil

  (vector-empty? '#())
  => t

  (vector= #'eq? '#(a b c d) '#(a b c d))
  => t

  (vector= #'eq? '#(a b c d) '#(a b d c))
  => nil

  (vector= #'= '#(1 2 3 4 5) '#(1 2 3 4))
  => nil

  (vector= #'= '#(1 2 3 4) '#(1 2 3 4))
  => t

  (vector= #'eq?)
  => t

  (vector= #'eq? '#(a))
  => t

  (vector= #'eq? (vector (vector 'a)) (vector (vector 'a)))
  => nil

  (vector= #'equalp (vector (vector 'a)) (vector (vector 'a)))
  => t
  )

(dotests
  ;; Selectors
  (vector-ref '#(a b c d) 2)
  =>  'C

  (vector-length '#(a b c))
  =>  3
  )

(dotests
  ;; Iteration
  (vector-fold-right (λ (index tail elt) index (cons elt tail))
                     '() '#(a b c d))
  =>  '(A B C D)

  (vector-map (λ (i x) i (* x x))
              (vector-unfold (λ (i x) i (values x (+ x 1))) 4 1))
  =>  #(1 4 9 16)

  (vector-map (λ (i x y) i (* x y))
              (vector-unfold (λ (i x) i (values x (+ x 1))) 5 1)
              (vector-unfold (λ (i x) i (values x (- x 1))) 5 5))
  =>  #(5 8 9 8 5)

  (let ((count 0))
    (vector-map (λ (ignored-index ignored-elt)
                    ignored-index ignored-elt
                    (setq count (+ count 1))
                    count)
                '#(a b)))
  =>  #(2 1)

  (vector-map (λ (i elt) (+ i elt)) '#(1 2 3 4))
  =>  #(1 3 5 7)

  (with-output-to-string (*standard-output*)
  (vector-for-each (λ (i x) i (princ x) (terpri))
                 '#("foo" "bar" "baz" "quux" "zot")))
  => "foo
bar
baz
quux
zot
"

  (vector-count (λ (i elt) i (evenp elt)) '#(3 1 4 1 5 9 2 5 6))
  =>  3

  (vector-count (λ (i x y) i (< x y)) '#(1 3 6 9) '#(2 4 6 8 10 12))
  =>  2
  )

(dotests
  ;; Searching
  (vector-index #'evenp '#(3 1 4 1 5 9))
  =>  2

  (vector-index #'< '#(3 1 4 1 5 9 2 5 6) '#(2 7 1 8 2))
  =>  1

  (vector-index #'= '#(3 1 4 1 5 9 2 5 6) '#(2 7 1 8 2))
  =>  NIL

  (vector-skip #'numberp '#(1 2 a b 3 4 c d))
  =>  2
  )

#|(dotests
  ;; Mutators
  )|#

;;; eof
