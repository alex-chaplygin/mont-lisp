(defpackage :video
  (:use :cl)
  (:export :video-init :video-get-events :render-screen :video-close :get-key :init-lib :close-lib :run :*screen* :*tiles* :*colors* :*back-color* :*back-multi-color* :*back-multi-color2* :*sprites* :*sprites-data* :*sprite-color1* :*sprite-color2* :*sprites-collisions* :make-sprite))

(in-package :video)

(defconstant +screen-width+ 40) ; число плиток по горизонтали
(defconstant +screen-height+ 25) ; число плиток по вертикали
(defconstant +video-width+ 320) ; ширина экрана в пикселях
(defconstant +video-height+ 200) ; высота экрана в пикселях
(defconstant +num-sprites+ 8)  ; максимальное число спрайтов
(defconstant +sprite-data-size+ 64) ; размер данных спрайта в байтах
(defconstant +sprite-width+ 24) ; ширина спрайтов
(defconstant +sprite-height+ 21) ; высота спрайтов
; структура спрайта: координаты, номер изображение, цвет, режим мультицвета, проверка столкновений
(defstruct sprite x y num color multi collision) 

(defvar *screen* (make-array (* +screen-width+ +screen-height+) ; массив плиток
			     :element-type '(unsigned-byte 8)))
(defvar *colors* (make-array (* +screen-width+ +screen-height+) ; цвета плиток
			     :element-type '(unsigned-byte 8)))
(defvar *tiles* (make-array 2000 :element-type '(unsigned-byte 8))) ; данные плиток
(defvar *video* (make-array (* +video-width+ +video-height+) ; массив экрана
			    :element-type '(unsigned-byte 8)))
(defvar *sprites* (make-array +num-sprites+ :initial-element nil)) ; массив спрайтов
(defvar *sprites-collisions* (make-array +num-sprites+ :initial-element nil)) ; логический массив столкновений спрайтов
(defvar *sprites-data* (make-array (* 256 +sprite-data-size+) ; данные спрайтов
			    :element-type '(unsigned-byte 8)))
(defparameter *back-color* 0) ; цвет фона
(defparameter *back-multi-color* 1) ; цвет фона 2
(defparameter *back-multi-color2* 2) ; цвет фона 3
(defparameter *sprite-color1* 1) ; цвет спрайта 2
(defparameter *sprite-color2* 2) ; цвет спрайта 3


(defun init-lib ()
  (cffi:define-foreign-library video
    (t (:default "./video")))
  (cffi:use-foreign-library video)
  (cffi:defcfun "video_init" :void (scale :int))
  (cffi:defcfun "get_key" :int (key :int))
  (cffi:defcfun "video_get_events" :int)
  (cffi:defcfun "video_update" :void (buf :pointer))
  (cffi:defcfun "video_close" :void))

(defun close-lib ()
  (cffi:close-foreign-library 'video))

(defun pixel-color (x y)
  "Вычисление цвета точки фона"
  (let* ((screen-x (ash x -3));номер ячейки по горизонтали 0 .. 39
	 (screen-y (ash y -3));номер ячейки по вертикали 0 .. 24
	 (tile-x (logand x 7));координаты внутри плитки 0 .. 7
	 (tile-y (logand y 7))
	 ; номер плитки из экрана
	 (tile-num (aref *screen* (+ screen-x (* screen-y +screen-width+))))
	 ; строка из 4-х пикселей
	 (row (aref *tiles* (+ tile-y (ash tile-num 3))))
	 (color (aref *colors* (+ screen-x (* screen-y +screen-width+)))))
    (if (< color 8) ; одиночный цвет или мульти-цвет
	(case (logand (ash row (- tile-x 7)) 1)
	  (0 *back-color*)
	  (1 color))
	; координата x от 0 .. 3, умноженная на 2: 0, 2, 4, 6; -6: -6 -4 -2 0, >>, & 3
	(case (logand (ash row (- (ash (ash tile-x -1) 1) 6)) 3)
	  (0 *back-color*)
	  (1 *back-multi-color*)
	  (2 *back-multi-color2*)
	  (3 (logand color 7))))))
            
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

(defun sprite-pixel-color (id s x y xx yy)
  "Вычисление цвета точки спрайта s, рассчет столкновения с другими спрайтами"
  (let* ((pos (+ (ash (sprite-num s) 6) y y y (ash x -3))) ; позиция начала строки спрайта
	 (b (aref *sprites-data* pos))
	 (c (if (sprite-multi s)
		(case (logand (ash b (- (ash (ash (logand x 7) -1) 1) 6)) 3)
		  (0 nil)
		  (1 *sprite-color1*)
		  (3 *sprite-color2*)
		  (2 (sprite-color s)))
		(case (logand (ash b (- (logand x 7) 7)) 1)
		  (0 nil)
		  (1 (sprite-color s))))))
    (when (and (sprite-collision s) (not (null c)))
      (block collision
	(setf (aref *sprites-collisions* id) nil)
	(dotimes (i +num-sprites+)
	  (when (and (/= i id) (not (null (aref *sprites* i))))
	    (let* ((s2 (aref *sprites* i))
		   (x2 (sprite-x s2))
		   (y2 (sprite-y s2)))
	      (when (and (>= xx x2) (<= xx (+ x2 +sprite-width+)) (>= yy y2)
			 (<= yy (+ y2 +sprite-height+)))
		(unless (null (sprite-pixel-color i s2 (- xx x2) (- yy y2) xx yy))
		  (setf (aref *sprites-collisions* id) t)
		  (return-from collision c))))))))
    c))


(defun render-sprites ()
  "Отрисовка спрайтов"
  (dotimes (i +num-sprites+)
    (let ((s (aref *sprites* (- (- +num-sprites+ 1) i))))
      (unless (null s)
	(let ((x (sprite-x s))
	      (y (sprite-y s)))
	  (when (and (< x +video-width+) (> (+ x +sprite-width+) 0)
		     (< y +video-height+) (> (+ y +sprite-height+) 0))
	    (let* ((xx (if (< x 0) 0 x))
		   (yy (if (< y 0) 0 y))
		   (cols (if (> (+ x +sprite-width+) +video-width+)
			     (- +video-width+ x) +sprite-width+))
		   (rows (if (> (+ y +sprite-height+) +video-height+)
				 (- +video-height+ y) +sprite-height+))
		   (pos (+ xx (* yy +video-width+)))
		   (cx (if (>= x 0) 0 (- 0 x)))
		   (cy (if (>= y 0) 0 (- 0 y))))
	      (loop (let ((c (sprite-pixel-color i s cx cy xx yy)))
		      (unless (null c) (setf (aref *video* pos) c)))
		    (incf cx)
		    (incf xx)
		    (incf pos)
		    (when (= cx cols)
		      (setf cx (if (>= x 0) 0 (- 0 x)))
		      (decf xx cols)
		      (incf cy)
		      (incf yy)
		      (incf pos (- +video-width+ (- cols cx))))
		    (when (= cy rows) (return nil))))))))))
	      
(defun render-screen ()
  "Отрисовка экрана"
  (render-tiles)
  (render-sprites)
  (sb-sys:with-pinned-objects (*video*)
    (video-update (sb-sys:vector-sap *video*))))

(defun run (scale)
  "Главный цикл графики"
  (video:video-init scale)
  (let ((q 1))
    (loop while (= q 1)
	  do (setf q (video:video-get-events))
	     (video:render-screen)))
  (video:video-close))

(init-lib)
