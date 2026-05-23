;;; OCaml major mode

;; INFO: explicitly set opam switch
(use-package tuareg
  :ensure t
  :mode (("\\.ml\\'" . tuareg-mode)
	 ("\\.mli\\'" . tuareg-mode)
	 ("\\.mly\\'" . tuareg-mode))
  :hook (tuareg-mode . lsp-deferred))

(use-package caml
  :ensure t
  :mode (("\\.ml\\'" . caml-mode)
	 ("\\.mli\\'" . caml-mode)
	 ("\\.mll\\'" . caml-mode)
	 ("\\.mly\\'" . caml-mode))
  :hook (caml-mode . lsp))

(use-package dune
  :ensure t
  :mode (("dune\\'" . dune-mode)
	 ("dune-project\\'" . dune-mode)))

(use-package merlin
  :ensure t
  :hook (caml-mode . merlin-mode)
  :custom
  (merlin-error-after-save nil))

(use-package merlin-eldoc
  :ensure t
  :hook (caml-mode . merlin-eldoc-setup))

(use-package ocp-indent
  :ensure t
  :commands ocp-indent-buffer-local
  :hook
  (caml-mode . ocp-setup-indent))

(use-package ocamlformat
  :ensure t)

;(use-package neocaml
;  :ensure t)


(add-hook 'caml-mode-hook #'font-lock-mode)

(provide 'ocaml)
