(require 'cl-opengl) 
(require 'glop)

(defparameter *shader-source* 
"#version 330 core
layout(location = 0) in vec3 in_Position;
void main() {
  gl_Position.xyz = in_Position;
  gl_Position.w = 1.0;
}")

(defparameter *fragment-source*
"#version 330 core
out vec3 out_Color;
void main() {
  out_Color = vec3(1, 0, 0);
}")

(defmethod glop:on-event (window event)
  )

(defmethod glop:on-event (window (event glop:key-event))
  (when (eq (glop:keysym event) :escape)
    (glop:push-close-event window)))

(defun link-program (shader-source fragment-source)
  (let ((vs (gl:create-shader :vertex-shader))
	(fs (gl:create-shader :fragment-shader))
	(pg (gl:create-program)))
    (gl:shader-source vs shader-source)
    (gl:compile-shader vs)
    ;;(print (gl:get-shader-info-log vs))
    (gl:shader-source fs fragment-source)
    (gl:compile-shader fs)
    ;;(print (gl:get-shader-info-log fs))
    (gl:attach-shader pg vs)
    (gl:attach-shader pg fs)
    (gl:link-program pg)
    ;;(print (gl:get-program-info-log pg))
    pg))

(defun load-buffer-array (array)
  (let* ((len (length array))
	 (arr (gl:alloc-gl-array :float len)))
    (dotimes (i len)
      (setf (gl:glaref arr i) (aref array i)))
    (gl:buffer-data :array-buffer :static-draw arr)
    (gl:free-gl-array arr)))
 
(defun enable-vertex-array (index buffer)
  (gl:enable-vertex-attrib-array index)
  (gl:bind-buffer :array-buffer buffer)
  (gl:vertex-attrib-pointer index 3 :float nil 0 (cffi:null-pointer)))

(defun tutorial2a ()
  (glop:with-window (win "tutorial 2a" 500 500 :major 3 :minor 3)
    (let* ((vertex-array (gl:gen-vertex-array))
	   (buffers (gl:gen-buffers 2))
	   (vertex-buffer (elt buffers 0))
	   (program (link-program *shader-source* *fragment-source*)))
      (gl:bind-vertex-array vertex-array)
      (gl:bind-buffer :array-buffer vertex-buffer)
      (load-buffer-array #(-1.0 -1.0 0.0
		   1.0 -1.0 0.0
		   0.0 1.0 0.0))
      (gl:clear-color 0 0 0.4 0)
      (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	   (gl:clear :color-buffer-bit :depth-buffer-bit)
	   (gl:use-program program)
	   (enable-vertex-array 0 vertex-buffer)
	   (gl:draw-arrays :triangles 0 3)
	   (gl:disable-vertex-attrib-array 0)
	   (glop:swap-buffers win)))))

