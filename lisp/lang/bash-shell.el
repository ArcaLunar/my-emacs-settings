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
