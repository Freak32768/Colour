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

(define-class <creature> (<3d-obj>)
  ((life :init-value 0
         :init-keyword :life
         :accessor life-of)
   (life-max :init-value 0
             :init-keyword :life-max
             :accessor life-max-of)
   ))
(define-class <sniper> (<creature>)
  ((rifle-cooltime :init-value 0
                   :init-keyword :rifle-cooltime
                   :accessor rifle-cooltime-of)
   (rifle-cooltime-max :init-value 0
                       :init-keyword :rifle-cooltime-max
                       :accessor rifle-cooltime-max-of)
   ))

(define (spawn-obj new-obj obj-list)
  (if (< 10 (length obj-list))
      (cons new-obj (remove-invisible-obj obj-list))
      (cons new-obj obj-list)) )

(define (remove-invisible-obj obj-list)
  (remove (lambda (obj) (eq? (visible-of obj) #f)) obj-list) )

(define (obj-for-each! obj-list obj-func)
  (for-each (lambda (x) (obj-func x)) obj-list)
  )

(define-method collide-with-others? ((obj <3d-obj>) obj-list)
  (not (null? (filter
               (lambda (other-obj)
                 (and (< (distance: obj other-obj) 0.2)
                      (visible-of other-obj)) )
               (remove (lambda (x) (equal? x obj)) obj-list) )
              )) )

(define-method out-of-map? ((obj <3d-obj>))
  (or (< (/ FLOOR-SIZE 2) (x-of obj) )
      (< (x-of obj) (/ (- FLOOR-SIZE) 2) )
      (< (/ FLOOR-SIZE 2) (z-of obj) )
      (< (z-of obj) (/ (- FLOOR-SIZE) 2) )
      ))

(define-method move-obj! ((obj <3d-obj>) d)
  (set! (x-of obj)
        (+ (x-of obj) (* d (table-sin (r-of obj)) )) )
  (set! (z-of obj)
        (+ (z-of obj) (* d (table-cos (r-of obj)) )) )
  )

(define-method display-life-bar: ((obj <creature>))
  (gl-push-matrix)
  (gl-translate (x-of obj) (+ 0.8 (y-of obj)) (z-of obj))
  (gl-rotate (r-of obj) 0 1 0)
  (gl-begin GL_QUADS)
  (let ((life-bar-width (* LIFE-BAR-WIDTH-MAX
                           (/ (life-of obj) (life-max-of obj)) )
                        ))
    (gl-vertex (/ life-bar-width 2) LIFE-BAR-HEIGHT 0)
    (gl-vertex (/ life-bar-width -2) LIFE-BAR-HEIGHT 0)
    (gl-vertex (/ life-bar-width 2) 0 0)
    (gl-vertex (/ life-bar-width -2) 0 0)
    )
  (gl-end)
  (gl-pop-matrix)
  )

(define-method damage-creature! ((obj <creature>) another-obj-color)
  (set! (life-of obj)
        (- (life-of obj)
           (cond
            ( (equal? (color-of obj) another-obj-color) 0 )
            ( (find (lambda (x)
                      (equal? (cons (color-of obj) another-obj-color) x))
                    CRITICALS) 5 )
            ( else 1 ))
           ))
  )
