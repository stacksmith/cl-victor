(asdf:defsystem #:cl-victor
  :description "A vector for heterogenous data stored compactly using a sliding window algorithm"
  :author "StackSmith <fpgasm@apple2.x10.mx>"
  :license "BSD"
  :depends-on (#:alexandria
	       #-(or allegro ccl clisp sbcl) ;for systems with no Unicod
               #:trivial-utf-8
	       )
  :serial t
  :components (
               (:file "package")
	      ; (:file "utility")
	       (:file "victor")
             ))

