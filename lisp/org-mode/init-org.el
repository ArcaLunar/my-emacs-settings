(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :hook ((org-mode . visual-line-mode))
  :custom
  (org-ellipsis " ▾")
  (org-startup-indented t)
)

;; INFO: initialize org-mode settings
(setq org-hide-emphasis-markers t) ; hide grammar symbols
(global-prettify-symbols-mode 1) ; 

(setq org-src-fontify-natively t)
(setq org-highlight-latex-and-related '(latex script entities))

(provide 'init-org)
