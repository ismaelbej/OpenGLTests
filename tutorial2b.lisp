(in-package :opengl-tutorial)

(defparameter *tutorial2b-shader-source* 
"#version 330 core
layout(location = 0) in vec3 in_Position;
layout(location = 1) in vec3 in_Color;
out vec4 ex_Color;
void main() {
  gl_Position = vec4(in_Position, 1.0);
  ex_Color = vec4(in_Color, 1.0);
}")

(defparameter *tutorial2b-fragment-source*
"#version 330 core
in vec4 ex_Color;
out vec4 out_Color;
void main() {
  out_Color = ex_Color;
}")

(defun tutorial2b ()
  (glop:with-window (win "tutorial 2b" 500 500 :major 3 :minor 3)
    (let* ((vertex-array (gl:gen-vertex-array))
	   (buffers (gl:gen-buffers 2))
	   (vertex-buffer (elt buffers 0))
	   (color-buffer (elt buffers 1))
	   (program (link-program *tutorial2b-shader-source* *tutorial2b-fragment-source*)))
      (gl:bind-vertex-array vertex-array)
      (gl:bind-buffer :array-buffer vertex-buffer)
      (load-buffer-array #(-1.0 -1.0 0.0
			   1.0 -1.0 0.0
			   0.0 1.0 0.0))
      (gl:bind-buffer :array-buffer color-buffer)
      (load-buffer-array #(1.0 0.0 0.0
			   0.0 1.0 0.0
			   0.0 0.0 1.0))
      (gl:clear-color 0 0 0.4 0)
      (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	   (gl:clear :color-buffer-bit)
	   (gl:use-program program)
	   (enable-vertex-array 0 vertex-buffer)
	   (enable-vertex-array 1 color-buffer)
	   (gl:draw-arrays :triangles 0 3)
	   (gl:disable-vertex-attrib-array 0)
	   (gl:disable-vertex-attrib-array 1)
	   (glop:swap-buffers win)))))

