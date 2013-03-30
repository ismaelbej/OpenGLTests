(in-package :opengl-tutorial)

(defparameter *tutorial3-shader-source* 
"#version 330 core
layout(location = 0) in vec3 in_Position;
uniform mat4 MVP;
void main() {
  vec4 v = vec4(in_Position, 1.0);
  gl_Position = MVP * v;
}")

(defparameter *tutorial3-fragment-source*
"#version 330 core
out vec3 out_Color;
void main() {
  out_Color = vec3(1, 0, 0);
}")

(defun tutorial3 ()
  (glop:with-window (win "tutorial 3" 500 500 :major 3 :minor 3)
    (let* ((vertex-array (gl:gen-vertex-array))
	   (buffers (gl:gen-buffers 2))
	   (vertex-buffer (elt buffers 0))
	   (program (link-program *tutorial3-shader-source* *tutorial3-fragment-source*))
	   (matrixId (gl:get-uniform-location program "MVP"))
	   (projection (perspective 45.0 (/ 4.0 3.0) 0.1 100.0))
	   (view (look-at #(4 3 3) #(0 0 0) #(0 1 0)))
	   (mat (mprod projection view)))
      (gl:bind-vertex-array vertex-array)
      (gl:bind-buffer :array-buffer vertex-buffer)
      (load-buffer-array #(-1.0 -1.0 0.0
			   1.0 -1.0 0.0
			   0.0 1.0 0.0))
      (gl:clear-color 0 0 0.4 0)
      (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	   (gl:clear :color-buffer-bit)
	   (gl:use-program program)
	   (gl:uniform-matrix matrixId 4 (vector mat) nil)
	   (enable-vertex-array 0 vertex-buffer)
	   (gl:draw-arrays :triangles 0 3)
	   (gl:disable-vertex-attrib-array 0)
	   (glop:swap-buffers win)))))

