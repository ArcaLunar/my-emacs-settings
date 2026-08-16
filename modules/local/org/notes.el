;;; modules/local/org/notes.el -*- lexical-binding: t; -*-

(defconst my/org-bibliography
  (expand-file-name ".ref/references.bib" org-directory))

(defconst my/org-bibliography-library
  (file-name-as-directory (expand-file-name ".ref" org-directory)))

;; Doom's :tools biblio module connects these to Org Cite and Vertico.
(setq citar-bibliography (list my/org-bibliography)
      citar-library-paths (list my/org-bibliography-library)
      org-cite-global-bibliography (list my/org-bibliography))

(after! oc
  (setq org-cite-global-bibliography (list my/org-bibliography)))

;; Current Vulpea is standalone; Org-roam is intentionally not enabled.
(use-package! vulpea
  :after org
  :init
  (setq vulpea-db-location (doom-profile-data-dir t "vulpea.db")
        vulpea-db-sync-directories (list org-directory))
  :config
  (vulpea-db-autosync-mode +1))
