;;; cmake.el --- Configs syntax highlighting for CMake -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(provide 'cmake)

;;; cmake.el ends here
