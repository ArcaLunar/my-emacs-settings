;;; modules/local/completion/config.el -*- lexical-binding: t; -*-

;; Preserve the search behavior and presentation from the old Ivy setup.
(setq search-default-mode #'char-fold-to-regexp)

(after! vertico
  (setq vertico-count-format '("%-7s " . "(%s/%s)")))

;; Consult equivalents of the old Swiper, Ivy, and Counsel bindings.
(map! "C-s"       #'consult-line
      "C-x b"     #'consult-buffer
      "C-c v"     #'my/workspace-clone
      "C-c s"     #'+workspace/switch-to
      "C-c V"     #'my/workspace-kill-select
      "C-x C-@"   #'consult-mark
      "C-x C-SPC" #'consult-mark
      :map minibuffer-local-map
      "C-r"       #'consult-history)

(map! :after lsp-mode
      :map lsp-mode-map
      "C-c l s" #'consult-lsp-symbols)

(after! corfu
  (setq corfu-auto t))

