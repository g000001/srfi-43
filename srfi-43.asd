;;;; srfi-43.asd

(cl:in-package :asdf)

(defsystem :srfi-43
  :serial t
  :depends-on (:fiveam :mbe :srfi-5 :srfi-23 :srfi-8)
  :components ((:file "package")
               (:file "util")
               (:file "srfi-43")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-43))))
  (load-system :srfi-43)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-43.internal :srfi-43))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
