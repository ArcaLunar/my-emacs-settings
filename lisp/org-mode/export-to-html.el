;; INFO: use css when exporting to html
(setq org-html-htmlize-output-type 'css)

;; INFO: defines a function that automatically adds some metadata
(defun my-org-add-metadata ()
  "Add file‑level metadata in a custom format (no \"#+\" prefixes).

1. Create a unique ID and store it in a :PROPERTIES: drawer at top.
2. Add/update TITLE: (base name of file).
3. Add/update DATE: with today's date (YYYY-MM-DD DayOfWeek).
4. Add/update HTML_HEAD: with link to org.css.
5. Add/update FILETAGS: (empty, but with spaces as shown).
6. Add/update DESCRIPTION: (empty)."
  (interactive)
  (unless (derived-mode-p 'org-mode)
    (user-error "Not in Org mode"))
  (unless buffer-file-name
    (user-error "Buffer not visiting a file"))

  (save-excursion
    (goto-char (point-min))

    ;; 1. PROPERTIES drawer with :ID:
    (let ((id (org-id-new)))
      (if (re-search-forward "^:PROPERTIES:\n" nil t)
          ;; Drawer exists – update or insert :ID:
          (let ((start (point)))
            (if (re-search-forward "^:ID:[ \t]+.*\n" (save-excursion (re-search-forward "^:END:\n" nil t)) t)
                (replace-match (format ":ID:       %s\n" id))
              (goto-char start)
              (insert (format ":ID:       %s\n" id))))
        ;; No drawer – create it at top
        (insert ":PROPERTIES:\n")
        (insert (format ":ID:       %s\n" id))
        (insert ":END:\n")
        (insert "\n")))   ; blank line after drawer

    ;; Helper: update or insert a plain keyword line (no "#+")
    (defun update-plain-keyword (keyword value)
      (goto-char (point-min))
      (if (re-search-forward (format "^%s:[ \t]*" keyword) nil t)
          (let ((line-start (line-beginning-position))
                (line-end (line-end-position)))
            (delete-region line-start line-end)
            (insert (format "#+%s: %s\n" keyword value)))
        (goto-char (point-max))
        (insert (format "#+%s: %s\n" keyword value))))

;    (update-plain-keyword "OPTIONS" "toc:nil")
    ;; 2. TITLE
    (update-plain-keyword "TITLE" (file-name-base buffer-file-name))
    ;; 3. DATE with weekday
    (let* ((now (current-time))
           (date-str (format-time-string "%Y-%m-%d" now))
           (weekday (format-time-string "%a" now)))
      (update-plain-keyword "DATE" (format "%s %s" date-str weekday)))
    ;; 4. HTML_HEAD
;    (update-plain-keyword "HTML_HEAD"
;      "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://arcalunar.github.io/assets/styles/style.css\"/>")
    ;; 5. FILETAGS – empty but keep formatting
    (update-plain-keyword "FILETAGS" " : :")
    ;; 6. DESCRIPTION – empty
    (update-plain-keyword "DESCRIPTION" ""))
  (vulpea-db-sync-full-scan)
  )

;; Bind to C-c r ,
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c r ,") #'my-org-add-metadata))

(provide 'export-to-html)
