#|
Copyright 2021- Freak32768

This file is part of Colour.

    Colour is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Colour is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Colour.  If not, see <https://www.gnu.org/licenses/>.

|#

(use gl)
(use gl.glut)
(use srfi-27)
(load "./libs/3d-object.scm")
(load "./libs/trifunc.scm")
(load "./libs/obj-utils.scm")
(load "./config.scm")

(define WINDOW-WIDTH 640)
(define WINDOW-HEIGHT 640)
(define FLOOR-SIZE 20)
(define FLOOR-COLOR #f32(0.5 0.5 0.5 1))
(define LIGHT0-POS #f32(5 3 5 1))
(define LIGHT-COLOR #f32(1 1 1 0))
(define RED #f32(1 0 0 1))
(define BLUE #f32(0 0 1 1))
(define GREEN #f32(0 1 0 1))
(define YELLOW #f32(1 1 0 1))
(define CRITICALS '( ( #f32(1 0 0 1) . #f32(0 1 0 1) )
                     ( #f32(0 1 0 1) . #f32(1 0 0 1) )
                     ( #f32(0 0 1 1) . #f32(1 1 0 1) )
                     ( #f32(1 1 0 1) . #f32(0 0 1 1) )
                     ))

(define *player* (make <sniper>
                   :x 0 :y 0 :z 0
                   :life 100
                   :life-max 100
                   :color GREEN
                   :obj-data (load-obj "./objects/player.obj")
                   :rifle-cooltime-max PLAYER-RIFLE-COOLTIME
                   ))
(define *structures* '())
(define *enemies* '())
(define *bullets* '())
(define *effects* '())
(define *keycode* #\null)
(define *destroyed-spawner* 0)

;;tentative code
(define (game-over)
  (display "Game over!!")
  (newline)
  (exit 0)
  )
(define (game-clear)
  (display "Game clear!!")
  (newline)
  (exit 0)
  )

;;game initialize
(random-source-randomize! default-random-source)
(map (lambda (color)
       (set! *structures*
             (spawn-obj (make <structure>
                          :x (- (random-integer 17) 8)
                          :y 0
                          :z (- (random-integer 17) 8)
                          :color color
                          :life 100
                          :hitbox-range 0.5
                          :obj-data (load-obj "./objects/enemy-spawner.obj"))
                        *structures*))
       ) '(#f32(1 0 0 1) #f32(0 1 0 1) #f32(0 0 1 1) #f32(1 1 0 1)) )

;;end tentative code
(define (display-main-scene)
  (when (< 3 *destroyed-spawner*) (game-clear))
  (gl-clear (logior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (gl-light GL_LIGHT0 GL_POSITION LIGHT0-POS)
  (display-canvas)
  (glut-swap-buffers)
  )

(define (display-canvas)
  (display-floor)
  (display-player!)
  (obj-for-each! *structures* display-spawner!)
  (obj-for-each! *enemies* display-enemy!)
  (obj-for-each! *bullets* display-bullet!)
  (obj-for-each! *effects* display-effect!)
  (display-camera)
  )

(define (display-camera)
  (gl-matrix-mode GL_MODELVIEW)
  (gl-load-identity)
  (glu-look-at
   (- (x-of *player*) (* (table-sin (r-of *player*)) 3))
   (+ (y-of *player*) (+ (y-of *player*) 1.25))
   (- (z-of *player*) (* (table-cos (r-of *player*)) 3))
   (x-of *player*) (+ (y-of *player*) 0.5) (z-of *player*)
   0 1 0)
  )

(define (display-floor)
  (gl-push-matrix)
  (gl-material GL_FRONT_AND_BACK GL_DIFFUSE FLOOR-COLOR)
  (gl-translate 0 0 0)
  (gl-begin GL_QUADS)
  (gl-vertex (/ (- FLOOR-SIZE) 2) 0 (/ (- FLOOR-SIZE) 2) )
  (gl-vertex (/ (- FLOOR-SIZE) 2) 0 (/ FLOOR-SIZE 2) )
  (gl-vertex (/ FLOOR-SIZE 2) 0 (/ FLOOR-SIZE 2) )
  (gl-vertex (/ FLOOR-SIZE 2) 0 (/ (- FLOOR-SIZE) 2) )
  (gl-end)
  (gl-pop-matrix)
  )

(define-method shoot-bullet! ((sniper <sniper>))
  (if (< (rifle-cooltime-of sniper) 0)
      (begin
        (set! *bullets* (spawn-obj (make <3d-obj>
                                     :x (x-of sniper)
                                     :y (+ (y-of sniper) 0.5)
                                     :z (z-of sniper)
                                     :r (r-of sniper)
                                     :visible #t
                                     :color (color-of sniper)
                                     :obj-data (load-obj "./objects/bullet.obj")
                                     ) *bullets*))
        (set! (rifle-cooltime-of sniper) (rifle-cooltime-max-of sniper))
        )
      (when (< -1 (rifle-cooltime-of sniper))
          (set! (rifle-cooltime-of sniper) (- (rifle-cooltime-of sniper) 1)) )
      )
  )

(define-method display-bullet! ((bullet <3d-obj>))
  (move-obj! bullet BULLET-SPEED)
  (when (out-of-map? bullet)
    (set! (visible-of bullet) #f))
  (when (visible-of bullet) (display-3d-obj: bullet))
  )


(define (display-player!)
  (when (< (life-of *player*) 0)
    (begin
      (set! (visible-of *player*) #f)
      (game-over)
      ))
  (cond
   ;;rotation
   ( (char=? *keycode* #\a)
     (set! (r-of *player*) (if (<= 360 (r-of *player*))
                               0
                               (+ (r-of *player*) PLAYER-ROTATION-SPEED)) ))
   ( (char=? *keycode* #\d)
     (set! (r-of *player*) (if (>= 0 (r-of *player*))
                               360
                               (- (r-of *player*) PLAYER-ROTATION-SPEED)) ))
   ;moving
   ( (char=? *keycode* #\w) (move-obj! *player* PLAYER-SPEED) )
   ( (char=? *keycode* #\s) (move-obj! *player* (/ PLAYER-SPEED -3)) )
   ;;shooting
   ( (char=? *keycode* #\b) (shoot-bullet! *player*) )
   ( (char=? *keycode* #\1)
     (set! (color-of *player*) RED) )
   ( (char=? *keycode* #\2)
     (set! (color-of *player*) BLUE) )
   ( (char=? *keycode* #\3)
     (set! (color-of *player*) GREEN) )
   ( (char=? *keycode* #\4)
     (set! (color-of *player*) YELLOW) )
   )
  ;;damage judgement
  (cond
   ( (collide-with-others? *player* (filter (lambda (x)
                                           (equal? (color-of x) RED))
                                         *enemies*))
     (give-damage! *player* RED)
     )
   ( (collide-with-others? *player* (filter (lambda (x)
                                           (equal? (color-of x) BLUE))
                                         *enemies*))
     (give-damage! *player* BLUE)
     )
   ( (collide-with-others? *player* (filter (lambda (x)
                                           (equal? (color-of x) GREEN))
                                         *enemies*))
     (give-damage! *player* GREEN)
     )
   ( (collide-with-others? *player* (filter (lambda (x)
                                           (equal? (color-of x) YELLOW))
                                         *enemies*))
     (give-damage! *player* YELLOW)
     )
   ( (collide-with-others? *player* *structures*)  )
   )
  (when (visible-of *player*)
    (display-3d-obj: *player*)
    (display-life-bar: *player*)
    )
  )

(define-method display-spawner! ((spawner <3d-obj>))
  (when (< (life-of spawner) 1)
    (begin
      (set! (visible-of spawner) #f)
      (set! *destroyed-spawner* (+ *destroyed-spawner* 1))
      (set! *effects*
            (spawn-obj
             (make <3d-obj>
               :x (x-of spawner)
               :y (y-of spawner)
               :z (z-of spawner)
               :color (color-of spawner)
               :obj-data (load-obj "./objects/enemy-spawner-destroyed.obj")
               ) *effects*))
      (set! *structures* (remove-invisible-obj *structures*))
    ))
  (cond
   ( (collide-with-others? spawner (filter (lambda (x)
                                           (equal? (color-of x) RED))
                                         *bullets*))
     (give-damage! spawner RED)
     )
   ( (collide-with-others? spawner (filter (lambda (x)
                                           (equal? (color-of x) BLUE))
                                         *bullets*))
     (give-damage! spawner BLUE)
     )
   ( (collide-with-others? spawner (filter (lambda (x)
                                           (equal? (color-of x) GREEN))
                                         *bullets*))
     (give-damage! spawner GREEN)
     )
   ( (collide-with-others? spawner (filter (lambda (x)
                                           (equal? (color-of x) YELLOW))
                                         *bullets*))
     (give-damage! spawner YELLOW)
     )
   )
  (when (= 1 (random-integer 1200))
    (set! *enemies*
          (spawn-obj (make <creature>
                       :x (+ (x-of spawner) 1)
                       :y 0
                       :z (+ (z-of spawner) 1)
                       :life 20
                       :life-max 20
                       :color (color-of spawner)
                       :obj-data (load-obj "./objects/enemy.obj")
                       ) *enemies*)
          )
    )
  (display-3d-obj: spawner)
  )

(define-method display-enemy! ((enemy <creature>))
  (when (or (collide-with-others? enemy *enemies*)
            (< (life-of enemy) 0) )
    (begin
      (set! (visible-of enemy) #f)
      (set! *effects*
            (spawn-obj (make <3d-obj>
                         :x (x-of enemy)
                         :y (y-of enemy)
                         :z (z-of enemy)
                         :r (r-of enemy)
                         :color (color-of enemy)
                         :obj-data (load-obj "./objects/enemy-dead.obj")
                         ) *effects*))
      (set! *enemies* (remove-invisible-obj *enemies*))
      )
    )
  (let ((facing
         (exact (floor (rad-to-deg
                        (atan (- (x-of *player*) (x-of enemy))
                              (- (z-of *player*) (z-of enemy)))
                 )))
         ))
    (set! (r-of enemy)
          (cond ( (< facing 0) (+ facing 360) )
                ( (> facing 360) (- facing 360) )
                ( else facing )
                ) )
    )
  (cond
   ( (collide-with-others? enemy (filter (lambda (x)
                                           (equal? (color-of x) RED))
                                         *bullets*))
     (give-damage! enemy RED)
     )
   ( (collide-with-others? enemy (filter (lambda (x)
                                           (equal? (color-of x) BLUE))
                                         *bullets*))
     (give-damage! enemy BLUE)
     )
   ( (collide-with-others? enemy (filter (lambda (x)
                                           (equal? (color-of x) GREEN))
                                         *bullets*))
     (give-damage! enemy GREEN)
     )
   ( (collide-with-others? enemy (filter (lambda (x)
                                           (equal? (color-of x) YELLOW))
                                         *bullets*))
     (give-damage! enemy YELLOW)
     )
   )
  (when (> (distance: *player* enemy) 0.2)
    (move-obj! enemy ENEMY-SPEED))
  (when (visible-of enemy)
    (display-3d-obj: enemy)
    (display-life-bar: enemy)
    )
  )

(define-method display-effect! ((effect <3d-obj>))
  (if (< 5 (y-of effect))
      (set! (visible-of effect) #f)
      (begin
        (set! (y-of effect) (+ (y-of effect) EFFECT-SPEED))
        (display-3d-obj: effect)
        )
      )
  )

(define (init)
  (gl-clear-color 0.7 0.7 1 1.0)
  (gl-enable GL_DEPTH_TEST)
  (gl-enable GL_LIGHTING)
  (gl-enable GL_LIGHT0)
  (gl-light GL_LIGHT0 GL_DIFFUSE LIGHT-COLOR)
  (gl-light GL_LIGHT0 GL_SPECULAR LIGHT-COLOR)
  (gl-light GL_LIGHT0 GL_CONSTANT_ATTENUATION 0.2)
  (gl-enable GL_CULL_FACE)
  (gl-cull-face GL_BACK)
  )

(define (keyboard key x y)
  (if (= key (char->integer #\ESCAPE))
         (exit 0)
         (set! *keycode* (integer->char key))
         ))

(define (key-up key x y)
  (set! *keycode* #\null))

(define (idle)
  (glut-post-redisplay))

(define (resize w h)
  (gl-viewport 0 0 w h)
  (gl-matrix-mode GL_PROJECTION)
  (gl-load-identity)
  (gl-translate 0 0 -0.01)
  (glu-perspective 30 (/ w h) 1 100)
  )

(define (main args)
  (glut-init args)
  (glut-init-window-size WINDOW-WIDTH WINDOW-HEIGHT)
  (glut-init-display-mode (logior GLUT_RGBA GLUT_DOUBLE GLUT_DEPTH))
  (glut-create-window "Colour")
  (glut-display-func display-main-scene)
  (glut-reshape-func resize)
  (glut-keyboard-func keyboard)
  (glut-keyboard-up-func key-up)
  (glut-idle-func idle)
  (init)
  (glut-main-loop)
  )
