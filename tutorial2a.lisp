(in-package :opengl-tutorial)

(defparameter *tutorial2a-shader-source* 
"#version 330 core
layout(location = 0) in vec3 in_Position;
void main() {
  gl_Position = vec4(in_Position, 1.0);
}")

(defparameter *tutorial2a-fragment-source*
"#version 330 core
out vec3 out_Color;
void main() {
  out_Color = vec3(1, 0, 0);
}")

(defun tutorial2a ()
  (glop:with-window (win "tutorial 2a" 500 500 :major 3 :minor 3)
    (let* ((vertex-array (gl:gen-vertex-array))
	   (buffers (gl:gen-buffers 1))
	   (vertex-buffer (elt buffers 0))
	   (program (link-program *tutorial2a-shader-source* *tutorial2a-fragment-source*)))
      (gl:bind-vertex-array vertex-array)
      (gl:bind-buffer :array-buffer vertex-buffer)
      (load-buffer-array #(-1.0 -1.0 0.0
			   1.0 -1.0 0.0
			   0.0 1.0 0.0))
      (gl:clear-color 0 0 0.4 0)
      (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	   (gl:clear :color-buffer-bit)
	   (gl:use-program program)
	   (enable-vertex-array 0 vertex-buffer)
	   (gl:draw-arrays :triangles 0 3)
	   (gl:disable-vertex-attrib-array 0)
	   (glop:swap-buffers win))
      (gl:delete-buffers buffers)
      (gl:delete-program program)
      (gl:delete-vertex-arrays `(,vertex-array)))))

