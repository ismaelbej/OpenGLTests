(in-package :opengl-tutorial)

(defmacro d->r (deg)
  `(* 0.01745329252 ,deg))

(defun make-mat4x4 (&optional (val 0.0))
  (make-array '(4 4) :initial-contents
	      `((,val 0.0 0.0 0.0)
		(0.0 ,val 0.0 0.0)
		(0.0 0.0 ,val 0.0)
		(0.0 0.0 0.0 ,val))))

(defun make-vec3 (&optional (x 0.0) (y 0.0) (z 0.0))
  (make-array '(3) :initial-contents `(,x ,y ,z)))

(defun make-vec4 (&optional (x 0.0) (y 0.0) (z 0.0) (w 0.0))
  (make-array '(4) :initial-contents `(,x ,y ,z ,w)))

(defmacro vx (v)
  `(aref ,v 0))

(defmacro vy (v)
  `(aref ,v 1))

(defmacro vz (v)
  `(aref ,v 2))

(defmacro vw (v)
  `(aref ,v 3))

(defun dot (v u)
  (apply #'+ (map 'list #'* v u)))

(defun norm (v)
  (sqrt (dot v v)))

(defun normalize (v)
  (let ((n (norm v)))
    (map 'vector (lambda (x) (/ x n)) v)))

(defun cross (u v)
  (make-vec3 
   ( - (* (vy u) (vz v)) (* (vz u) (vy v)))
   ( - (* (vz u) (vx v)) (* (vx u) (vz v)))
   ( - (* (vx u) (vy v)) (* (vy u) (vx v)))))

(defun vdiff (u v)
  (make-vec3 (- (vx u) (vx v))
	     (- (vy u) (vy v))
	     (- (vz u) (vz v))))

(defun vadd (u v)
  (make-vec3 (+ (vx u) (vx v))
	     (+ (vy u) (vy v))
	     (+ (vz u) (vz v))))

(defun mprod (m1 m2)
  (let ((m (make-mat4x4)))
    (dotimes (i 4)
      (dotimes (j 4)
	(let ((sum 0.0))
	  (dotimes (k 4)
	    (incf sum (* (aref m1 k i) (aref m2 j k))))
	  (setf (aref m j i) sum))))
    m))

(defun translation (&optional (x 0.0) (y 0.0) (z 0.0))
  (let ((m (make-mat4x4 1.0)))
    (setf (aref m 3 0) x)
    (setf (aref m 3 1) y)
    (setf (aref m 3 2) z)
    m))

(defun perspective (fovy aspect znear zfar)
  (let* ((range (* (tan (d->r (/ fovy 2.0))) znear))
	 (left (* aspect (- range)))
	 (right (* aspect range))
	 (bottom (- range))
	 (top range)
	 (result (make-mat4x4 0.0)))
    (setf (aref result 0 0) (/ (* 2.0 znear) (- right left)))
    (setf (aref result 1 1) (/ (* 2.0 znear) (- top bottom)))
    (setf (aref result 2 2) (- (/ (+ zfar znear) (- zfar znear))))
    (setf (aref result 2 3) (- 1.0))
    (setf (aref result 3 2) (- (/ (* 2.0 zfar znear) (- zfar znear))))
    result))

(defun look-at (eye center up)
  (let* ((f (normalize (vdiff center eye)))
	 (u (normalize up))
	 (s (normalize (cross f u)))
	 (result (make-mat4x4 1.0)))
    (setf u (cross s f))
    (setf (aref result 0 0) (vx s))
    (setf (aref result 1 0) (vy s))
    (setf (aref result 2 0) (vz s))
    (setf (aref result 0 1) (vx u))
    (setf (aref result 1 1) (vy u))
    (setf (aref result 2 1) (vz u))
    (setf (aref result 0 2) (- (vx f)))
    (setf (aref result 1 2) (- (vy f)))
    (setf (aref result 2 2) (- (vz f)))
    (setf (aref result 3 0) (- (dot s eye)))
    (setf (aref result 3 1) (- (dot u eye)))
    (setf (aref result 3 2) (dot f eye))
    result))
   