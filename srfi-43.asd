;;;; srfi-43.asd

(cl:in-package :asdf)


(defsystem :srfi-43
  :version "20200319"
  :description "SRFI 43 for CL: Vector library"
  :long-description "SRFI 43 for CL: Vector library
https://srfi.schemers.org/srfi-43"
  :author "Taylor Campbell"
  :maintainer "CHIBA Masaomi"
  :serial t
  :depends-on (:fiveam :mbe :srfi-5 :srfi-23 :srfi-8)
  :components ((:file "package")
               (:file "util")
               (:file "srfi-43")
               (:file "test")))


(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-43))))
  (let ((name "https://github.com/g000001/srfi-43")
        (nickname :srfi-43))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-43))))
  (let ((*package*
         (find-package
          "https://github.com/g000001/srfi-43#internals")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-43)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))


;;; *EOF*
