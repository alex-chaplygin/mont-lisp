(load "~/quicklisp/setup.lisp")
(ql:quickload :cffi)
(load "video.lisp")
(load "tiles.lisp")

(defvar *screen* (make-array 1000 :element-type '(unsigned-byte 8)))
(defvar q)

(defun main ()
  (video:video-init 2)
  (setf q 1)
  (loop while (= q 1)
	do (setf q (video:video-get-events))
	   (sb-sys:with-pinned-objects (*screen* *tiles*)
	     (video:video-update (sb-sys:vector-sap *screen*) 40 25
				 (sb-sys:vector-sap *tiles*))))
  (video:video-close))

(main)

(dotimes (i 127)
  (setf (aref *screen* i) 1))

(video:close-lib)
