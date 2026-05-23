(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x pgtk))
  :config
  (setq exec-path-from-shell-variables
	'("PATH"
	  "MANPATH"
	  "OPAM_SWITCH_PREFIX"
	  "OPAMSWITCH"
	  "CAML_LD_LIBRARY_PATH"
	  "OCAML_TOPLEVEL_PATH"))
  (exec-path-from-shell-initialize))

(provide 'shellpath)
