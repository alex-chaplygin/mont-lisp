(load "~/quicklisp/setup.lisp")
(ql:quickload :cffi)
(load "video.lisp")
(load "tiles.lisp")
(load "render.lisp")
(load "gui.lisp")

(defvar q)

(defun main ()
  (video:video-init 2)
  (setf q 1)
  (loop while (= q 1)
	do (setf q (video:video-get-events))
	   (render-update)
	   (sb-sys:with-pinned-objects (*screen* *tiles*)
	     (video:video-update (sb-sys:vector-sap *screen*) 40 25
				 (sb-sys:vector-sap *tiles*))))
  (video:video-close))

(main)

(video:close-lib)
