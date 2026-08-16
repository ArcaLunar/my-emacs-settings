;;; modules/local/programming/languages/cmake.el -*- lexical-binding: t; -*-

;; The built-in tree-sitter mode can bypass `cmake-mode's deferred setup, so
;; register LSP for both modes and recognize standalone CMake projects.
(after! projectile
  (add-to-list 'projectile-project-root-files "CMakeLists.txt"))

(add-hook! '(cmake-mode-hook cmake-ts-mode-hook)
  #'lsp-deferred)

