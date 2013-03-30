(in-package :opengl-tutorial) 

(defun tutorial1 ()
  (glop:with-window (win "tutorial 1" 500 500 :major 3 :minor 3)
    (gl:clear-color 0 0 0.4 0)
    (loop while (glop:dispatch-events win :blocking nil :on-foo nil) do
	 (gl:clear :color-buffer-bit)
	 (glop:swap-buffers win))))

