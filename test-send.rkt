#lang racket

(require osc)


;; for debugging, start `dumpOSC 9000`
(define server-port 9000)
;; (define receive-port 9001)
(define the-socket (udp-open-socket))
(udp-bind! the-socket "127.0.0.1" 0)

;; From try-sending.rkt in rack-osc
;; also, we're assuming we won't get any messages longer than 10K
(define receive-buffer (make-bytes 10000 0))

(thread
 (lambda ()
   (let loop ()
     (printf "waiting for incoming messages.\n")
     (define-values (len hostname src-port)
       (udp-receive! the-socket receive-buffer))
     (printf "current seconds: ~v\n" (current-seconds))
     (printf "len: ~v\nhostname: ~v\nsrc-port: ~v\n" len hostname src-port)
     (define received (subbytes receive-buffer 0 len))
     #;(printf "received buffer: ~v\n" received)
     (printf "decoded: ~e\n" (bytes->osc-element received))
     (loop))))


;; from try-sending.rkt in rack-osc examples
(define (send-command message)
  (udp-send-to the-socket "127.0.0.1" server-port 
               (osc-element->bytes message)))

;; Send commands
; (send-command (osc-message #"" '(   )))
(send-command (osc-message #"/dumpOSC" '(1)))
(send-command (osc-message #"/status" '()))

; create a synth
; server loads synthdefs in synthdefs/ 
; (send-command (osc-message #"/d_load" '(#"basic_sin.scsyndef"))
(send-command (osc-message #"s_new" '(#"basic_sin" 1000 1 0 )))
(send-command (osc-message #"n_run" '(1000 1)))

; delete node
; (send-command (osc-message #"/n_free" '(1000)))

