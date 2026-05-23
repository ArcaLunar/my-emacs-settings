(use-package company
  :ensure t
  :init (global-company-mode)

  ;; Disable company mode for markdown
  :hook
  (markdown-mode . (lambda () (company-mode -1)))
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 0.0)
  (setq company-show-numbers t)
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence)))

(provide 'completion)
