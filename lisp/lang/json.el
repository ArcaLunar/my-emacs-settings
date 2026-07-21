(use-package json-mode
  :ensure t
  :mode (("\\.json\\'" . json-mode)
         ("\\.jsonc\\'" . jsonc-mode))
  :hook ((json-mode . lsp-deferred)
         (jsonc-mode . lsp-deferred)))

(provide 'json)
