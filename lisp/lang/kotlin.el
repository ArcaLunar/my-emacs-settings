(use-package kotlin-mode
  :ensure t
  :mode ("\\.kt\\'" "\\.kts\\'")
  :hook (kotlin-mode . lsp-deferred))

(provide 'kotlin)
