;;; modules/local/programming/languages/cuda.el -*- lexical-binding: t; -*-

;; `lsp-mode' knows about `cuda-mode', but not its tree-sitter counterpart.
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(cuda-ts-mode . "cuda")))
