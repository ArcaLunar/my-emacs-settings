(use-package fish-mode
  :ensure t
  :mode "\\.fish\\'"
  :hook (fish-mode . lsp-deferred))

(provide 'fish-shell)
