;;; modules/local/programming/languages/koka.el -*- lexical-binding: t; -*-

(use-package! koka-mode
  :mode "\\.kk\\'"
  :hook (koka-mode . lsp-deferred))

(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(koka-mode . "koka"))
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection '("koka" "--language-server" "--lsstdio"))
    :major-modes '(koka-mode)
    :server-id 'koka-ls)))
