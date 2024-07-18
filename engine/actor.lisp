(defclass BaseActor ()
  "Базовый актер"
  ((states
    :initform (make-hash-table)
    :accessor states)
   (cur-state
    :initarg :state
    :initform nil
    :accessor cur-state)))

(defmethod new-state ((self BaseActor) state script)
  "Добавить новое состояние state со сценарием script"
  (setf (gethash state (states self)) script))

(defun script-name (obj state)
  "Символ для кодирования класса и состояния"
  (intern (concatenate 'string (string (type-of obj)) (string state))))

(defmethod set-state ((self BaseActor) state)
  "Установить состояние"
  (let ((s (gethash state (states self))))
    (unless (and (null s) (equal state (cur-state self)))
      (script:stop-script (script-name self (cur-state self)))
      (setf (cur-state self) state)
      (script:start-script (script-name self state)))))

(defmacro actor (name &rest forms)
  `(progn (defclass ,name (BaseActor)
	    (states
	     :initform (
	  (labels ((process (form)
		     (case (car form)
		       (state (new-state))
	    (mapc #'process ,forms))))
