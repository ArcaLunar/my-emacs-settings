(use-package typst-ts-mode
  :ensure t
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . lsp-deferred))

(provide 'typst)
