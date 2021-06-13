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
(load "./3d-object.scm")
(load "./trifunc.scm")

;;define constant values
(define *window-width* 640)
(define *window-height* 640)
(define *floor-size* 10)
(define *floor-color* #f32(0.5 0.5 0.5 1))
(define *light0-pos* #f32(0 3 0 1))
(define *light-color* #f32(1 1 1 0))

;;define dynamic variables
(define *player* (make <3d-object>
                   :x 0 :y 0.5 :z 0 :d 0.1 :color #f32(0 1 0 1)) )
(define *keycode* #\null)

(define (display)
  (gl-clear (logior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (gl-light GL_LIGHT0 GL_POSITION *light0-pos*)
  (display-canvas)
  (glut-swap-buffers)
  )

(define (display-canvas)
  (display-floor)
  (display-player)
  (display-camera)
  )
(define (display-camera)
  (gl-matrix-mode GL_MODELVIEW)
  (gl-load-identity)
  (glu-look-at
   (- (x-of *player*) (* (sin-from-table (r-of *player*)) 3))
   (+ (y-of *player*) (+ (y-of *player*) 0.1))
   (- (z-of *player*) (* (cos-from-table (r-of *player*)) 3))
   (x-of *player*) (y-of *player*) (z-of *player*)
   0 1 0)
  )

(define (display-floor)
  (gl-push-matrix)
  (gl-material GL_FRONT_AND_BACK GL_DIFFUSE *floor-color*)
  (gl-translate 0 0 0)
  (gl-begin GL_QUADS)
  (gl-vertex (/ (- *floor-size*) 2) 0 (/ (- *floor-size*) 2) )
  (gl-vertex (/ (- *floor-size*) 2) 0 (/ *floor-size* 2) )
  (gl-vertex (/ *floor-size* 2) 0 (/ *floor-size* 2) )
  (gl-vertex (/ *floor-size* 2) 0 (/ (- *floor-size*) 2) )
  (gl-end)
  (gl-pop-matrix)
  )

(define (display-player)
  ;;key control
  (cond
   ( (char=? *keycode* #\a)
     (set! (r-of *player*) (if (<= 360 (r-of *player*))
                               0
                               (+ (r-of *player*) 4)) ))

   ( (char=? *keycode* #\d)
     (set! (r-of *player*) (if (>= 0 (r-of *player*))
                               360
                               (- (r-of *player*) 4)) ))

   ( (char=? *keycode* #\w)
     (begin
       (set! (x-of *player*)
             (+ (x-of *player*)
                (* (d-of *player*) (sin-from-table (r-of *player*)) )) )
       (set! (z-of *player*)
             (+ (z-of *player*)
                (* (d-of *player*) (cos-from-table (r-of *player*)) )) )
       ))

   ( (char=? *keycode* #\s)
     (begin
       (set! (x-of *player*)
             (+ (x-of *player*)
                (* (/ (d-of *player*) -3) (sin-from-table (r-of *player*)) )) )
       (set! (z-of *player*)
             (+ (z-of *player*)
                (* (/ (d-of *player*) -3) (cos-from-table (r-of *player*)) )) )
       ))
   )
  ;;display player
  (display-cube: *player* 0.25)
  )

(define-method display-cube: ((obj <3d-object>) size)
  (gl-push-matrix)
  (gl-material GL_FRONT_AND_BACK GL_DIFFUSE (color-of obj))
  (gl-translate (x-of obj) (y-of obj) (z-of obj) )
  (gl-rotate (r-of obj) 0 1 0)
  (glut-solid-cube size)
  (gl-pop-matrix)
  )

(define (init)
  (gl-clear-color 0.7 0.7 1 1.0)
  (gl-enable GL_DEPTH_TEST)
  (gl-enable GL_LIGHTING)
  (gl-enable GL_LIGHT0)
  (gl-light GL_LIGHT0 GL_DIFFUSE *light-color*)
  (gl-light GL_LIGHT0 GL_SPECULAR *light-color*)
  (gl-enable GL_CULL_FACE)
  (gl-cull-face GL_BACK)
  )

(define (keyboard key x y)
  (if (= key (char->integer #\q))
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
  (glut-display-func display)
  (glut-reshape-func resize)
  (glut-keyboard-func keyboard)
  (glut-keyboard-up-func key-up)
  (glut-idle-func idle)
  (init)
  (glut-main-loop))
