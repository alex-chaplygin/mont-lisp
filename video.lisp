(defpackage :video
  (:use :cl)
  (:export :video-init :video-update :video-close :init-lib :close-lib))

(in-package :video)

(defun init-lib ()
  (cffi:define-foreign-library video
    (t (:default "./video")))
  (cffi:use-foreign-library video)
  (cffi:defcfun "video_init" :void (scale :int))
  (cffi:defcfun "video_update" :void (map :pointer) (screen_width :int) (screen_height :int) (tiles_data :pointer))
  (cffi:defcfun "video_close" :void))

(defun close-lib ()
  (cffi:close-foreign-library 'video))

(init-lib)
