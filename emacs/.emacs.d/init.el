(require 'use-package-ensure)
(setq use-package-always-ensure t)
(setq package-install-upgrade-built-in t)

(if (file-directory-p "/usr/local/share/emacs/site-lisp")
    (setq load-path (append (list "/usr/local/share/emacs/site-lisp")
			    load-path)))
(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
(add-to-list 'auto-mode-alist '("\\.ly\\'" . LilyPond-mode))
(add-to-list 'auto-mode-alist '("\\.ily\\'" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))

(use-package emacs
  :init
  (setq inhibit-startup-screen t)
  (setq display-line-numbers-type 'relative)
  (setq visible-bell t)
  (setq custom-file "~/.emacs.d/custom-file.el")
  (load-file custom-file)
  (set-face-attribute 'default nil :font "Cascadia Mono NF" :height 130)
  ; If MELPA packages are needed:
  ; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  :config
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (global-display-line-numbers-mode 1)
  (column-number-mode)
  (global-hl-line-mode)
  (setf use-default-font-for-symbols nil)
  (set-fontset-font t 'unicode "Noto Emoji" nil 'append)
  (require-theme 'modus-themes)
  (setq modus-themes-to-toggle
	'(modus-operandi-tritanopia modus-vivendi-tritanopia))
  (load-theme 'modus-operandi-tritanopia)
  (global-set-key (kbd "C-x RET RET") 'modus-themes-toggle))

(use-package whitespace
  :hook (before-save . whitespace-cleanup))

;;; BUILT-IN: completion suggestions for find-file
(use-package ido
  :config
  (ido-mode t)
  (ido-everywhere))

;;; ELPA: PDF support via poppler
(use-package pdf-tools
  :init
  (pdf-loader-install)
  :hook
  (pdf-view-mode . (lambda () (display-line-numbers-mode 0)))
  :config
  (add-hook 'pdf-view-mode-hook (lambda () (auto-revert-mode 1))))

;;; ELPA: undo history for evil mode
(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

;;; ELPA: Vim emulation
(use-package evil
  :custom (evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (setq evil-want-C-u-scroll t))
;;; ELPA: Vim-surround emulation
(use-package evil-surround
  :config (global-evil-surround-mode 1))

;;; BUILT-IN: Show hints for keybindings
(use-package which-key
  :diminish which-key-mode
  :config (which-key-mode 1))

;;; ELPA: Git frontend
(use-package magit
	     :defer t)

;;; ELPA: LaTeX support
(use-package auctex
  :defer t
  :hook
  (LaTeX-mode . turn-on-reftex)
  (LaTeX-mode . (lambda () (setq TeX-command-default "LaTeXMk")))
  :init
  (add-hook 'TeX-after-compliation-finished-functions
	    #'TeX-revert-document-buffer)
  (setq TeX-PDF-mode t)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-command-default "LaTeXMk")
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-source-correlate-start-server t))
;;; BUILT-IN: LaTeX reference management
(use-package reftex)

;;; BUILT-IN: LSP client
(use-package eglot)

;;; ELPA: Common Lisp support
(use-package slime
  :init (setq inferior-lisp-program "sbcl"))

;;; ELPA: Haskell support
(use-package haskell-ts-mode
  :custom
  (haskell-ts-font-lock-level 4)
  (haskell-ts-ghci "ghci")
  (haskell-ts-use-indent t)
  :config
  (add-to-list 'treesit-language-source-alist
	       '(haskell . ("https://github.com/tree-sitter/tree-sitter-haskell" "v0.23.1"))))

;;; ELPA: OCaml support
(use-package tuareg)

;;; BUILT-IN: Org mode
(use-package org
  :config
  ; (setq org-highlight-latex-and-related '(latex script entities))
  (setq org-export-in-background t)
  :hook
  (org-mode . (lambda () (display-line-numbers-mode 0)))
  :custom
  (org-format-latex-options '(:foreground default
					  :background default
					  :scale 1.2
					  :html-foreground "Black"
					  :html-background "Transparent"
					  :html-scale 1.0
					  :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))))

;;; ELPA: Typst support (suspicious LaTeX replacement)
(use-package typst-ts-mode
  :mode ("\\.typ\\'" . typst-mode))

;;; ELPA: Racket mode
(use-package geiser-racket)

;;; ELPA: Markdown mode
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command '("pandoc" "--mathjax" "--from=markdown" "--to=html5"))
  (setq markdown-enable-math t))

;;; ELPA: Proof assistant frontend
(use-package proof-general)

;;; AI pair programming
; (use-package aidermacs)

(use-package codex-ide
  :vc (:url "https://github.com/dgillis/emacs-codex-ide" :rev :newest)
  :bind ("C-c C-;" . codex-ide-menu))
