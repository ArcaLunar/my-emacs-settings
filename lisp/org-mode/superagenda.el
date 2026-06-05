;;; NOTE: Here sets up org-agenda
;; INFO: setup folder for org-agenda
(setq org-agenda-files (list (concat org-directory ".agenda/")))
;; INFO: display week's agenda
(setq org-agenda-span 7)
;; INFO: bind shortcut for calling agenda
(global-set-key (kbd "C-c a") 'org-agenda)

;;; NOTE: org-super-agenda settings
;; INFO: load plugin
(use-package org-super-agenda
  :ensure t)

(provide 'superagenda)
