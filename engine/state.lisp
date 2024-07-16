(ql:quickload "bordeaux-threads")

(defpackage :state
  (:use :cl)
  (:export :state :activate :destroy))

(in-package :state)

(defvar *states* (make-hash-table)) ; таблица состояний
(defvar *threads-running* (make-hash-table)) ; таблица состояний запуска потоков
(defvar *current-thread* nil) ; текущий поток состояний
(defvar *current-state* nil) ; текущее состояние

(defmacro state (name init script)
  "Создать новое состояние, init - сценарий инициализации, script - сценарий состояния"
  `(progn
  (setf (gethash ',name *states*)
	 (cons (lambda () ,@init)
	       (lambda () (loop while
				(= (gethash ',name *threads-running*) 1) do
				,@script))))
  (setf (gethash ',name *threads-running*) 0)))

;(maphash (lambda (k v) (format t "~@<~S~20T~3I~_~S~:>~%" k v)) *threads-running*)
;(maphash (lambda (k v) (format t "~@<~S~20T~3I~_~S~:>~%" k v)) *states*)

(defun activate (name)
  "Установить новое состояние"
  (let ((s (gethash name *states*))) 
    (unless (and s (equal name *current-state*))
      (let ((init (car s))
	    (script (cdr s)))
	(setf (gethash *current-state* *threads-running*) 0)
	(funcall init)
	(setf *current-state* name)
	(setf (gethash *current-state* *threads-running*) 1)
	(setf *current-thread* (bt:make-thread script))))))

(defun destroy ()
  "Завершить поток состояния"
  (unless (null *current-thread*)
    (setf (gethash *current-state* *threads-running*) 0)
    (setf *current-thread* nil)
    (setf *current-state* nil)))
