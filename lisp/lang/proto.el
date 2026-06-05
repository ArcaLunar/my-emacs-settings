(use-package protobuf-mode
  :ensure t
  :mode "\\.proto\\'")

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(protobuf-mode . "protobuf"))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("buf" "lsp" "serve"))
    :activation-fn (lsp-activate-on "protobuf")
    :server-id 'buf-lsp)))

(add-hook 'protobuf-mode-hook #'lsp-deferred)

(provide 'proto)
