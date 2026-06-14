(global-display-line-numbers-mode t)

(setq truncate-lines t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8dbbcb2b7ea7e7466ef575b60a92078359ac260c91fe908685b3983ab8e20e3f"
     default))
 '(display-line-numbers-width-start t)
 '(package-selected-packages '(evil geiser-gauche monokai-theme rust-mode sly)))

;; Smooth Scrolloing
(if (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode 1))
(setq scroll-conservatively 101)       
(setq scroll-margin 3)                
(setq scroll-step 1)                 
(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-initial-frame t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

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
