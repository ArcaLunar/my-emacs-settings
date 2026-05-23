(use-package catppuccin-theme
  :ensure t
  :init (setq catppuccin-flavor 'frappe)
  :hook (after-init . (lambda () (load-theme 'catppuccin))))

(provide 'theme-catppuccin)
