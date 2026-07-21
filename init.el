;;; Init.el --- Load the full configuration -*- lexical-binding: t -*-

;;; Commentary:
;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; INFO: Loads `lisp' as plugin folder, recursively
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)) ; where source code are loaded
(let ((default-directory (expand-file-name "lisp" user-emacs-directory))) (normal-top-level-add-subdirs-to-load-path))

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;; INFO: Adjust garbage collection thresholds during startup, and thereafter
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; INFO: Configs for EMACS itself
(electric-pair-mode t) ; autopair
(add-hook 'prog-mode-hook #'show-paren-mode) ; highlight matching parenthese
(column-number-mode t) ; show line number
(global-auto-revert-mode t) ; auto refresh buffer
(delete-selection-mode t) ; typing after selection will delete it
(setq inhibit-startup-message t)
(setq make-backup-files nil)
(add-hook 'prog-mode-hook #'hs-minor-mode) ; codeblock folding
(global-display-line-numbers-mode 1) ; display linenumber
(when (display-graphic-p) (toggle-scroll-bar -1))
(savehist-mode 1)
(setq display-line-numbers-type 'relative)
(global-visual-line-mode 1)
(global-hl-line-mode 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; INFO: enable copying
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; INFO: Treesitter for typst for syntax highlighting
(setq treesit-language-source-alist
      '((typst "https://github.com/uben0/tree-sitter-typst")
        (odin "https://github.com/tree-sitter-grammars/tree-sitter-odin")
        (c3 "https://github.com/c3lang/tree-sitter-c3")))

;; INFO: Load MELPA, plugin collection
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; INFO: load plugins
(require 'ivy-em)
(require 'smart-jump) ; mwim, smart jump to code or line end/begin
(require 'colorful-brackets)
(require 'undotree) ; load undo-tree plugin
(require 'completion)
(require 'snippet)
(require 'markdown)
(require 'linter)
(require 'scroll)

;; INFO: project management
(require 'project-manage)
(require 'git-man) ; git manager

;; INFO: beautify mode line
(require 'mode-line)

;; INFO: OCaml ocp-indent
(require 'shellpath)

;; INFO: LSP Configuration
(require 'lsp)
(require 'lsp-haskell)
(require 'cpp)
(require 'cmake)
(require 'rust)
(require 'json)
(require 'toml)
; (require 'yaml)
(require 'fish-shell)
(require 'haskell)
(require 'bash-shell)
(require 'meson)
(require 'lua)
(require 'java)
(require 'typst)
(require 'termshell) ; adds vterm as shell emulator
(require 'ocaml)
(require 'groovy)
(require 'kotlin)
(setq lsp-pyright-langserver-command "basedpyright")
(require 'py)
(require 'proto)
(require 'zig)
(require 'odin)
(require 'c3)
; (require 'cl) ; elisp common extension
(require 'kdl) ; configuration file format for NIRI
(require 'golang)

(require 'formatter) ; formatter
(require 'clipboard) ; system clipboard

;; INFO: note system for Emacs
(require 'init-org)
; (require 'roam)
; (require 'roam-ui) ; provides visualization of org-roam, knowledge graph
(require 'todo-highlight) ; highlight tokens like info, note.
(require 'extra-org)
(require 'modern-look) ; modern look in org-mode
(require 'orgmode-vulpea); provide functions similar to org-roam
(require 'superagenda)
(require 'ox-md nil t) ; load org-export-to-markdown
(require 'refs)
(require 'latex)
(require 'autolist)

;; INFO: enable font-lock-mode globally (syntax highlight)
(global-font-lock-mode 1)
(add-hook 'bibtex-mode-hook #'font-lock-mode)

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
; (setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)
; (require 'image-tweak)
(require 'image-storage)
(require 'export-to-html) ; HTML export settings
(require 'publishing)

;; INFO: shortcuts
(require 'find-next)
(require 'whichkey)

;; INFO: auto close LSP when closing buffer
(setq lsp-keep-workspace-alive nil)

;; INFO: setup for NeoVIM plugin
(setq lsp-lua-runtime-version "LuaJIT")

;; INFO: set custom to lisp/custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; INFO: use gruvbox
; (load-theme 'doom-moonlight t)
; (load-theme 'vscode-dark-plus t)
;(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
;(catppuccin-reload)
(load-theme 'doom-moonlight t)
; (load-theme 'doom-gruvbox t)
(load-theme 'smart-mode-line-powerline t)

(provide 'init)

;;; init.el ends here
