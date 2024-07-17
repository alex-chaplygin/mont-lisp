(defvar *level-color* 8)

(defmacro pos-xy (x y)
  "Позиция плитки на экране"
  `(+ ,x (* ,y video:+screen-width+)))

(defmacro set-tile (x y tile color)
  "Установка одиночного тайла"
  `(let ((pos (pos-xy ,x ,y)))
     (setf (aref video:*screen* pos) ,tile)
     (setf (aref video:*colors* pos) ,color)))

(defmacro hline (x y w tile color)
  "Заполнение горизонтальной линии"
  `(let ((pos (pos-xy ,x ,y)))
     (dotimes (i ,w)
       (setf (aref video:*screen* pos) ,tile)
       (setf (aref video:*colors* pos) ,color)
       (incf pos))))

(defmacro hline2 (x y w tile tile2 color)
  "Заполнение горизонтальной линии из чередующихся плиток"
  `(let ((pos (pos-xy ,x ,y)))
     (dotimes (i (ash ,w -1))
       (setf (aref video:*screen* pos) ,tile)
       (setf (aref video:*colors* pos) ,color)
       (incf pos)
       (setf (aref video:*screen* pos) ,tile2)
       (setf (aref video:*colors* pos) ,color)
       (incf pos))))

(defmacro vline (x y h tile color)
  "Заполнение вертикальной линии"
  `(let ((pos (pos-xy ,x ,y)))
     (dotimes (i ,h)
       (setf (aref video:*screen* pos) ,tile)
       (setf (aref video:*colors* pos) ,color)
       (incf pos video:+screen-width+))))

(defmacro fill-rect (x y w h tile color)
  "Заливка экрана постоянной плиткой"
  `(dotimes (yy ,h)
     (hline ,x (+ ,y yy) ,w ,tile ,color)))

(defmacro all-bricks ()
  "Все кирпичи"
  `(fill-rect 0 0 video:+screen-width+ video:+screen-height+ #x1b *level-color*))

(defmacro bricks (x y w h)
  "Кирпичи"
  `(fill-rect ,x ,y ,w ,h #x1b *level-color*))

(defmacro empty (x y w h)
  "Пустота"
  `(fill-rect ,x ,y ,w ,h #x1a 0))

(defmacro column (x y h)
  "Колонна"
  `(vline ,x ,y ,h #x3a 3))

(defmacro rope (x y h)
  "Веревка"
  `(progn (set-tile ,(- x 1) ,y #x1c 8)
	  (set-tile ,(+ x 1) ,y #x1c 8)
	  (set-tile ,x ,y #x22 3)
	  (vline ,x ,(+ y 1) ,(- h 1) #x39 3)))

(defmacro quad (x y start color)
  "Объект 2 на 2"
  `(progn (set-tile ,x ,y ,start ,color)
	  (set-tile (+ ,x 1) ,y (+ ,start 1) ,color)
	  (set-tile ,x (+ ,y 1) (+ ,start 2) ,color)
	  (set-tile (+ ,x 1) (+ ,y 1) (+ ,start 3) ,color)))

(defmacro title (x y start count color)
  `(dotimes (i ,count)
     (quad (+ ,x (ash i 1)) ,y (+ ,start (ash i 2)) ,color)))

(defmacro std-room ()
  "Типовая комната с коридором"
  `(progn (all-bricks)
	  (empty 0 4 video:+screen-width+ 6)
	  (hline2 0 4 video:+screen-width+ #x1b #x1c *level-color*)))
	  
(defun room-1-1 ()
  (all-bricks)
  (hline2 2 4 38 #x1b #x1c *level-color*)
  (empty 0 5 video:+screen-width+ 10)
  (title 11 8 #x60 7 8)(quad 25 8 #x60 8)(quad 27 8 #x7c 8)
  (column 1 0 23)
  (column 38 0 23)
  (empty 2 15 36 8)
  (bricks 5 22 30 1)
  (bricks 12 20 17 2) 
  (bricks 14 18 13 2)
  (empty 19 19 3 6)
  (rope 20 18 7)
  )

(room-1-1)
(std-room)
