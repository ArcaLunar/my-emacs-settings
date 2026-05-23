(use-package haskell-mode
  :ensure t
  :mode ("\\.hs\\'" "\\.lhs\\'")) ; provide syntax highight

;; Add hooks to lsp
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)

(provide 'haskell)
