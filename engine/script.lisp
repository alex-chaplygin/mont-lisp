(ql:quickload "bordeaux-threads")

(defpackage :script
  (:use :cl)
  (:export :start-script :stop-script :is-running :*threads-running*))

(in-package :script)

(defvar *threads-running* (make-hash-table)) ; таблица состояний запуска потоков

(defmacro start-script (tag script)
  "Запуск сценария"
  `(progn (setf (gethash ,tag *threads-running*) 1)
	  (bt:make-thread ,script)))

(defmacro is-running (tag)
  `(= (gethash ',tag *threads-running*) 1))

(defmacro stop-script (tag)
  "Остановка сценария"
  `(setf (gethash ,tag *threads-running*) 0))
