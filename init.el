;;; Init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

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

;; INFO: enable copying
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; INFO: Treesitter for typst for syntax highlighting
(setq treesit-language-source-alist '((typst "https://github.com/uben0/tree-sitter-typst")))

;; INFO: Load MELPA, plugin collection
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


(require 'ivy-em)
(require 'smart-jump) ; mwim, smart jump to code or line end/begin
(require 'colorful-brackets)
(require 'undotree) ; load undo-tree plugin
(require 'completion)
(require 'snippet)
(require 'markdown)
; (require 'linter)

(require 'project-manage)
(require 'git-man) ; git manager

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
(require 'yaml)
(require 'fish-shell)
(require 'haskell)
(require 'bash-shell)
(require 'meson)
(require 'lua)
(require 'java)
(require 'typst)
(require 'termshell) ; adds vterm as shell emulator
(require 'ocaml)

;; INFO: note system for Emacs
(require 'init-org)
(require 'roam)
(require 'roam-ui) ; provides visualization of org-roam, knowledge graph
(require 'todo-highlight) ; highlight tokens like info, note.
(require 'extra-org)
(require 'modern-look) ; modern look in org-mode

;; INFO: auto close LSP when closing buffer
(setq lsp-keep-workspace-alive nil)

;; INFO: setup for NeoVIM plugin
(setq lsp-lua-runtime-version "LuaJIT")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   '("b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19"
     "d5fd482fcb0fe42e849caba275a01d4925e422963d1cd165565b31d3f4189c87"
     "a5a762a27f878c82bd2a3a39a283ab391dfe27ef659c9d601dfe8e13154a9857"
     "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326"
     "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
     "e7ce09ff7426c9a290d06531edc4934dd05d9ea29713f9aabff834217dbb08e4"
     "fc1275617f9c8d1c8351df9667d750a8e3da2658077cfdda2ca281a2ebc914e0"
     "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
     "c9d837f562685309358d8dc7fccb371ed507c0ae19cf3c9ae67875db0c038632"
     "fffef514346b2a43900e1c7ea2bc7d84cbdd4aa66c1b51946aade4b8d343b55a"
     "c4df9006b9eb32599d758800a32f3487c2cdf13826084511783b47d419024af2"
     "45020ff9acfe0b482e86f300717f11c6a0003270e710d3b46504e5d125cdfd67"
     "5f78a36d69bb8df702a8f6ef8dd523da044050872d3ab9bbc265dbe250d4b0e4"
     "420745d95caebf8eb989f84dc7d1806e0eb1a09353b7868671f61149516e242d"
     "5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     "45631691477ddee3df12013e718689dafa607771e7fd37ebc6c6eb9529a8ede5"
     default))
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(aircon-theme cargo catppuccin-theme chocolate-theme cmake-mode
		  company counsel-projectile doom-themes dune
		  exec-path-from-shell fish-mode flycheck
		  gruvbox-theme haskell-mode hl-todo language-id
		  lsp-haskell lsp-ivy lsp-java lua-mode magit merlin
		  merlin-eldoc meson-mode mwim ocamlformat ocp-indent
		  org-modern org-roam org-roam-ui
		  org-special-block-extras poly-markdown
		  rainbow-delimiters rust-mode smart-mode-line
		  solarized-gruvbox-theme tokyo-night toml-mode tuareg
		  typst-ts-mode undo-tree vterm yaml-mode
		  yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; INFO: use gruvbox
(load-theme 'doom-monokai-classic t)

(provide 'init)

;;; init.el ends here
