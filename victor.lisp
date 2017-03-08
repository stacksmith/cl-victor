(in-package :cl-victor)
;;
(defclass victor ()
  ((narrow :accessor narrow :initarg :narrow)
   (wide   :accessor wide   :initarg :wide)
   ))

(defmethod initialize-instance ((victor victor)
				&key initial-contents
				  (length (length initial-contents)))
  (with-slots (narrow wide) victor
    (setf narrow (make-array 16 :element-type '(unsigned-byte 8)
			     :adjustable t :fill-pointer 0)
	  wide   (make-array 4 :adjustable t :fill-pointer 0))
    ))

;;(declare (inline ascii))
(defun ascii (value)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (and (characterp value)
       (let ((code (char-code value)))
	 (and (< code 128)
	      code))))

(defun wr (victor value)
  (with-slots (narrow wide) victor
    (let ((ascii (ascii value)))
      (if ascii
	  (vector-push ascii narrow)
	  (let ((base (ash (fill-pointer narrow) -4)))
	    ;; if wide is behind, catch up
	    (format t "LOOKING FOR ~A~&" value)
	    (loop while (> base (fill-pointer wide)) do
		 (format t "FILLED ~A~&" (fill-pointer wide))
		 (vector-push-extend nil wide))
	    ;; attempt to find
	    (let ((index
		   (loop for isearch from base to (1- (fill-pointer wide))
		      for ix from 128 do
			(format t "~A ~A " (aref wide isearch) (equal value (aref wide isearch)))
		      if (equal value (aref wide isearch)) do
			(return ix)
			)))
	      (format t "~&I:~A BASE: ~A  SEARCH-TO ~A   FOUND: ~A ~&"
		      (fill-pointer narrow) base  (1- (fill-pointer wide)) index)
	      (unless index
		(setf index (- (fill-pointer wide)
			       base
			       -128))
	;;	(format t "WRITING WIDE ~A at ~A;~&" value (fill-pointer wide))
	;;	(format t "WRITING NARR ~A at ~A;~&" index (fill-pointer narrow))
		(vector-push-extend value wide))
	      (vector-push-extend index narrow)))))))
;; TODO: entries retire too soon.  Pretend that we start with 64 blanks and continue from there.  That is, make index (>>4 - 64), and encode at +64.


(defun test( victor data)
  (with-slots (narrow wide) victor
    (let ((length (length data)))
      (setf narrow (make-array length :element-type '(unsigned-byte 8)
			       :fill-pointer 0)
	    wide   (make-array (ash length -4) :adjustable t
			       :fill-pointer 64 :initial-element nil))
      (loop for c across data do
	   (wr victor c)))))


(defun decode (victor)
  (with-slots (narrow wide) victor
    (loop for item across narrow 
       for i from 0 do
	 (if (< item 128)
	     (princ (code-char item))
	     (princ (aref wide (+ (ash i -4) (- item 128))))))
    ))


;; test
(defparameter *t* (make-instance 'victor))
(test *t* "L'alphabet latin (ou alphabet romain) est un alphabet bicaméral comportant vingt-six lettres de base, principalement utilisé pour écrire les langues d’Europe de l'Ouest, d'Europe du Nord et d'Europe centrale, ainsi que les langues de nombreux pays qui ont été exposés à une forte influence européenne, notamment à travers la colonisation européenne des Amériques, de l'Afrique et de l'Océanie. C’est, en concurrence avec l’alphabet cyrillique et dans une bien moindre part l’alphabet grec, le système d'écriture par défaut dans le monde occidental. Les utilisateurs de l’alphabet latin représentent 39 % de la population mondiale, consomment 72 % de la production imprimée et écrite sur papier dans le monde, et profitent de 84 % de l’ensemble des connexions à l’Internet1. En raison de cette importance démographique, économique et culturelle des pays l’utilisant (notamment ceux de l’Europe et de l’Amérique du Nord), il est devenu une écriture internationale : on peut trouver des mots écrits en lettres latines dans les rues du Japon comme dans celles d’Égypte.")
