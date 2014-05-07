;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-43
  (:use)
  (:export :make-vector :vector :vector-unfold :vector-unfold-right :vector-copy
           :vector-reverse-copy :vector-append :vector-concatenate :vector?
           :vector-empty? :vector= :vector-ref :vector-length :vector-fold
           :vector-fold-right :vector-map :vector-map! :vector-for-each
           :vector-count
           :vector-index :vector-index-right :vector-skip :vector-skip-right
           :vector-binary-search :vector-any :vector-every :vector-set!
           :vector-swap!
           :vector-fill! :vector-reverse! :vector-copy! :vector-reverse-copy!
           :vector->list :reverse-vector->list :list->vector :reverse-list->vector
           ))

(defpackage :srfi-43.internal
  (:use :srfi-43 :cl :mbe :fiveam :srfi-8)
  (:shadowing-import-from :srfi-5 :let)
  (:shadowing-import-from :srfi-23 :error)
  (:shadow :lambda
           :check-type
           :loop
           :vector)
  (:shadow :test))

;;; eof
