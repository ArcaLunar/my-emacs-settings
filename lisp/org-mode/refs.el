(setq org-bibtex-library `(, (concat org-directory ".ref/")))
(setq org-bibtex-files `(, (concat org-directory ".ref/references.bib")))

(with-eval-after-load 'org
  (setq org-cite-global-bibliography org-bibtex-files))

(use-package bibtex-completion
  :ensure t
  :custom
  (bibtex-completion-pdf-open-function
   (lambda (fpath)
     (call-process "open" nil 0 ni fpath)))
  (bibtex-completion-bibliography org-bibtex-files)
  (bibtex-completion-library-path org-bibtex-library))

(use-package org-ref
  :ensure t)

(provide 'refs)
