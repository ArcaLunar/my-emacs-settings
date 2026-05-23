;;; undo-tree is a plugin that manages editing history as a tree
;;;
;;; In short:
;;;    C-_ C-/ -> undo changes
;;;    M-_ C-? -> redo changes
;;;    `undo-tree-switch-branch' switch branch
;;;    C-x u -> visualize undo-tree
;;;    C-x r u
;;; In visualizer:
;;;   <up> or p or C-p => undo changes
;;;   <down> or n or C-n => redo changes
;;;   <left> or b or C-b => switch to previous undo-tree branch
;;;   <right> or f or C-f =>
;;;   d => toggle diff display
;;;   q => quit visualizer
;;;   , => scroll left
;;;   . => scroll right
;;;   M-v => scroll up
;;;   C-v => scroll down

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :custom (undo-tree-auto-save-history nil))

(provide 'undotree)
