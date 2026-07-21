;;; markdown.el --- configures markdown support -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :hook (markdown-mode . lsp)
  :init
  (setq markdown-command "multimarkdown")
  (setq markdown-fontify-code-blocks-natively t)
  :config
  (require 'lsp-marksman))

(use-package poly-markdown
  :ensure t)

(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

(provide 'markdown)

;;; markdown.el ends here
