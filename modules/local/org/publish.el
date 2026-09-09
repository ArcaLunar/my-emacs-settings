;;; modules/local/org/publish.el -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'org-id)
(require 'ox-html)
(require 'ox-publish)
(require 'subr-x)

(defconst my/org-publish-base-directory
  (file-name-as-directory (file-truename org-directory)))

(defconst my/org-publish-output-directory
  (file-name-as-directory
   (file-truename (expand-file-name "~/Blog/Emacs ORG Blogs/Exported/"))))

(defconst my/org-blog-html-assets
  '(("style.css" . stylesheet)
    ("index.css" . stylesheet)
    ("index.js" . script)))

(defconst my/org-publish-ignored-directories
  '(".agenda" ".config" ".git" ".idea" ".misc" ".ref" ".roam" ".drafts"))

(defconst my/org-publish-exclude-regexp
  (concat "\\(?:^\\|/\\)"
          (regexp-opt my/org-publish-ignored-directories)
          "\\(?:/\\|$\\)"))

(defconst my/org-homepage-directory-name "Homepage"
  "Name of the academic-homepage source directory, relative to `org-directory'.
Excluded from the blog's own sitemap/site/static projects; published
separately by the \"academic-site\"/\"academic-static\" projects below.")

(defconst my/org-homepage-base-directory
  (file-name-as-directory
   (expand-file-name my/org-homepage-directory-name my/org-publish-base-directory)))

(defconst my/org-site-exclude-regexp
  (concat "\\(?:^\\|/\\)"
          (regexp-opt (cons my/org-homepage-directory-name
                            my/org-publish-ignored-directories))
          "\\(?:/\\|$\\)")
  "Like `my/org-publish-exclude-regexp', but also excludes the academic
homepage source so it isn't published twice by \"org-site\".")

(defun my/org-html-preamble-fn (info)
  "Return the shared site nav for INFO.
Adds the Recently Updated / All Notes sub-tabs only when exporting the
blog's own root index.org."
  (concat
   "<p class=\"site-nav\"><a href=\"/\">Blog</a> · <a href=\"/academic/\">Academic</a></p>"
   (when (my/org-root-index-file-p (plist-get info :input-file))
     (concat
      "\n<div class=\"site-subnav\" role=\"tablist\">"
      "<button type=\"button\" class=\"site-tab is-active\" data-panel=\"recent\""
      " role=\"tab\" aria-selected=\"true\">Recently Updated</button>"
      "<button type=\"button\" class=\"site-tab\" data-panel=\"index\""
      " role=\"tab\" aria-selected=\"false\">All Notes</button>"
      "</div>"))))

(defun my/org-refresh-id-locations (&rest _ignored)
  "Refresh Org ID locations from every Org file below `org-directory'."
  (org-id-update-id-locations
   (directory-files-recursively org-directory "\\.org\\'") t))

;; Interactive exports need a current ID index for cross-file id: links.
(advice-add 'org-html-export-to-html
            :before #'my/org-refresh-id-locations)

(defun my/org-blog-html-head (input-file &optional existing-head inline)
  "Return blog asset tags for INPUT-FILE.
Embed them when INLINE is non-nil; otherwise return relative links."
  (let* ((source-directory (file-name-directory (file-truename input-file)))
         (asset-directory
          (expand-file-name ".assets/" my/org-publish-base-directory))
         (asset-prefix
          (file-name-as-directory
           (file-relative-name asset-directory source-directory))))
    (mapconcat
     (lambda (asset)
       (let ((name (car asset))
             (kind (cdr asset))
             (asset-file (expand-file-name (car asset) asset-directory)))
         (unless (and existing-head
                      (string-match-p (regexp-quote name) existing-head))
           (if inline
               (let ((contents
                      (with-temp-buffer
                        (insert-file-contents asset-file)
                        (buffer-string))))
                 (pcase kind
                   ('stylesheet
                    (format "<style type=\"text/css\">\n/* %s */\n%s\n</style>"
                            name contents))
                   ('script
                    (format "<script>\n/* %s */\n%s\n</script>"
                            name contents))))
             (pcase kind
               ('stylesheet
                (format
                 "<link rel=\"stylesheet\" type=\"text/css\" href=\"%s%s\"/>"
                 asset-prefix name))
               ('script
                (format "<script src=\"%s%s\"></script>"
                        asset-prefix name)))))))
     my/org-blog-html-assets
     "\n")))

(defun my/org-add-blog-html-head (options backend)
  "Add blog assets to HTML export OPTIONS for BACKEND."
  (let ((input-file (plist-get options :input-file)))
    (if (and input-file
             (org-export-derived-backend-p backend 'html)
             (file-in-directory-p
              (file-truename input-file)
              my/org-publish-base-directory))
        (let* ((existing-head (plist-get options :html-head))
               (blog-head
                (my/org-blog-html-head
                 input-file existing-head
                 (not (plist-get options :publishing-directory)))))
          (plist-put
           options :html-head
           (string-join
            (delq nil
                  (list
                   (unless (string-empty-p (or existing-head "")) existing-head)
                   (unless (string-empty-p blog-head) blog-head)))
            "\n")))
      options)))

(add-to-list 'org-export-filter-options-functions
             #'my/org-add-blog-html-head)

(defun my/org-mark-home-body (output backend info)
  "Tag the generated homepage's <body> so CSS can scope to it alone."
  (if (and (org-export-derived-backend-p backend 'html)
           (plist-get info :input-file)
           (my/org-root-index-file-p (plist-get info :input-file)))
      (replace-regexp-in-string
       "<body>" "<body class=\"site-home\">" output nil t)
    output))

(add-to-list 'org-export-filter-final-output-functions
             #'my/org-mark-home-body)

(defun my/org-publish-ignored-path-p (path)
  "Return non-nil when PATH belongs to an ignored directory."
  (let* ((relative
          (file-relative-name (file-truename path)
                              my/org-publish-base-directory))
         (parts (split-string relative "/" t)))
    (cl-some (lambda (part)
               (member part my/org-publish-ignored-directories))
             parts)))

(defun my/org-publish-child-paths (directory)
  "Return sorted, non-ignored children of DIRECTORY.
Files are listed before directories."
  (sort
   (cl-remove-if
    #'my/org-publish-ignored-path-p
    (directory-files directory t directory-files-no-dot-files-regexp))
   (lambda (a b)
     (let ((a-directory-p (file-directory-p a))
           (b-directory-p (file-directory-p b)))
       (if (eq a-directory-p b-directory-p)
           (string-lessp a b)
         (not a-directory-p))))))

(defun my/org-file-title (file)
  "Return FILE's #+TITLE, or its basename."
  (with-temp-buffer
    (insert-file-contents file nil 0 4096)
    (goto-char (point-min))
    (let ((case-fold-search t))
      (if (re-search-forward "^#\\+title:[ \t]*\\(.+?\\)[ \t]*$" nil t)
          (string-trim (match-string 1))
        (file-name-base file)))))

(defun my/org-file-keyword (file keyword)
  "Return the value of FILE's #+KEYWORD:, or nil."
  (with-temp-buffer
    (insert-file-contents file nil 0 4096)
    (goto-char (point-min))
    (let ((case-fold-search t))
      (when (re-search-forward
             (format "^#\\+%s:[ \t]*\\(.+?\\)[ \t]*$" (regexp-quote keyword))
             nil t)
        (string-trim (match-string 1))))))

(defun my/org-file-description (file)
  "Return FILE's #+DESCRIPTION:, or \"\"."
  (or (my/org-file-keyword file "DESCRIPTION") ""))

(defun my/org-file-date (file)
  "Return FILE's #+DATE: as a time value, falling back to its mtime."
  (let ((date (my/org-file-keyword file "DATE")))
    (or (when (and date (string-match "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}" date))
          (ignore-errors (date-to-time (match-string 0 date))))
        (file-attribute-modification-time (file-attributes file)))))

(defun my/org-root-index-file-p (path)
  "Return non-nil when PATH is the generated root index.org."
  (string-equal
   (file-truename path)
   (file-truename
    (expand-file-name "index.org" my/org-publish-base-directory))))

(defun my/org-sitemap-excluded-path-p (path)
  "Return non-nil when PATH is not blog content proper.
True for the academic homepage source and the generated root index."
  (or (my/org-root-index-file-p path)
      (file-in-directory-p (file-truename path) my/org-homepage-base-directory)))

(defun my/org-count-org-files (directory)
  "Count non-ignored, non-excluded .org files under DIRECTORY."
  (length
   (cl-remove-if
    (lambda (file)
      (or (my/org-publish-ignored-path-p file)
          (my/org-sitemap-excluded-path-p file)))
    (directory-files-recursively directory "\\.org\\'"))))

(defun my/org-collect-recent-files (&optional limit)
  "Return blog .org files sorted by date, most recent first.
Returns only the first LIMIT when given; all of them otherwise."
  (let* ((files
          (cl-remove-if
           (lambda (file)
             (or (my/org-publish-ignored-path-p file)
                 (my/org-sitemap-excluded-path-p file)))
           (directory-files-recursively my/org-publish-base-directory "\\.org\\'")))
         (sorted
          (sort files
                (lambda (a b)
                  (time-less-p (my/org-file-date b) (my/org-file-date a))))))
    (if limit (seq-take sorted limit) sorted)))

(defun my/org-post-entry (file)
  "Return a \"[[file:...][*Title*]] /date/ description\" fragment for FILE.
Shared by the \"Recently Updated\" list and the \"All Notes\" tree, so every
post gets the same card treatment wherever it's listed."
  (let ((description (my/org-file-description file)))
    (format "[[file:%s][*%s*]] /%s/%s"
            (file-relative-name file my/org-publish-base-directory)
            (my/org-file-title file)
            (format-time-string "%Y-%m-%d" (my/org-file-date file))
            (if (string-empty-p description)
                ""
              (format " @@html:<span class=\"site-desc\">@@ %s @@html:</span>@@"
                      description)))))

(defun my/org-recent-entry (file)
  "Generate one \"Recently Updated\" bullet for FILE."
  (format "- %s\n" (my/org-post-entry file)))

(defun my/org-sitemap-entry (path depth)
  "Generate a sitemap entry for PATH at DEPTH."
  (let ((indent (make-string (* 2 depth) ?\s)))
    (cond
     ((file-directory-p path)
      (let* ((name (file-name-nondirectory (directory-file-name path)))
             (body
              (mapconcat
               (lambda (child)
                 (my/org-sitemap-entry child (1+ depth)))
               (my/org-publish-child-paths path)
               "")))
        (if (string-empty-p body)
            ""
          (concat indent "- " name
                  (format " (%d)" (my/org-count-org-files path))
                  "\n" body))))
     ((and (file-regular-p path)
           (string-equal (file-name-extension path) "org")
           (not (my/org-sitemap-excluded-path-p path)))
      (format "%s- %s\n" indent (my/org-post-entry path)))
     (t ""))))

(defun my/org-generate-sitemap ()
  "Generate the blog's root index.org."
  (let ((index-file
         (expand-file-name "index.org" my/org-publish-base-directory)))
    (with-temp-file index-file
      (insert "#+TITLE: My Blog\n\n")
      (insert "#+HTML: <p class=\"site-tagline\">A running log of notes across ACM, AI/ML systems, math, and everything in between.</p>\n\n")
      ;; Which panel is shown is driven by the "Recently Updated" / "All
      ;; Notes" tabs injected into #preamble by `my/org-html-preamble-fn';
      ;; index.js toggles the `hidden' attribute to match the active tab.
      (insert "#+HTML: <section class=\"site-panel\" data-panel=\"recent\">\n")
      (insert "#+HTML: <div class=\"site-recent\">\n")
      (insert (mapconcat #'my/org-recent-entry
                         (my/org-collect-recent-files)
                         ""))
      (insert "#+HTML: </div>\n")
      (insert "#+HTML: </section>\n\n")
      (insert "#+HTML: <section class=\"site-panel\" data-panel=\"index\" hidden>\n")
      (insert "#+HTML: <input id=\"site-search\" type=\"search\" placeholder=\"Filter notes… (e.g. &quot;attention&quot;, &quot;raft&quot;)\" autocomplete=\"off\" spellcheck=\"false\" aria-label=\"Filter notes\">\n\n")
      (insert "#+HTML: <div class=\"site-index\">\n")
      (insert
       (mapconcat
        (lambda (child)
          (my/org-sitemap-entry child 0))
        (cl-remove-if
         #'my/org-sitemap-excluded-path-p
         (my/org-publish-child-paths my/org-publish-base-directory))
        ""))
      (insert "#+HTML: </div>\n")
      (insert "#+HTML: </section>\n"))))

(setq org-publish-project-alist
      `(("org-site"
         :base-directory ,my/org-publish-base-directory
         :base-extension "org"
         :publishing-directory ,my/org-publish-output-directory
         :publishing-function org-html-publish-to-html
         :recursive t
         :exclude ,my/org-site-exclude-regexp
         :with-broken-links mark
         :with-author t
         :with-creator nil
         :section-numbers t
         :time-stamp-file nil
         :auto-sitemap nil
         :html-preamble ,#'my/org-html-preamble-fn)
        ("org-static"
         :base-directory ,my/org-publish-base-directory
         :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|svg\\|pdf\\|webp\\|otf"
         :publishing-directory ,my/org-publish-output-directory
         :publishing-function org-publish-attachment
         :recursive t
         :exclude ,my/org-publish-exclude-regexp)
        ("academic-site"
         :base-directory ,my/org-homepage-base-directory
         :base-extension "org"
         :publishing-directory ,(expand-file-name
                                 "academic/" my/org-publish-output-directory)
         :publishing-function org-html-publish-to-html
         :recursive t
         :with-broken-links mark
         :with-author nil
         :with-creator nil
         :section-numbers nil
         :time-stamp-file nil
         :auto-sitemap nil
         :html-preamble ,#'my/org-html-preamble-fn)
        ("academic-static"
         :base-directory ,my/org-homepage-base-directory
         :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|svg\\|pdf\\|webp"
         :publishing-directory ,(expand-file-name
                                 "academic/" my/org-publish-output-directory)
         :publishing-function org-publish-attachment
         :recursive t)
        ("blog-site"
         :components ("org-site" "org-static" "academic-site" "academic-static"))))

(defun my/org-publish-blog (&optional force)
  "Generate the sitemap and publish the blog.
With prefix argument FORCE, republish every file."
  (interactive "P")
  (my/org-generate-sitemap)
  (my/org-refresh-id-locations)
  (org-publish-project "blog-site" force))

(defun my/org-publish-blog-force ()
  "Regenerate and force-publish the entire blog."
  (interactive)
  (my/org-generate-sitemap)
  (org-publish-remove-all-timestamps)
  (my/org-refresh-id-locations)
  (let ((org-publish-use-timestamps-flag nil))
    (org-publish-project "blog-site" t)))

(defun my/org-publish-and-deploy ()
  "Force-publish the blog, then commit and push `my/org-publish-output-directory'
to its GitHub Pages remote."
  (interactive)
  (my/org-publish-blog-force)
  (let* ((default-directory my/org-publish-output-directory)
         (run (lambda (&rest args)
                (with-temp-buffer
                  (let ((code (apply #'call-process "git" nil t nil args)))
                    (cons code (string-trim (buffer-string))))))))
    (funcall run "add" "-A")
    (if (zerop (car (funcall run "diff" "--cached" "--quiet")))
        (message "my/org-publish-and-deploy: nothing changed, nothing to deploy.")
      (let* ((commit-message
              (format-time-string "Site updated: %Y-%m-%d %H:%M:%S"))
             (commit (funcall run "commit" "-m" commit-message)))
        (if (not (zerop (car commit)))
            (message "my/org-publish-and-deploy: commit failed: %s" (cdr commit))
          (let ((push (funcall run "push" "origin" "HEAD")))
            (if (zerop (car push))
                (message "my/org-publish-and-deploy: published and pushed.")
              (message "my/org-publish-and-deploy: push failed: %s" (cdr push)))))))))
