(in-package :cl-text-buffer)
;;
;; A universal array inserter.
;;
(defun vector-insert (vector index value &key (tostring nil) (adjustable nil))
  "insert an element into a vector at index"
  (let* ((len (length vector))
	 (new (if (adjustable-array-p vector)
		  (adjust-array vector (1+ len))
		  (replace
		   ;; if requested, convert to string.
		   (if tostring
		       (make-string (1+ len))
		       (make-array  (1+ len) :adjustable adjustable))
		   vector :end1 index))))
    ;; in any case, make room and insert new value.
    (replace new vector :start1 (1+ index) :start2 index)
    (setf (aref new index) value)
    new))

(defun vector-delete (vector index &key (tostring nil) (adjustable nil))
  (let* ((len (1- (length vector)))
	 (new (if (adjustable-array-p vector)
		  (adjust-array vector len)
		  (replace
		   ;; if requested, convert to string.
		   (if tostring
		       (make-string len)
		       (make-array  len :adjustable adjustable))
		   vector :end1 index))))
    (replace new vector :start1 index :start2 (1+ index))
    new))

(defmacro mvb (&rest rest)
  "synonym for multiple-value-bind"
  `(multiple-value-bind ,@rest))
