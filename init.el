(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;;(load-theme 'cyberpunk t)
(load-theme 'blackboard t)
;;(load-theme 'github t)

(setq font-use-system-font 't)
(scroll-bar-mode 0)
(show-paren-mode 1)
(menu-bar-mode 0)
(global-visual-line-mode 1)
(global-linum-mode 1)
(tool-bar-mode 0)
(global-hl-line-mode 1)
(setq inhibit-splash-screen t)
(setq visible-bell 1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "s-/") 'comment-or-uncomment-region-or-line)

(defun bld/add-to-hooks (f hooks)
  "Add funcion F to all HOOKS."
  (dolist (hook hooks)
    (add-hook hook f)))

(defconst emacs-tmp-dir "~/.saves/")
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)
(setq
 backup-by-copying t      ; don't clobber symlinks
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 create-lockfiles nil)

(defvar lisp-mode-hooks
  '(emacs-lisp-mode-hook lisp-mode-hook clojure-mode-hook))

(defvar lisp-interaction-mode-hooks
  '(lisp-interaction-modes-hook cider-mode-hook cider-repl-mode-hook))

(use-package eldoc
  :diminish eldoc-mode
  :config (bld/add-to-hooks #'eldoc-mode
                            (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package paredit
  :ensure t
  :diminish paredit-mode
  :config (bld/add-to-hooks #'paredit-mode
                            (append lisp-mode-hooks lisp-interaction-mode-hooks)))



;; Clojure stuff
(use-package clojure-mode
  :ensure t
  :defer t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)))

(use-package paredit
  :ensure t)

(use-package cider
  :ensure t
  :defer t
  :config
  (setq cider-repl-history-file (concat user-emacs-directory "cider-history")
        cider-repl-history-size 1000
        cider-font-lock-dynamically '(macro core function var)
        cider-overlays-use-font-lock t
        cider-pprint-fn 'fipp
        cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))"))

(use-package clj-refactor
  :ensure t
  :defer t
  :config
  (defun my-clj-refactor-hook ()
    (message "Running cljr hook.")
    (clj-refactor-mode 1)
    (cljr-add-keybindings-with-prefix "C-c r"))
  (add-hook 'clojure-mode-hook 'my-clj-refactor-hook))

(use-package rainbow-delimiters
  :ensure t
  :diminish rainbow-delimiters
  :config (bld/add-to-hooks #'rainbow-delimiters-mode
                            (append lisp-mode-hooks lisp-interaction-mode-hooks)))

(use-package smex
  :ensure t
  :bind (("M-x" . smex))
  :config (smex-initialize))  ; smart meta-x (use IDO in minibuffer)

(use-package ido
  :ensure t
  :demand t
  :bind (("C-x b" . ido-switch-buffer))
  :config (ido-mode 1)
  (setq ido-create-new-buffer 'always  ; don't confirm when creating new buffers
        ido-enable-flex-matching t     ; fuzzy matching
        ido-everywhere t  ; tbd
        ido-case-fold t)) ; ignore case

(use-package ido-ubiquitous
  :ensure t
  :config (ido-ubiquitous-mode 1))

(use-package flx-ido
  :ensure t
  :config (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure t
  :config (ido-vertical-mode 1))

(use-package yasnippet
  :ensure t
  :defer t
  :config (yas-global-mode 1))

(use-package dockerfile-mode
  :ensure t)

(use-package terraform-mode
  :ensure t)

(add-hook 'sh-mode-hook 'flycheck-mode)


(use-package rainbow-mode
  :ensure t)

(use-package csv-mode
  :ensure t)

(use-package ido
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package highlight-symbol
  :ensure t)

(use-package coffee-mode
  :ensure t)

(use-package textmate
  :config
  (textmate-mode)
  :ensure t)

(use-package haml-mode
  :ensure t)

(use-package projectile
  :ensure t)

(use-package helm-projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on)
  :bind ("s-t" . helm-projectile)
  )

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (global-company-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (setq projectile-enable-caching t)
  (projectile-global-mode 1))

(use-package whitespace
  :diminish whitespace
  :init (setq whitespace-style '(face empty tabs lines-tail trailing))
  :config (global-whitespace-mode t))

(use-package flycheck
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("94ce2a2fc1a2341590020a50e6d6916c81451c596313dda6453e41c526c1dc86" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
