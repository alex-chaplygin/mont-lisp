(load "engine/script.lisp")

(defpackage :state
  (:use :cl)
  (:export :state :activate :destroy))

(in-package :state)

(defvar *states* (make-hash-table)) ; таблица состояний
(defvar *current-state* nil) ; текущее состояние
(defvar *current-thread* nil) ; текущий поток состояний

(defmacro state (name init script)
  "Создать новое состояние, init - сценарий инициализации, script - сценарий состояния"
  `(setf (gethash ',name *states*) (cons (lambda () ,@init)
	    (lambda () (loop while (script:is-running ,name) do ,@script)))))

(defun activate (name)
  "Установить новое состояние"
  (let ((s (gethash name *states*))) 
    (unless (and (null s) (equal name *current-state*))
      (let ((init (car s))
	    (script (cdr s)))
	(script:stop-script *current-state*)
	(funcall init)
	(setf *current-state* name)
	(setf *current-thread* (script:start-script name script))))))

(defun destroy ()
  "Завершить поток состояния"
  (unless (null *current-thread*)
    (script:stop-script *current-state*)
    (setf *current-thread* nil)
    (setf *current-state* nil)))
