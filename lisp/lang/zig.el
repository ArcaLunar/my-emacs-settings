;;; zig.el --- set up for zig syntax highlight and LSP -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package zig-mode
  :ensure t
  :mode "\\.zig\\'"
  :hook (zig-mode . lsp-deferred))

(provide 'zig)

;;; zig.el ends here
