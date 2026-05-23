(use-package toml-mode
  :ensure t
  :mode "\\.toml\\'"
  :hook (toml-mode . lsp-deferred))

(provide 'toml)
