;;; completion.el --- Use company plugin as completion -*- lexical-binding: t -*-

;;; Commentary:
;; simply sets up for company-mode and company-box

;;; Code:

(use-package company
  :ensure t
  :init (global-company-mode)

  :config
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0)
  (setq company-show-numbers t)
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence)))

(use-package company-box
  :ensure t
  :if window-system
  :hook (company-mode . company-box-mode))

(provide 'completion)

;;; completion.el ends here
