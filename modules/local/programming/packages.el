;;; modules/local/programming/packages.el -*- lexical-binding: t; no-byte-compile: t; -*-

(when (modulep! +kdl)
  (package! kdl-mode))

(when (modulep! +koka)
  (package! koka-mode :recipe
    (:host github :repo "koka-lang/koka" :files ("support/emacs/koka-mode.el"))))

(when (modulep! +markdown)
  (package! poly-markdown))

(when (modulep! +protobuf)
  (package! protobuf-mode :recipe
    (:host github :repo "protocolbuffers/protobuf" :files ("editors/protobuf-mode.el"))))

(when (modulep! +python)
  (package! pet))

(when (modulep! +typst)
  (package! typst-ts-mode :recipe
    (:host codeberg :repo "meow_king/typst-ts-mode")))
