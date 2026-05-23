(use-package flycheck
  :ensure t
  :config (setq truncate-lines nil)
  :hook (prog-mode . flycheck-mode))

(provide 'linter)
