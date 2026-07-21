;;; autolist.el --- Configs autolisting for orgmode -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package org-autolist
  :ensure t
  :hook (org-mode . org-autolist-mode))

(provide 'autolist)

;;; autolist.el ends here
