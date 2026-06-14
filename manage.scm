#!/usr/bin/gosh

(use file.util)

;; --- Target Config Files ---
(define *dotfiles*
  ;; (dotfiles name . source path)
  '(("alacritty.toml"       . ".config/alacritty/alacritty.toml")
    ("nvim"                 . ".config/nvim")
    ("sway_config"          . ".config/sway/config")
    ("tmux.conf"            . ".tmux.conf")
    ("config.fish"          . ".config/fish/config.fish")
    ("foot.ini"             . ".config/foot/foot.ini")
    ("skk_user.dict"        . ".local/share/fcitx5/skk/user.dict")))


(define *dotfiles-dir* (string-append (current-directory) "/"))
(define *home-dir* (string-append (home-directory) "/"))

(define (install)
  (dolist (pair *dotfiles*)
	  (let* ((src (string-append *dotfiles-dir* (car pair)))
		 (dst (string-append *home-dir* (cdr pair))))
	    (if (file-is-directory? src)
		(copy-directory* src dst :if-exists :supersede)
		(copy-file src dst :if-exists :supersede)))))


(define (collect)
  (dolist (pair *dotfiles*)
	  (let* ((dst (string-append *dotfiles-dir* (car pair)))
		 (src (string-append *home-dir* (cdr pair))))
	    (if (file-is-directory? src)
		(copy-directory* src dst :if-exists :supersede)
		(copy-file src dst :if-exists :supersede)))))


(define (main args)
  (let ((cmd (if (null? (cdr args)) "" (cadr args))))
    (cond ((string=? cmd "install") (install))
	  ((string=? cmd "collect") (collect))
	  (else (print "Usage: gosh manage.scm [install|collect]")))))
