;;; mode-line.el --- Beautify mode line -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(setq sml/theme 'respectful)

(use-package smart-mode-line
  :ensure t
  :init
  (setq sml/no-confirm-load-theme t)
  :config
  (sml/setup))

(provide 'mode-line)

;;; mode-line.el ends here
