(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode)
  :hook (yaml-mode . lsp-deferred))

(provide 'yaml)
