(use-package lua-mode
  :ensure t
  :mode "\\.lua\\'"
  :hook (lua-mode . lsp-deferred))

(provide 'lua)
