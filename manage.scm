#!/usr/bin/env gosh

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
    ("emacs_init.el"        . ".emacs.d/init.el")
    ("skk_user.dict"        . ".local/share/fcitx5/skk/user.dict")))


(define *dotfiles-dir* (string-append (current-directory) "/"))
(define *home-dir* (string-append (home-directory) "/"))

(define (copy-config-files operation-type)
  (dolist (pair *dotfiles*)
	  (let* ((dotfile-name (string-append *dotfiles-dir* (car pair)))
		 (origin-path (string-append *home-dir* (cdr pair)))
		 (src (cond ((eq? operation-type 'install) dotfile-name)
			    ((eq? operation-type 'collect) origin-path)
			    (#t #f)))
		 (dst (cond ((eq? operation-type 'install) origin-path)
			    ((eq? operation-type 'collect) dotfile-name)
			    (#t #f))))
	    (if (and src dst) ;; not nil
		(if (file-is-directory? src)
		    (copy-directory* src dst :if-exists :supersede)
		    (copy-file src dst :if-exists :supersede))
		#f))))



(define (main args)
  (let ((cmd (if (null? (cdr args)) "" (cadr args))))
    (cond ((string=? cmd "install") (copy-config-files 'install))
	  ((string=? cmd "collect") (copy-config-files 'collect))
	  (else (print "Usage: gosh manage.scm [install|collect]")))))
