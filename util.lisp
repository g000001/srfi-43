(cl:in-package "https://github.com/g000001/srfi-43#internals")


(defmacro define.inline.function (name (&rest args) &body body)
  `(progn
     (declaim (inline ,name))
     (defun ,name (,@args) ,@body)))


(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf (fdefinition 'eq?) #'eq)
  (setf (fdefinition 'integer?) #'integerp)
  (setf (fdefinition 'list?) #'listp)
  (setf (fdefinition 'negative?) #'minusp)
  (setf (fdefinition 'null?) #'null)
  (setf (fdefinition 'pair?) #'consp)
  (setf (fdefinition 'positive?) #'plusp)
  (setf (fdefinition 'zero?) #'zerop)
  (setf (fdefinition 'vector-ref) #'aref)
  (setf (fdefinition 'vector-length) #'length)
  (setf (fdefinition 'vector?) #'vectorp)
  (setf (fdefinition 'procedure?) #'functionp))


(define.inline.function list-tail (list k)
  (nthcdr k list))


(define.inline.function vector-set! (vec index val)
  (setf (aref vec index) val))


(defun to-proper-lambda-list (list)
  (typecase list
    (list (if (tailp () list)
              list
              (cl:let ((last (last list)))
                `(,@(butlast list)
                      ,(car last)
                    cl:&rest
                    ,(cdr last)))))
    (symbol `(cl:&rest ,list))))


(defmacro lambda (args &rest body)
  `(cl:lambda ,(to-proper-lambda-list args)
     ,@body))


(defmacro letrec ((&rest binds) &body body)
  `(let (,@(mapcar (cl:lambda (x)
                     `(,(car x) #'values))
             binds))
     (declare (optimize (space 3)))
     (labels (,@(remove nil
                  (mapcar (cl:lambda (x &aux (name (car x)))
                            `(,name
                               (&rest args)
                               (apply ,name args)))
                          binds)))
       (declare (optimize (debug 0) (space 3)))
       (psetq ,@(apply #'append binds))
       ,@body)))


(defmacro define-function (name-args &body body)
  (if (consp name-args)
      (destructuring-bind (name . args)
                          name-args
        `(defun ,name ,(to-proper-lambda-list args)
           ,@body))
      `(eval-when (:compile-toplevel :load-toplevel :execute)
         (setf (fdefinition ',name-args)
               ,(car body)))))


;;; *EOF*
