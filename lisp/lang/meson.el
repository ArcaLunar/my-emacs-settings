(use-package meson-mode
  :ensure t
  :mode (("meson\\.build\\'" . meson-mode)
	 ("meson\\.options\\'" . meson-mode)
	 ("meson_options\\.txt\\'" . meson-mode))
  :hook (meson-mode . lsp-deferred))

(provide 'meson)
