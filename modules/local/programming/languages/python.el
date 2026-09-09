;;; modules/local/programming/languages/python.el -*- lexical-binding: t; -*-

(setq lsp-pyright-langserver-command "basedpyright")

(defun +programming-python-pet-use-basedpyright-h ()
  "Keep PET from replacing basedpyright with an unavailable pyright executable."
  (setq-local lsp-pyright-langserver-command "basedpyright"))

(use-package! pet
  :init
  (add-hook 'python-base-mode-hook #'pet-mode -10)
  (add-hook 'pet-after-buffer-local-vars-setup
            #'+programming-python-pet-use-basedpyright-h))
