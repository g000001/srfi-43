;;;; package.lisp

(cl:in-package :cl-user)


(defpackage "https://github.com/g000001/srfi-43"
  (:use)
  (:export
   make-vector vector vector-unfold vector-unfold-right vector-copy
   vector-reverse-copy vector-append vector-concatenate vector?
   vector-empty? vector= vector-ref vector-length vector-fold
   vector-fold-right vector-map vector-map! vector-for-each
   vector-count
   vector-index vector-index-right vector-skip vector-skip-right
   vector-binary-search vector-any vector-every vector-set!
   vector-swap!
   vector-fill! vector-reverse! vector-copy! vector-reverse-copy!
   vector->list reverse-vector->list list->vector reverse-list->vector))


(defpackage "https://github.com/g000001/srfi-43#internals"
  (:use
   "https://github.com/g000001/srfi-43"
   "https://github.com/g000001/srfi-8"
   cl 
   mbe 
   fiveam)
  (:shadowing-import-from 
   "https://github.com/g000001/srfi-5" let)
  (:shadowing-import-from
   "https://github.com/g000001/srfi-23" error)
  (:shadow 
   lambda
   check-type
   loop
   vector)
  (:shadow test))


;;; *EOF*

