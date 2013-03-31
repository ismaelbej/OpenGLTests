(in-package :opengl-tutorial)

(defparameter *tutorial4-shader-source* 
"#version 330 core
layout(location = 0) in vec3 in_Position;
layout(location = 1) in vec3 in_Color;
uniform mat4 MVP;
out vec3 ex_Color;
void main() {
  gl_Position = MVP * vec4(in_Position, 1.0);
  ex_Color = in_Color;
}")

(defparameter *tutorial4-fragment-source*
"#version 330 core
in vec3 ex_Color;
out vec3 out_Color;
void main() {
  out_Color = ex_Color;
}")

(defun tutorial4 ()
  (glop:with-window (win "tutorial 4" 400 300 :major 3 :minor 3)
    (let* ((vertex-array (gl:gen-vertex-array))
	   (buffers (gl:gen-buffers 2))
	   (vertex-buffer (elt buffers 0))
	   (color-buffer (elt buffers 1))
	   (program (link-program *tutorial4-shader-source* *tutorial4-fragment-source*))
	   (matrixId (gl:get-uniform-location program "MVP"))
	   (projection (perspective 45.0 (/ 4.0 3.0) 0.1 100.0))
	   (camera (make-vec3 4 3 3))
	   (model (make-mat4 1.0))
	   (view (look-at camera #(0 0 0) #(0 1 0)))
	   MVP
	   (angle 0.0))
      (gl:bind-vertex-array vertex-array)
      (gl:bind-buffer :array-buffer vertex-buffer)
      (load-buffer-array #(0.0 0.0 1.0
			   0.0 1.0 0.0
			   -1.0 0.0 0.0

			   -1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 -1.0
			   
			   0.0 0.0 -1.0
			   0.0 1.0 0.0
			   1.0 0.0 0.0
			   
			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0


			   0.0 0.0 1.0
			   -1.0 0.0 0.0
			   0.0 -1.0 0.0

			   -1.0 0.0 0.0
			   0.0 0.0 -1.0
			   0.0 -1.0 0.0
			   
			   0.0 0.0 -1.0
			   1.0 0.0 0.0
			   0.0 -1.0 0.0
			   
			   1.0 0.0 0.0
			   0.0 0.0 1.0
			   0.0 -1.0 0.0
			   ))
      (gl:bind-buffer :array-buffer color-buffer)
      (load-buffer-array #(1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0


			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0

			   1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0
			   ))
      (gl:clear-color 0 0 0.4 0)
      (gl:enable :depth-test :cull-face)
      (gl:depth-func :less)
      (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	   (setf model (rotation 0 #(0 0 1)))
	   (setf view (look-at 
		       (mvprod (rotation angle #(0 1 0)) camera)
		       #(0 0 0) 
		       #(0 1 0)))
	   (setf MVP (mprod projection (mprod view model)))
	   (gl:clear :color-buffer-bit :depth-buffer-bit)
	   (gl:use-program program)
	   (gl:uniform-matrix matrixId 4 `#(,MVP) nil)
	   (enable-vertex-array 0 vertex-buffer)
	   (enable-vertex-array 1 color-buffer)
	   (gl:draw-arrays :triangles 0 24)
	   (gl:disable-vertex-attrib-array 0)
	   (gl:disable-vertex-attrib-array 1)
	   (glop:swap-buffers win)
	   (incf angle 2.0))
      (gl:delete-buffers `(,vertex-buffer ,color-buffer))
      (gl:delete-program program)
      (gl:delete-vertex-arrays `(,vertex-array)))))

