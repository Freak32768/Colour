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

;;define classes
(define-class <3d-object> ()
  ((x :init-value 0 :init-keyword :x :accessor x-of)
   (y :init-value 0 :init-keyword :y :accessor y-of)
   (z :init-value 0 :init-keyword :z :accessor z-of)
   (r :init-value 0 :init-keyword :r :accessor r-of)
   (d :init-value 0 :init-keyword :d :accessor d-of)
   (color :init-value #f32(0 0 0 1) :init-keyword :color :accessor color-of)
   ))

