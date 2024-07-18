(actor player
       (state rstand (0)) ; стоит вправо
       (state lstand (26)) ; стоит влево
       (state rwalk (1 2)) ; идет вправо
       (state lwalk (27 28)) ; идет влево
       (state lad-stand (3)) ; стоит на лестнице
       (state lad-walk (4 37)) ; идет по лестнице
       (state rope (38)) ; по веревке
       (state fall (5 6)) ; упал с высоты
       (state down (7)) ; спуск по колонне
       (state rjump (8)) ; прыжок вправо
       (state ljump (39)) ; прыжок влево
       (state climb-up (9)) ; наклон после лестницы
       (state rdisapear (10 11 12)) ; исчезает после столкновения вправо
       (state ldisapear (29 30 31)) ; исчезает после столкновения влево
       (state smoke (13)) ; дым идет вверх
)

(setf (video:sprite-num *player*) 38)
	
