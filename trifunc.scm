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

;;define rad-deg
(define *pi* (* 4 (atan 1)))
(define (deg-to-rad deg) (* deg (/ *pi* 180)))
(define (rad-to-deg rad) (* rad (/ 180 *pi*)))

(define (make-table f n acc)
  (if (< 360 n)
      (list->vector (reverse acc))
      (make-table f (+ n 1) (cons (f (deg-to-rad n)) acc))
      ))

(define *sin-table* (make-table sin 0 '()))
(define *cos-table* (make-table cos 0 '()))
(define *tan-table* (make-table tan 0 '()))

(define (table-sin n)
  (vector-ref *sin-table* n))
(define (table-cos n)
  (vector-ref *cos-table* n))
(define (table-tan n)
  (vector-ref *tan-table* n))
