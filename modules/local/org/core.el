;;; modules/local/org/core.el -*- lexical-binding: t; -*-

(defconst my/org-agenda-directory
  (file-name-as-directory (expand-file-name ".agenda" org-directory)))

(make-directory my/org-agenda-directory t)

(setq org-agenda-files (list my/org-agenda-directory))

(map! "C-c a" #'org-agenda)

(after! org
  (setq org-ellipsis " ▾"
        org-startup-indented t
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-highlight-latex-and-related '(native script entities)
        org-startup-with-inline-images t
        ;; Override Doom's rolling 10-day agenda with the old weekly view.
        org-agenda-span 7
        org-agenda-start-day nil
        org-agenda-start-on-weekday 1)
  ;; Doom already uses this scale; keep it explicit as part of this profile.
  (setf (plist-get org-format-latex-options :scale) 1.5))

(add-hook! 'org-mode-hook
  #'visual-line-mode
  #'prettify-symbols-mode)

(use-package! org-autolist
  :hook (org-mode . org-autolist-mode))

(use-package! org-special-block-extras
  :hook (org-mode . org-special-block-extras-mode))

(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode +1))
