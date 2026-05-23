(use-package lsp-java
  :ensure t
  :after lsp-mode
  :config
  (add-hook 'java-mode-hook #'lsp-deferred))

(provide 'java)
