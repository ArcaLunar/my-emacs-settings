;;; linter.el --- Add `flycheck' as linter -*- lexical-binding: t -*-

;;; Commentary:
;; - add `truncate-lines' config to display full diagnose
;; - only enable linter in prog-mode

;;; Code:

(use-package flycheck
  :ensure t
  :config (setq truncate-lines nil)
  :hook (prog-mode . flycheck-mode))

(provide 'linter)

;;; linter.el ends here
