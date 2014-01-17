#lang racket

(require osc)


;; for debugging, start `dumpOSC 9000`
(define server-port 9000)

(define the-socket (udp-open-socket))

;; from try-sending.rkt in rack-osc examples
(define (send-command message)
  (udp-send-to the-socket "127.0.0.1" server-port 
               (osc-element->bytes message)))

(send-command (osc-message #"/status" '(3)))


