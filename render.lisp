(defconstant +screen-width+ 40) ; ширина экрана в тайлах
(defconstant +screen-height+ 25) ; высота экрана в тайлах
(defvar *screen* (make-array 1000 :element-type '(unsigned-byte 8)))
(defvar *gui* nil)

(defclass GuiElement ()
  ((x :initarg :x)
   (y :initarg :y))) ; элемент экрана
(defclass TileMap (GuiElement)
  ((tiles :initarg :tiles)
   (width :initarg :width)
   (height :initarg :height))) ; карта тайлов

(defun draw-tile-2x2 (x y tiles)
  "Нарисовать объект 2х2 в координатах x y с тайлами (1,0)(0,0)(1,1)(0,1)"
  (let ((pos (+ x (* y +screen-width+))))
    (setf (aref *screen* (+ 1 pos)) (aref tiles 0))
    (setf (aref *screen* pos) (aref tiles 1))
    (setf (aref *screen* (+ 1 +screen-width+ pos)) (aref tiles 2))
    (setf (aref *screen* (+ +screen-width+ pos)) (aref tiles 3))))

(defun tile-map (x y tiles w h)
  (let ((el (make-instance 'TileMap :x x :y y :tiles tiles :width w :height h)))
    (setf *gui* (cons el *gui*))))

(defmethod render((tm TileMap))
  (let* ((w (slot-value tm 'width))
	 (pos (+ (slot-value tm 'x) (* +screen-width+ (slot-value tm 'y))))
	 (tiles (slot-value tm 'tiles)))
    (dotimes (y (slot-value tm 'height))
      (dotimes (x w)
	(let ((i (+ x (* y w))))
	  (setf (aref *screen* (+ pos i)) (aref tiles i)))))))

(defun render-update ()
  (apply #'(lambda (el) (render el)) *gui*))
  
