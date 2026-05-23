(use-package hl-todo
  :ensure t
  :custom
  (hl-todo-keyword-faces
   '(("TODO"       . "#E6B450")   ; 柔和橙色
     ("FIXME"      . "#FF6C6B")   ; 柔和红色
     ("INFO"       . "#61AFEF")   ; 亮蓝色
     ("NOTE"       . "#A3BE8C")   ; 柔和绿色
     ("WARNING"    . "#E5C07B")   ; 金黄色
     ("BUG"        . "#BF616A")   ; 深红色
     ("HACK"       . "#D08770")   ; 陶土色
     ("REVIEW"     . "#EBCB8B")   ; 淡金色
     ("DEPRECATED" . "#B48EAD")   ; 淡紫色
     ("XXX"        . "#E6B450"))) ; 与 TODO 同色
  :config
  (global-hl-todo-mode 1)
  (global-set-key (kbd "C-c n") 'hl-todo-next)
  (global-set-key (kbd "C-c p") 'hl-todo-previous)
  (global-set-key (kbd "C-c o") 'hl-todo-occur)
  (global-set-key (kbd "C-c g") 'hl-todo-rgrep))

(provide 'todo-highlight)
