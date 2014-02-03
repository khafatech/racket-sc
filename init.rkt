#lang racket

(require osc)


;; to start SC server: scsynth -u 9000
;; for debugging, start `dumpOSC 9000`
(define server-port 57110)
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

(define (bytes->osc-blob bytes)
  (list 'blob bytes))

;; byte-string -> void
;; TODO - put contract-out
(define (send-synthdef filename)
         (send-osc-message #"/d_recv" (list (bytes->osc-blob (file->bytes filename)))))

(define (string/bytes->bytes thing)
  (cond [(bytes? thing) thing]
        [(string? thing) (string->bytes/utf-8 thing)]
        [else (error "be convertable to bytes")]))

(define (load-synthdef filename)
  (send-osc-message #"/d_load" (list (string/bytes->bytes filename))))

(define (get-status)
  (send-osc-message #"/status"))


(define current-node-id 1000)
(define (gen-node-id)
  (set! current-node-id (add1 current-node-id))
  current-node-id)

;; represents a synth object/node on the server
;; TODO - add parameters?
;; construct from a macro like overtone?
(struct synth (node-id))

;; TODO - process args
(define (synth-new name [args '()])
  (define node-id (gen-node-id))
  (let ([action 1] ; add to tail
        [parent-node 0])
  (send-osc-message #"s_new" (list (string/bytes->bytes name)
                                  node-id
                                  action
                                  parent-node)))
  (synth node-id))

(define (synth-play s)
  (send-osc-message #"n_run" (list (synth-node-id s) 1)))

(define (synth-stop s)
  (send-osc-message #"n_run" (list (synth-node-id s) 0)))

;; synth, [(#"arg1" val1) (#"arg2" val2) ...] -> void
(define (synth-set-params s args)
  (send-osc-message #"n_set" (cons (synth-node-id s) (flatten args))))

(define (synth-delete s)
  (send-osc-message #"n_free" (list (synth-node-id s))))
  

#|
;; example usage:

(send-synthdef "basic_sin.scsyndef")

;; synth should start playing after this
(define my-sin (synth-new "basic_sin"))

;; get node id
; (synth-node-id my-sin)

;; stop playing
(synth-stop my-sin)

;; start playing
(synth-play my-sin)

;; change freq
(synth-set-params my-sin (list #"freq" 500))

;; delete synth object (stops sound)
(synth-delete my-sin)

|#

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
