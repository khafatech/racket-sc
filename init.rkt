#lang racket

(require osc)


;; to start SC server: scsynth -u 9000
;; for debugging, start `dumpOSC 9000`
(define server-port 9000)
(define the-socket (udp-open-socket))

(define (start-server)
  (thread
   (lambda ()
     (system (format "scsynth -u ~a" server-port)))))

(define (listen)
  (udp-bind! the-socket "127.0.0.1" 0) ; 0 means choose a random client-port

  ;; From try-sending.rkt in rack-osc
  ;; also, we're assuming we won't get any messages longer than 10K
  (define receive-buffer (make-bytes 10000 0))
  (thread
   (lambda ()
     (let loop ()
       (printf "waiting for incoming messages.\n")
       (define-values (len hostname src-port)
         (udp-receive! the-socket receive-buffer))
       ; (printf "current seconds: ~v\n" (current-seconds))
       ; (printf "len: ~v\nhostname: ~v\nsrc-port: ~v\n" len hostname src-port)
       (define received (subbytes receive-buffer 0 len))
       ; (printf "received buffer: ~v\n" received)
       (printf "decoded: ~e\n" (bytes->osc-element received))
       (loop)))))

(listen)

;;;; Functions for sending ;;;;;

;; from try-sending.rkt in rack-osc examples
;; osc-message -> void
(define (send-command message)
  (udp-send-to the-socket "127.0.0.1" server-port 
               (osc-element->bytes message)))

; address, [arg list] -> void
(define (send-osc-message addr [args '()])
  (send-command (osc-message addr args)))

;; show osc messages in server's terminal
(send-osc-message  #"/dumpOSC" '(1))

;; byte-string -> void
;; TODO - put contract-out
(define (send-synthdef bytes)
  (cond [(bytes? bytes)
         (send-osc-message #"/d_recv" '(bytes))]
        [else (error 'send-synthdef "expected bytes")]))

(define (load-synthdef filename)
  (define filename-bytes (cond [(bytes? filename) filename]
                               [(string? filename) (string->bytes/utf-8 filename)]
                               [else (error "filename should be bytes")]))
  (send-osc-message #"/d_load" '(filename-bytes)))


#|
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

|#
