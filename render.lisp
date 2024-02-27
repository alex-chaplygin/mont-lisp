(defconstant +screen-width+ 40) ; ширина экрана в тайлах
(defconstant +screen-height+ 25) ; высота экрана в тайлах
(defvar *screen* (make-array 1000 :element-type '(unsigned-byte 8)))

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

(dotimes (i 200)
  (setf (aref *screen* i) (aref +top+ i)))

(defun draw-tile-2x2 (x y tiles)
  "Нарисовать объект 2х2 в координатах x y с тайлами (1,0)(0,0)(1,1)(0,1)"
  (let ((pos (+ x (* y +screen-width+))))
    (setf (aref *screen* (+ 1 pos)) (aref tiles 0))
    (setf (aref *screen* pos) (aref tiles 1))
    (setf (aref *screen* (+ 1 +screen-width+ pos)) (aref tiles 2))
    (setf (aref *screen* (+ +screen-width+ pos)) (aref tiles 3))))

(defun draw-digit (x y digit)
  "Нарисовать цифру digit в позиции x y"
  (let ((start (aref +digits-data-offsets+ digit)))
    (draw-tile-2x2 x y (subseq +objects-items-digits+ start (+ start 4)))))

(draw-tile-2x2 10 6 (subseq *items-digits* 8 12))
(draw-digit 19 2 8)
