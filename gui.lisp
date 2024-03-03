(defconstant +top+ #(5 3 3 3 3 3 3 3 3 3 3 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 3 3 3 3 3 3 3 3 3 3 3 3 5
		     5 0 0 0 0 0 0 0 0 0 0 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 0 0 0 0 0 0 0 0 #x46 #x47 #x46 #x47 5
		     5 0 0 0 0 0 0 0 0 0 0 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 0 0 0 0 0 0 0 0 #x48 #x49 #x48 #x49 5
		     5 4 4 4 4 4 4 4 4 4 4 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 4 4 4 4 4 4 4 4 4 4 4 4 5
		     1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2))

(defconstant +objects-items-digits+ #(0 1 0 2 #x2A #x2B 2 #x28 #x29 1 #x0D 1 6 1; 0
				      #x0E 1 #x71 #x74 #x73 #x72 #x77 #x76 #x75 1 #x70 1; 14 ; по 4 тайла (2х2) - цифры предметы
				      #x70 2 2 1 4 #x78 #x79 #x7A #x7B 5 #x34 #x35 #x35; 26
				      #x34 #x35 1 2 #x31 #x30 #x33 #x32 #x2D #x2C #x2F #x2E; 39, c 43 - предметы
				      #xAA #xA9 #xAC #xAB #x25 #x24 #x27 #x26 #xA2 #xA1; 51
				      #xA4 #xA3 #x7D #x7C #x6F #x6E #x3B #x3A #x3D #x3C; 61
				      #x3F #x3E #x41 #x40 #x43 #x42 #x45 #x44 #x0F #x12 #x11; 71
				      #x10 #x15 #x14 #x13 #x16 #x19 #x18 #x17 #x1C #x1B #x1A; 82
				      #x1D #x20 #x1F #x1E #x23 #x22 #x21 7 8 #x0A 9 #x0C; 93
				      #x0B #xDC #x3B #xD2 #x3B #xB2 #x3B #xC2 #x3B #xD4; 105
				      #x3B #xD8 #x3B 2 #x38 #x39 #x47 #x46 #x49 #x48 #x4B; 115
				      #x4A #x4D #x4C #x4F #x4E #x51 #x50 #x53 #x52 #x55 #x54; 126
				      #x57 #x56 #x59 #x58 #x5B #x5A #x5D #x5C #x5F #x5E #x61; 137
				      #x60 #x63 #x62 #x65 #x64 #x67 #x66 #x69 #x68 #x6B #x6A; 148
				      #x6D #x6C))
(defconstant +digits-data-offsets+ #(#x79 #x7D #x81 #x85 #x89 #x8D #x91 #x95 #x99 #x9D)) ; смещения где хранятся цифры по 4 тайла

(defclass Score (GuiElement) ; очки
  ((score :initarg :score)))


(defun draw-item (x y offset)
  "Нарисовать объект по смещению offset из массива смещений"
    (draw-tile-2x2 x y (subseq +objects-items-digits+ offset (+ offset 4))))
  
(defun draw-digit (x y digit)
  "Нарисовать цифру digit в позиции x y"
    (draw-item x y (aref +digits-data-offsets+ digit)))

(defmethod render ((s Score))
  (let ((x (slot-value s 'x))
	(y (slot-value s 'y))
	(score (slot-value s 'score)))
    (dotimes (i 4)
      (let ((digit (rem score 10)))
	(draw-digit x y digit))
      (decf x 2)
      (setf score (floor score 10)))))

(defun make-score (x y)
  (let ((el (make-instance 'Score :x x :y y :score 0)))
    (setf *gui* (cons el *gui*))
    el))

(tile-map 0 0 +top+ 40 5)
(tile-map 10 10 #(1 1 1 2 2 3) 3 2)

(tile-map 20 15 #(1 1 1 1 1 1 1 1 1) 3 3)
(make-score 33 2)

(make-score 33 10)

(draw-tile-2x2 0 10 #(#x31 #x30 #x33 #x32)) ; слиток
(draw-tile-2x2 2 10 #(#x2D #x2C #x2F #x2E)) ; молоток
(draw-tile-2x2 4 10 #(#x25 #x24 #x27 #x26)) ; меч
(draw-tile-2x2 6 10 #(#x3F #x3E #x41 #x40)) ; красный ключ
(draw-tile-2x2 8 10 #(#x3B #x3A #x3D #x3C)) ; зеленый ключ
(draw-tile-2x2 0 12 #(#x43 #x42 #x45 #x44)) ; коричневый ключ
(draw-tile-2x2 2 12 #(#xD2 #x9 #x27 #x26))
;tile_offset = 0Ah  tile_num = xD (веревка)
;item_level  =  1
;fill_rect =  17h
;room_tile = 0Ah
;seg000:3474                 db  26h ; &
;seg000:3475                 db  17h
;seg000:3476                 db  82h ; В
