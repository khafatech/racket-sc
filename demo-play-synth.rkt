#lang racket


(require "init.rkt")


;; show osc messages in server's terminal
(send-osc-message  #"/dumpOSC" '(1))

;; clears nodes on server
(reset)

;; example usage:

(printf "press enter to make sound\n")
(define temp1 (read-line))

(send-synthdef "basic_sin.scsyndef")
;; should wait for /done message
(sleep 0.5)

;; synth should start playing after this
(define my-sin (synth-new "basic_sin"))

;; get node id
; (synth-node-id my-sin)

(printf "Press enter to change frequency\n")
(define temp2  (read-line))

;; change freq
(synth-set-params my-sin (list #"freq" 500))

(printf "Press enter to stop playing synth\n")
(read-line)

;; stop playing
(synth-stop my-sin)

;; delete synth object (stops sound)
;; (synth-delete my-sin)

(printf "Press enter to play scale\n")
(read-line)

;; stop playing
(synth-play my-sin)
;; play a scale
(for [(x (range 12))]
    (begin (synth-set-params my-sin (list #"freq" (* 220 (expt 2 (/ x 6)))))
           (sleep 0.2)))

(sleep 0.5)
(synth-stop my-sin)

