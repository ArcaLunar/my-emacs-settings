;;; c3.el --- c3 language -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

; INFO: manually load c3-ts-mode path
(load-file (concat user-emacs-directory "lisp/lang/c3-ts-mode/c3-ts-mode.el"))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection '("/usr/bin/c3lsp"))
  :major-modes '(c3-ts-mode)
  :activation-fn (lsp-activate-on "c3")
  :server-id 'c3lsp))

; INFO: syntax highlighting
(add-to-list 'auto-mode-alist '("\\.c3\\'" . c3-ts-mode))
(add-to-list 'auto-mode-alist '("\\.c3i\\'" . c3-ts-mode))

(setq c3-ts-mode-indent-offset 4)
(setq treesit-font-lock-level 4)

(add-to-list 'lsp-language-id-configuration
             '(c3-ts-mode . "c3"))
(setq lsp-c3-server-command '("/usr/bin/c3lsp"))

(add-hook 'c3-ts-mode-hook #'lsp-deferred)

(provide 'c3)

;;; c3.el ends here
