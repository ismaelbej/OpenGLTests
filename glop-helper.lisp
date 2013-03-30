(in-package :opengl-tutorial)

(defmethod glop:on-event (window event)
  )

(defmethod glop:on-event (window (event glop:key-event))
  (when (eq (glop:keysym event) :escape)
    (glop:push-close-event window)))

