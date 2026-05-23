(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown")
  (setq markdown-fontify-code-blocks-natively t))

(use-package poly-markdown
  :ensure t)

(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

(provide 'markdown)
