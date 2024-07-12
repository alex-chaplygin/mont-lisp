(defpackage :video
  (:use :cl)
  (:export :video-init :video-get-events :render-screen :video-close :init-lib :close-lib :*screen* :*tiles* :*colors* :*back-color* :*back-multi-color* :*back-multi-color2*))

(in-package :video)

(defconstant +screen-width+ 40)
(defconstant +screen-height+ 25)
(defconstant +video-width+ 320)
(defconstant +video-height+ 200)
(defvar *screen* (make-array (* +screen-width+ +screen-height+)
			     :element-type '(unsigned-byte 8)))
(defvar *colors* (make-array (* +screen-width+ +screen-height+)
			     :element-type '(unsigned-byte 8)))
(defvar *tiles* (make-array 2000 :element-type '(unsigned-byte 8)))
(defvar *video* (make-array (* +video-width+ +video-height+)
			    :element-type '(unsigned-byte 8)))
(defparameter *back-color* 0) ; цвет фона
(defparameter *back-multi-color* 1) ; цвет фона 2
(defparameter *back-multi-color2* 2) ; цвет фона 3


(defun init-lib ()
  (cffi:define-foreign-library video
    (t (:default "./video")))
  (cffi:use-foreign-library video)
  (cffi:defcfun "video_init" :void (scale :int))
  (cffi:defcfun "video_get_events" :int)
  (cffi:defcfun "video_update" :void (buf :pointer))
  (cffi:defcfun "video_close" :void))

(defun close-lib ()
  (cffi:close-foreign-library 'video))

(defun pixel-color (x y)
  "Вычисление цвета точки"
  (let* ((screen-x (ash x -3));номер ячейки по горизонтали 0 .. 39
	 (screen-y (ash y -3));номер ячейки по вертикали 0 .. 24
	 (tile-x (logand x 7));координаты внутри плитки 0 .. 7
	 (tile-y (logand y 7))
	 ; номер плитки из экрана
	 (tile-num (aref *screen* (+ screen-x (* screen-y +screen-width+))))
	 ; строка из 4-х пикселей
	 (row (aref *tiles* (+ tile-y (ash tile-num 3)))))
    ; координата x от 0 .. 3, умноженная на 2: 0, 2, 4, 6; -6: -6 -4 -2 0, >>, & 3
    (case (logand (ash row (- (ash (ash tile-x -1) 1) 6)) 3)
      (0 *back-color*)
      (1 *back-multi-color*)
      (2 *back-multi-color2*)
      (3 (aref *colors* (+ screen-x (* screen-y +screen-width+)))))))
            

(defun render-tiles ()
  "Отрисовка фона"
  (let ((y 0)
	(x 0)
	(pos 0))
    (loop 
      (setf (aref *video* pos) (pixel-color x y))
      (incf x)
      (incf pos)
      (when (= x +video-width+)
	(setf x 0)
	(incf y))
      (when (= y +video-height+) (return nil)))))

(defun render-screen ()
  (render-tiles)
  (sb-sys:with-pinned-objects (*video*)
    (video-update (sb-sys:vector-sap *video*))))

(init-lib)
