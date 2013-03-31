(in-package :opengl-tutorial)

(defmethod glop:on-event (window event)
  )

(defmethod glop:on-event (window (event glop:key-event))
  (when (eq (glop:keysym event) :escape)
    (glop:push-close-event window)))

(defmethod glop:on-event (window (event glop:resize-event))
  (gl:viewport 0 0 (glop:width event) (glop:height event)))

