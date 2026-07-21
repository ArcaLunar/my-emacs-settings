;;; bash-shell.el --- Configs for setting LSP and syntax highlighting for Bash shell

;;; Commentary:
;; Bash shell include `.sh', `.bash', `bashrc', `.env' etc. Also adds hooks to LSP mode.

;;; Code:

(use-package sh-script
  :ensure nil
  :mode (("\\.sh\\'" . sh-mode)
	 ("\\.bash\\'" . sh-mode)
	 ("bashrc\\'" . sh-mode)
	 ("bash_profile\\'" . sh-mode)
	 ("profile\\'" . sh-mode)
	 ("\\.env\\'" . sh-mode))
  :interpreter (("bash" . sh-mode)
		("sh" . sh-mode))
  :hook (sh-mode . lsp-deferred))

(provide 'bash-shell)

;;; bash-shell.el ends here
