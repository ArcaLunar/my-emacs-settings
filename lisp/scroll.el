;;; scroll.el --- adds smooth scrolling in GUI -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package good-scroll
  :ensure t
  :if window-system
  :init (good-scroll-mode))

(provide 'scroll)

;;; scroll.el ends here
