;;; shellpath.el --- loads shell PATH to Emacs -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package exec-path-from-shell
  :ensure t)

(when (memq window-system '(mac ns x pgtk))
  (exec-path-from-shell-initialize))

(when (daemonp)
  (exec-path-from-shell-initialize))

(provide 'shellpath)

;;; shellpath.el ends here
