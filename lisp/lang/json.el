(use-package json-mode
  :ensure t
  :mode "\\.json\\'"
  :hook (json-mode . lsp-deferred))

(provide 'json)
