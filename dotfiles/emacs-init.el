(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))


;; --- Appearance ---
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-display-line-numbers-mode t)
(show-paren-mode 1)
(electric-pair-mode 1)
(icomplete-mode 1)

;; --- Theme ---
(unless (package-installed-p 'doom-themes)
  (package-install 'doom-themes))
(require 'doom-themes)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
(load-theme 'doom-gruvbox t)



;; --- Vim Key Bindings ---
(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'evil)
(setq evil-want-keybinding nil)
(evil-mode 1)


;; --- (common lisp) ---
(unless (package-installed-p 'sly)
  (package-install 'sly))

(setq inferior-lisp-program "sbcl")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
