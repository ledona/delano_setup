;;; init.el --- save to ~/.emacs.d/init.el  -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package setup — use-package instead of Cask (Cask is unmaintained)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Only refresh package archives if we don't already have a local index —
;; avoids hitting the network on every single startup.
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; keep Custom's auto-writes out of this file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; personal elisp lib dir
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; session / vc / backups
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(desktop-save-mode 1)
(setq desktop-buffers-not-to-save "\\COMMIT_EDITMSG\\'") ;; ignore git commit messages

(setq vc-follow-symlinks t)                  ;; follow symlinks to VC files without asking
(setq backup-by-copying-when-linked t)       ;; copy, don't rename, hard-linked files
(transient-mark-mode t)                      ;; highlight marked region (default on since 23, kept explicit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(menu-bar-mode -1)
(set-face-attribute 'default nil :height 140)

;; line numbers — display-line-numbers-mode replaces the old `linum'
(global-display-line-numbers-mode 1)

;; highlight current line
(global-hl-line-mode 1)
(set-face-attribute 'hl-line nil :inherit nil :underline "lightgrey")

;; 100-column indicator — built-in replacement for fill-column-indicator
(setq-default fill-column 100)
(setq-default display-fill-column-indicator-character ?\|)
(global-display-fill-column-indicator-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; indentation / whitespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)          ;; spaces, not tabs

(require 'whitespace)
(global-whitespace-mode 1)
(setq whitespace-style '(face trailing tabs empty))
(setq whitespace-line-column 100)
(global-set-key (kbd "C-c w") 'whitespace-cleanup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mouse support in terminal (OSX/Linux terminals without native mouse)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless (display-graphic-p)
  (require 'mouse)
  (xterm-mouse-mode t)
  (defun track-mouse (_e))
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clipboard integration — OS-conditional, no manual editing needed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pbcopy
  :if (eq system-type 'darwin)
  :config (turn-on-pbcopy))

(use-package xclip
  :if (memq window-system '(x wayland))
  :config (xclip-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; completion — ido kept as requested; vertico/orderless is the modern
;; equivalent if you ever want to switch (better fuzzy matching, same idea)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ido-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck + custom mypy checker
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package flycheck
  :init (global-flycheck-mode)
  :custom
  (flycheck-check-syntax-automatically '(idle-change mode-enabled))
  (flycheck-idle-change-delay 10)
  (flycheck-python-mypy-config "mypy.ini")
  :config
  (global-set-key [f10] 'flycheck-previous-error)
  (global-set-key [f11] 'flycheck-next-error)

  (flycheck-define-checker python-mypy-ledona
    "Ledona custom Mypy syntax and type checker, same as default except
no following checking. Requires mypy>=0.580.

See URL `http://mypy-lang.org/'."
    :command ("mypy"
              "--show-column-numbers"
              (config-file "--config-file" flycheck-python-mypy-ini)
              (option "--cache-dir" flycheck-python-mypy-cache-dir)
              source-original)
    :error-patterns
    ((error line-start (file-name) ":" line (optional ":" column)
            ": error:" (message) line-end)
     (warning line-start (file-name) ":" line (optional ":" column)
              ": warning:" (message) line-end))
    :modes python-mode
    ;; Ensure the file is saved, to work around
    ;; https://github.com/python/mypy/issues/4746.
    :predicate flycheck-buffer-saved-p)

  (push 'python-mypy-ledona (cdr (last flycheck-checkers)))
  (flycheck-add-next-checker 'python-pylint 'python-mypy-ledona)
  (flycheck-add-next-checker 'python-flake8 'python-pylint))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python — eglot (built in, Emacs 29+) instead of unmaintained elpy.
;; Needs a language server on PATH, e.g. `pip install python-lsp-server`.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package eglot
  :hook (python-mode . eglot-ensure))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :bind ("C-c m" . magit-status)
  :config
  (add-hook 'magit-mode-hook
            (lambda () (display-fill-column-indicator-mode 0))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; json
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c C-j") 'json-pretty-print)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; web-mode / rjsx-mode
;; NOTE: if you're on Emacs 29+ with tree-sitter grammars installed,
;; `js-ts-mode' / `tsx-ts-mode' are the modern built-in replacement
;; for rjsx-mode and give better highlighting for free.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package web-mode
  :mode "\\.html\\'"
  :custom
  (web-mode-enable-current-column-highlight t)
  (web-mode-enable-current-element-highlight t)
  (web-mode-engines-alist '(("django" . "/templates/.*\\.html\\'")))
  :config
  (set-face-attribute 'web-mode-html-tag-face                  nil :foreground "#509090")
  (set-face-attribute 'web-mode-html-tag-bracket-face          nil :foreground "#505050")
  (set-face-attribute 'web-mode-html-attr-name-face            nil :foreground "#90b099")
  (set-face-attribute 'web-mode-html-attr-equal-face           nil :foreground "#505050")
  (set-face-attribute 'web-mode-current-column-highlight-face  nil :background "#3E3C36")
  (set-face-attribute 'web-mode-current-element-highlight-face nil :background "#3E3C36")
  (set-face-attribute 'web-mode-block-control-face             nil :foreground "#AF0000")
  (set-face-attribute 'web-mode-block-delimiter-face           nil :foreground "#AF0000")
  (set-face-attribute 'web-mode-comment-face                   nil :foreground "#909090")
  (set-face-attribute 'web-mode-error-face                     nil :background "#900000"))

(use-package rjsx-mode
  :mode "\\.js\\'"
  :hook (rjsx-mode . (lambda ()
                        (local-set-key [f10] 'js2-previous-error)
                        (local-set-key [f11] 'js2-next-error))))

(add-to-list 'auto-mode-alist '("dot_emacs\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("dot_bash_.*\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . shell-script-mode))

;;; init.el ends here
