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

;;make-table core
(define (make-trifunc-table type n acc)
  (if (< 360 n)
      (list->vector (reverse acc))
      (make-trifunc-table type (+ n 1) (cons (type (deg-to-rad n)) acc) )
      ))

;;frifunc-tables
(define *sin-table* (make-trifunc-table sin 0 '()))
(define *cos-table* (make-trifunc-table cos 0 '()))
(define *tan-table* (make-trifunc-table tan 0 '()))

;;get value from tables
(define (sin-from-table n)
  (vector-ref *sin-table* n))
(define (cos-from-table n)
  (vector-ref *cos-table* n))
(define (tan-from-table n)
  (vector-ref *tan-table* n))
