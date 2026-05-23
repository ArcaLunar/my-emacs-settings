(setq org-directory (file-truename "~/org/"))

(use-package org-roam
  :ensure t
  :after org
  :init (setq org-roam-v2-ack t)
  :config (org-roam-setup)
  :custom (org-roam-directory (concat org-directory "roam.org/"))
  :bind
  (("C-c r f" . org-roam-node-find)
   (:map org-mode-map
	 (("C-c r i" . org-roam-node-insert)
	  ("C-c r o" . org-id-get-create)
	  ("C-c r t" . org-roam-tag-add)
	  ("C-c r a" . org-roam-alias-add)
	  ("C-c r l" . org-roam-buffer-toggle)))))

(provide 'roam)

