(use-package format-all
  :ensure t
  :hook ((prog-mode . format-all-mode))
  :bind (("C-c f" . format-all-buffer)))

(provide 'formatter)
