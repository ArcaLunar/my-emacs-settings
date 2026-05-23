(use-package autothemer
  :ensure t)

(use-package gruvbox-theme
  :ensure t
  :after autothemer
  :config (load-theme 'gruvbox-dark-medium t))

(provide 'gruvbox-style)
