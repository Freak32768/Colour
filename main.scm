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
(load "./libs/3d-object.scm")
(load "./libs/trifunc.scm")

(define-class <rifle> ()
  ((bullet-color :init-value #f32(0 1 0 1)
                 :init-keyword :bullet-color
                 :accessor bullet-color-of)
   (cooltime :init-value 0
             :init-keyword :cooltime
             :accessor cooltime-of)))

;;define constant values
(define *window-width* 640)
(define *window-height* 640)
(define *floor-size* 20)
(define *floor-color* #f32(0.5 0.5 0.5 1))
(define *light0-pos* #f32(5 3 5 1))
(define *light1-pos* #f32(-5 2 -5 1))
(define *light-color* #f32(1 1 1 0))

(define *player* (make <3d-obj>
                   :x 0 :y 0 :z 0
                   :color #f32(0 1 0 1)
                   :obj-data (load-obj "./objects/player.obj")
                   ))
(define *player-rifle* (make <rifle>))
(define *enemies* '())
(define *bullets* '())
(define *keycode* #\null)

(define (spawn-obj new-obj obj-list)
  (if (< 10 (length obj-list))
      (cons new-obj (remove-invisible-obj obj-list))
      (cons new-obj obj-list)) )

(define (remove-invisible-obj obj-list)
  (remove (lambda (obj) (eq? (visible-of obj) #f)) obj-list) )

(set! *enemies* (spawn-obj (make <3d-obj> :x 5 :y 0 :z 5
                                 :color #f32(1 0 0 1)
                                 :obj-data (load-obj "./objects/enemy.obj"))
                           *enemies*))
(set! *enemies* (spawn-obj (make <3d-obj> :x -5 :y 0 :z -5
                                 :color #f32(0 0 1 1)
                                 :obj-data (load-obj "./objects/enemy.obj"))
                           *enemies*))

(define (display-main-scene)
  (gl-clear (logior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (gl-light GL_LIGHT0 GL_POSITION *light0-pos*)
  (display-canvas)
  (glut-swap-buffers)
  )

(define (display-canvas)
  (display-floor)
  (move-player!)
  (move-obj-list! *enemies* move-enemy!)
  (move-obj-list! *bullets* move-bullet!)
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
  (gl-material GL_FRONT_AND_BACK GL_DIFFUSE  *floor-color*)
  (gl-translate 0 0 0)
  (gl-begin GL_QUADS)
  (gl-vertex (/ (- *floor-size*) 2) 0 (/ (- *floor-size*) 2) )
  (gl-vertex (/ (- *floor-size*) 2) 0 (/ *floor-size* 2) )
  (gl-vertex (/ *floor-size* 2) 0 (/ *floor-size* 2) )
  (gl-vertex (/ *floor-size* 2) 0 (/ (- *floor-size*) 2) )
  (gl-end)
  (gl-pop-matrix)
  )

(define (move-player!)
  (cond
   ( (char=? *keycode* #\a)
     (set! (r-of *player*) (if (<= 360 (r-of *player*))
                               0
                               (+ (r-of *player*) 3)) ))
   ( (char=? *keycode* #\d)
     (set! (r-of *player*) (if (>= 0 (r-of *player*))
                               360
                               (- (r-of *player*) 3)) ))
   ( (char=? *keycode* #\w) (move-obj! *player* 0.1) )
   ( (char=? *keycode* #\s) (move-obj! *player* -0.03) )
   ( (char=? *keycode* #\b) (shoot-bullet: *player-rifle*) )
   )
  (display-3d-obj: *player*)
  )

(define (move-obj-list! obj-list obj-func)
  (for-each (lambda (x) (obj-func x)) obj-list)
  )

(define-method collide-with-others? ((obj <3d-obj>) obj-list)
  (not (null? (filter
               (lambda (other-obj)
                 (and (< (distance: obj other-obj) 0.2)
                      (visible-of other-obj)) )
               (remove (lambda (x) (equal? x obj)) obj-list) )
              )))

(define-method move-enemy! ((enemy <3d-obj>))
  (let ((facing
         (exact (floor (rad-to-deg
                        (atan (- (x-of *player*) (x-of enemy))
                              (- (z-of *player*) (z-of enemy)))
                 )))
         ))
    (when (or (collide-with-others? enemy *enemies*)
              (collide-with-others? enemy *bullets*))
      (set! (visible-of enemy) #f))
    (set! (r-of enemy)
          (cond ( (< facing 0) (+ facing 360) )
                ( (> facing 360) (- facing 360) )
                ( else facing )
                ) )
    (when (> (distance: *player* enemy) 0.2)
      (move-obj! enemy 0.03))
    (display-3d-obj: enemy)
    ))

(define-method shoot-bullet: ((rifle <rifle>))
  (if (< (cooltime-of rifle) 0)
      (begin
        (set! *bullets* (spawn-obj (make <3d-obj>
                                     :x (x-of *player*)
                                     :y (+ (y-of *player*) 0.5)
                                     :z (z-of *player*)
                                     :r (r-of *player*)
                                     :color (bullet-color-of rifle)
                                     :obj-data (load-obj "./objects/bullet.obj")
                                     ) *bullets*))
        (set! (cooltime-of rifle) 5)
        )
      (when (< -1 (cooltime-of rifle))
          (set! (cooltime-of rifle) (- (cooltime-of rifle) 1)) )
      )
  )

(define-method out-of-map? ((obj <3d-obj>))
  (or (< (/ *floor-size* 2) (x-of obj) )
      (< (x-of obj) (/ (- *floor-size*) 2) )
      (< (/ *floor-size* 2) (z-of obj) )
      (< (z-of obj) (/ (- *floor-size*) 2) )
      ))
(define-method move-bullet! ((bullet <3d-obj>))
  (move-obj! bullet 0.2)
  (when (out-of-map? bullet)
    (set! (visible-of bullet) #f))
  (display-3d-obj: bullet)
  )


(define-method move-obj! ((obj <3d-obj>) d)
  (set! (x-of obj)
        (+ (x-of obj) (* d (table-sin (r-of obj)) )) )
  (set! (z-of obj)
        (+ (z-of obj) (* d (table-cos (r-of obj)) )) )
  )

(define (init)
  (gl-clear-color 0.7 0.7 1 1.0)
  (gl-enable GL_DEPTH_TEST)
  (gl-enable GL_LIGHTING)
  (gl-enable GL_LIGHT0)
  (gl-light GL_LIGHT0 GL_DIFFUSE *light-color*)
  (gl-light GL_LIGHT0 GL_SPECULAR *light-color*)
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
  (glut-init-window-size *window-width* *window-height*)
  (glut-init-display-mode (logior GLUT_RGBA GLUT_DOUBLE GLUT_DEPTH))
  (glut-create-window "Colour")
  (glut-display-func display-main-scene)
  (glut-reshape-func resize)
  (glut-keyboard-func keyboard)
  (glut-keyboard-up-func key-up)
  (glut-idle-func idle)
  (init)
  (glut-main-loop))
