;;; lsp.el --- just simply configs LSP -*- lexical-binding:t -*-

;;; Commentary:
;; package that configures LSP

;;; Code:

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap
  (setq lsp-keymap-prefix "C-c l" lsp-file-watch-threshold 500)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  (cmake-mode . lsp-deferred)
  :commands
  (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :capf)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-lua-language-server-bin "lua-language-server")

  ;; setup fish shell server
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("fish-lsp" "start"))
    :activation-fn (lsp-activate-on "fish")
    :server-id 'fish-lsp))
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol)
  :custom
  (lsp-haskell-server-path "/home/lunatic/.ghcup/bin/haskell-language-server-wrapper")
  ;; INFO: setting up ocamllsp for OCaml completion
  (lsp-ocaml-lsp-server-command '("opam" "exec" "--" "ocamllsp"))
  )

(use-package lsp-ivy
  :ensure t
  :after (lsp-mode))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable t)
  (lsp-ui-peek-enable t))

(provide 'lsp)

;;; lsp.el ends here
