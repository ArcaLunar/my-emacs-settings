;;; odin.el --- setup for odin -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(load-file (concat user-emacs-directory "lisp/" "lang/" "odin-ts-mode/" "odin-ts-mode.el"))
(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-ts-mode))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
	       '(odin-ts-mode . "odin"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "ols")
    :major-modes '(odin-ts-mode)
    :server-id 'ols)))

(add-hook 'odin-ts-mode-hook #'lsp-deferred)

(provide 'odin)

;;; odin.el ends here
