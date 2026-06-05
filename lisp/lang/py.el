(use-package lsp-pyright
  :ensure t
  :custom
  (lsp-pyright-langserver-command "basedpyright")
  :hook
  (python-mode . (lambda ()
		   (require 'lsp-pyright)
		   (lsp-deferred))))

(use-package pyvenv
  :ensure t
  :config (pyvenv-mode 1))

(provide 'py)
