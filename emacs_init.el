(global-display-line-numbers-mode t)

(menu-bar-mode -1)
(setq-default truncate-lines t)

(custom-set-variables
 '(custom-safe-themes
   '("8dbbcb2b7ea7e7466ef575b60a92078359ac260c91fe908685b3983ab8e20e3f"
     default))
 '(display-line-numbers-width-start t)
 '(package-selected-packages
   '(catppuccin-theme centaur-tabs evil geiser-gauche monokai-theme
		      rust-mode sly)))


;; ============================================================
;; Smooth Scrolling
;; ============================================================

(if (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode 1))
(setq scroll-conservatively 101)       
(setq scroll-margin 3)                
(setq scroll-step 1)                 
(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-initial-frame t)



;; ============================================================
;; Package Manager
;; ============================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))



;; ============================================================
;; Color Scheme
;; ============================================================

(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin :no-confirm))



;; ============================================================
;; VIM keybind
;; ============================================================

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))



;; ============================================================
;; Tab bar
;; ============================================================

(use-package centaur-tabs
  :ensure t
  :config
  (centaur-tabs-mode 1))

(with-eval-after-load 'evil
  (with-eval-after-load 'centaur-tabs
    (evil-define-key 'normal 'global (kbd "H") 'centaur-tabs-backward)
    (evil-define-key 'normal 'global (kbd "L") 'centaur-tabs-forward)))



;; ============================================================
;; HTTP Proxy
;; ============================================================

(defvar proxy-url "po.cc.ibaraki-ct.ac.jp:3128")

(defun proxy-on ()
  (interactive)
  (setq url-proxy-services
	'(("http" . proxy-url)
	  ("https" . proxy-url)
	  ("no_proxy" . "^\\(localhost\\|127\\.0\\.0\\.1\\)")))
  (setenv "http_proxy" (concat "http://" proxy-url))
  (setenv "https_proxy" (concat "http://" proxy-url))
  (setenv "no_proxy" "localhost,127.0.0.1")
  (message "Proxy enabled: %s" (concat "http://" proxy-url)))

(defun proxy-off ()
  (interactive)
  (setq url-proxy-services nil)
  (setenv "http_proxy" nil)
  (setenv "https_proxy" nil)
  (setenv "no_proxy" nil)
  (message "Proxy disabled"))



;; ============================================================
;; LSP
;; ============================================================

(use-package eglot
  :ensure t
  :hook ((c-mode c++-mode python-mode rust-mode) . eglot-ensure))

;; Rust
(use-package rust-mode
  :ensure t)

;; Common Lisp
(use-package sly
  :ensure t
  :config
  ;; Lisp処理系を指定
  (setq inferior-lisp-program "sbcl")) 

;; Scheme (Gauche)
(use-package geiser-gauche
  :ensure t
  :config
  ;; Gauche
  (setq geiser-gauche-binary "gosh"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
