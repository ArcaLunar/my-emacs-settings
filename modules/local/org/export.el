;;; modules/local/org/export.el -*- lexical-binding: t; -*-

(require 'cl-lib)

(defconst my/org-image-asset-dir
  (file-name-as-directory (expand-file-name ".assets" org-directory)))

(after! org
  (require 'ol)
  (org-link-set-parameters
   "cimg"
   :follow
   (lambda (path _)
     (find-file (expand-file-name path my/org-image-asset-dir)))
   :image-data-fun
   (lambda (_protocol path _description)
     (with-temp-buffer
       (set-buffer-multibyte nil)
       (insert-file-contents-literally
        (expand-file-name path my/org-image-asset-dir))
       (buffer-string)))
   :complete
   (lambda ()
     (concat "cimg:"
             (file-relative-name
              (read-file-name "Image: " my/org-image-asset-dir)
              my/org-image-asset-dir)))
   :export
   (lambda (path desc backend _info)
     (when (eq backend 'html)
       (format "<img src=\"/.assets/%s\" alt=\"%s\" />"
               path (or desc ""))))))

(after! ox-html
  (setq org-html-htmlize-output-type 'css
        org-html-mathjax-template
        (concat
         "<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.css\" integrity=\"sha384-1vdNCNel6Tx/NQa8IR1mGOGKsbGreCkOPfbtPPnUURJ5Tu2PRVfQ/7KLZC+Pi1p1\" crossorigin=\"anonymous\"/>\n"
         "<script defer=\"defer\" src=\"https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.js\" integrity=\"sha384-ycJ6GAwiS15LoUPipwJOrWTvkUHl/YqELValBwI5I4awP1EeEQJYarj+w85ntcz7\" crossorigin=\"anonymous\"></script>\n"
         "<script defer=\"defer\" src=\"https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/contrib/auto-render.min.js\" integrity=\"sha384-bjyGPfbij8/NDKJhSGZNP/khQVgtHUE5exjm4Ydllo42FwIgYsdLO2lXGmRBf5Mz\" crossorigin=\"anonymous\" onload=\"renderMathInElement(document.body);\"></script>")))

(defun my-org-add-metadata ()
  "Add or update standard metadata in the current Org file."
  (interactive)
  (unless (derived-mode-p 'org-mode)
    (user-error "Not in Org mode"))
  (unless buffer-file-name
    (user-error "Buffer not visiting a file"))
  (require 'org-id)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at-p "^:PROPERTIES:[ \t]*$")
        (let ((drawer-end
               (save-excursion
                 (or (re-search-forward "^:END:[ \t]*$" nil t)
                     (user-error "Unterminated file property drawer")))))
          (unless (re-search-forward "^:ID:[ \t]+.+$" drawer-end t)
            (goto-char drawer-end)
            (beginning-of-line)
            (insert (format ":ID:       %s\n" (org-id-new)))))
      (insert (format ":PROPERTIES:\n:ID:       %s\n:END:\n\n"
                      (org-id-new))))
    (cl-labels
        ((update-keyword
          (keyword value)
          (goto-char (point-min))
          (let ((case-fold-search t)
                (regexp (format "^\\(?:#\\+\\)?%s:[ \t]*.*$"
                                (regexp-quote keyword))))
            (if (re-search-forward regexp nil t)
                (replace-match (format "#+%s: %s" keyword value) t t)
              (goto-char (point-max))
              (unless (bolp) (insert "\n"))
              (insert (format "#+%s: %s\n" keyword value))))))
      (update-keyword "AUTHOR" "ArcaLunar")
      (update-keyword "TITLE" (file-name-base buffer-file-name))
      (update-keyword "DATE" (format-time-string "%Y-%m-%d %a"))
      (update-keyword "FILETAGS" " : :")
      (update-keyword "DESCRIPTION" "")))
  (when (fboundp 'vulpea-db-sync-full-scan)
    (vulpea-db-sync-full-scan)))

(map! :after org
      :map org-mode-map
      "C-c r ," #'my-org-add-metadata)
