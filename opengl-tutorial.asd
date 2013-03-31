;;;; opengl-tutorial.asd

(asdf:defsystem #:opengl-tutorial
  :serial t
  :description "Tutorial de OpenGL"
  :version "0.0.1"
  :author "Ismael Bejarano <ismaelbej@gmail.com>"
  :licence "MIT"
  :depends-on (#:cl-opengl
	       #:glop)
  :components ((:file "package")
	       (:file "math-helper")
	       (:file "opengl-helper")
	       (:file "glop-helper")
               (:file "tutorial1")
	       (:file "tutorial2a")
	       (:file "tutorial2b")
	       (:file "tutorial3")
	       (:file "tutorial4")))
