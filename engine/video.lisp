(defpackage :video
  (:use :cl)
  (:export :video-init :video-get-events :render-screen :video-close :init-lib :close-lib))

(in-package :video)

(defconstant +screen-width+ 40)
(defconstant +screen-height+ 25)
(defconstant +video-width+ 320)
(defconstant +video-height+ 200)
(defvar *screen* (make-array (* +screen-width+ +screen-height+)
				:element-type '(unsigned-byte 8)))
(defvar *video* (make-array (* +video-width+ +video-height+)
				:element-type '(unsigned-byte 8)))


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
  0)

(defun render-screen ()
  (dotimes (y +video-height+)
    (dotimes (x +video-width+)
      (setf (aref *video* (+ x (* y +video-width+))) (pixel-color x y))))
  (sb-sys:with-pinned-objects (*video*)
    (video-update (sb-sys:vector-sap *video*))))

(init-lib)
