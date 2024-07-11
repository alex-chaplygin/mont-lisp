(load "~/quicklisp/setup.lisp")
(ql:quickload :cffi)
(load "video.lisp")

(defvar q)

(defun main ()
  (video:video-init 2)
  (setf q 1)
  (loop while (= q 1)
	do (setf q (video:video-get-events))
	   (video:render-screen))
  (video:video-close))

(main)

(video:close-lib)
