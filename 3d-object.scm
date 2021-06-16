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
(use srfi-1)
(use srfi-13)
(use gauche.uvector)

(define-class <obj-data> ()
  ((vdata :init-value #() :init-keyword :vdata :accessor vdata-of)
   (fdata :init-value #() :init-keyword :fdata :accessor fdata-of)
   ))
;;define classes
(define-class <3d-obj> ()
  ((x :init-value 0 :init-keyword :x :accessor x-of)
   (y :init-value 0 :init-keyword :y :accessor y-of)
   (z :init-value 0 :init-keyword :z :accessor z-of)
   (r :init-value 0 :init-keyword :r :accessor r-of)
   (d :init-value 0 :init-keyword :d :accessor d-of)
   (color :init-value #f32(0 0 0 1) :init-keyword :color :accessor color-of)
   (obj-data :init-value #()
             :init-keyword :obj-data
             :accessor obj-data-of)
   ))

(define (vec2d-ref vec a b) (vector-ref (vector-ref a) b) )

;;split text list -> vertex data (string list) -> vertex data (number vector)
(define (filter-data split-text filter-token)
  (list->vector
   (map (lambda (n)
          (list->vector (map string->number n)) )
        (map cdr (filter (lambda (line)
                           (string=? (car line) filter-token))
                         split-text))
        ) )
  )

(define (load-obj obj-file)
  (let* ( (split-text (map string-tokenize
                           (call-with-input-file obj-file port->string-list)) )
          (vdata (filter-data split-text "v"))
          )
    (vector-map (lambda (vec-data)
                  (vector-map (lambda (n)
                                (vector-ref vdata (- n 1)) )
                              vec-data) )
                (filter-data split-text "f"))
    ))

(define-method display-3d-obj: ((obj <3d-obj>))
  (gl-push-matrix)
  (gl-material GL_FRONT_AND_BACK GL_DIFFUSE (color-of obj))
  (gl-translate (x-of obj) (y-of obj) (z-of obj))
  (gl-rotate (r-of obj) 0 1 0)
  (gl-begin GL_TRIANGLES)
  (vector-for-each (lambda (three-vecs)
                     (vector-for-each (lambda (vec)
                                        (gl-vertex (vector-ref vec 0)
                                                   (vector-ref vec 1)
                                                   (vector-ref vec 2)) )
                                      three-vecs) )
                   (obj-data-of obj) )
  (gl-end)
  (gl-pop-matrix)
  )
