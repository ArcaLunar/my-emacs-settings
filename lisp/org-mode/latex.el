;;; latex.el --- configure LATEX in orgmode -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package cdlatex
  :ensure t)

(use-package org
  :hook (org-mode . org-cdlatex-mode))

(use-package tex
  :ensure auctex
  :defer t)

(provide 'latex)

;;; latex.el ends here
