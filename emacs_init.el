(menu-bar-mode -1)
(setq-default truncate-lines t)

(setq make-backup-files nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8dbbcb2b7ea7e7466ef575b60a92078359ac260c91fe908685b3983ab8e20e3f"
     default))
 '(display-line-numbers-width-start t)
 '(package-selected-packages
   '(auctex catppuccin-theme centaur-tabs doom-modeline evil-collection
	    evil-goggles evil-numbers geiser-gauche monokai-theme
	    rust-mode sly xclip)))

(defun load-config ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))


;; ============================================================
;; Line Number
;; ============================================================

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'visual)



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
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("nongnu" . "https://elpa.nongnue.org/nongnue/")
	        ("elpa" . "https://elpa.gnu.org/packages/")))
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

(setq evil-undo-system 'undo-redo)
(setq evil-want-C-u-scroll t)
(setq evil-search-module 'evil-search)
(setq evil-ex-search-vim-style-regexp t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)
  (setq evil-goggles-duration 0.1)
  (setq evil-goggles-enable-delete nil))

(use-package evil-numbers
  :ensure t
  :after evil
  :bind
  (:map evil-normal-state-map
	("C-a" . evil-numbers/inc-at-pt)
	("C-x" . evil-numbers/dec-at-pt))
  (:map evil-visual-state-map
	("C-a" . evil-numbers/inc-at-pt)
	("C-x" . evil-numbers/dec-at-pt)
	("C-c C-a" . evil-numbers/inc-at-pt-incremental)
	("C-c C-x" . evil-numbers/dec-at-pt-incremental)))




;; ============================================================
;; Clipboard
;; ============================================================

(setq select-enable-clipboard t)
(setq select-enable-primary nil)

(use-package xclip
  :ensure t
  :config
  (setq xclip-method 'wl-copy)
  (xclip-mode 1))



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
;; Tab bar
;; ============================================================

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-battery t)
  (setq doom-modeline-battery-percentage t)
  (setq doom-modeline-battery-refresh-rate 120)
  (setq doom-modeline-time t)
  :hook (after-init . doom-modeline-mode))



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
;; LaTeX
;; ============================================================

(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq-default TeX-engine 'luatex)
  (setq-default Japanese-TeX-engine 'luatex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t))


;; ============================================================
;; LSP
;; ============================================================

(use-package cc-mode
  :ensure nil
  :config
  (setq-default c-basic-offset 4
		tab-width 4
		indent-tabs-mode nil)
  (add-hook 'c-mode-common-hook
            (lambda () (c-set-style "linux"))))

(use-package eglot
  :ensure t
  :hook ((c-mode c++-mode python-mode rust-mode) . eglot-ensure)
  :config
  (add-hook 'before-save-hook 'eglot-format-buffer nil t))

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




;; ============================================================
;; Auto Complete
;; ============================================================

(use-package company
  :ensure t
  :init
  (global-company-mode t)
  :config
  (setq company-idle-delay 0.0
	company-minimum-prefix-length 1
	company-selection-wrap-around t))
