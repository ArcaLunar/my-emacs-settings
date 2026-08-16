;;; modules/local/programming/languages/typst.el -*- lexical-binding: t; -*-

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . lsp-deferred))

