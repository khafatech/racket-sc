#!r6rs

;; from rsc3/help/ugen/binary-ops/ring3.help.scm

(import (rnrs) (rsc3) (rhs))

(audition
 (out 0 (mul (ring4 (f-sin-osc ar 800 0)
                    (f-sin-osc ar (x-line kr 200 500 5 do-nothing) 0))
             0.125)))

(let ((a (f-sin-osc ar 800 0))
      (b (f-sin-osc ar (x-line kr 200 500 5 do-nothing) 0)))
  (audition
   (out 0 (mul (sub (mul3 a a b) (mul3 a b b)) 
               0.125))))


(audition
 (out 0 (mul (ring3 (f-sin-osc ar 800 0)
                    (f-sin-osc ar (x-line kr 200 500 5 do-nothing) 0))
             0.125)))