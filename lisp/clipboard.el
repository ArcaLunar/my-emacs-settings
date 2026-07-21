;;; clipboard.el --- Use `xclip' for copying to clipboard -*- lexical-binding: t -*-

;;; Commentary:
;; switch to wayland's clipboard.

;;; Code:

(use-package xclip
  :ensure t
  :config
  (setq xclip-program "wl-copy")
  (setq xclip-method 'wl-copy))

(xclip-mode 1)

(provide 'clipboard)

;;; clipboard.el ends here
