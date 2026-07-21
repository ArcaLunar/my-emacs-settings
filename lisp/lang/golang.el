;;; golang.el --- setting up Golang LSP and syntax highlight -*- lexical-binding:t -*-

;;; Commentary:

;;; Code:


(defun my-go-before-save ()
  "Organize imports and format the current buffer."
  (when (bound-and-true-p lsp-mode)
    (lsp-organize-imports)
    (lsp-format-buffer)))

(defun my-go-mode-setup ()
  "Configure LSP support for the current Go buffer."
  (add-hook 'before-save-hook #'my-go-before-save nil t)
  (lsp-deferred))

(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :hook (go-mode . my-go-mode-setup))

(provide 'golang)

;;; golang.el ends here
