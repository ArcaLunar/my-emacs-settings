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
  '(".config" ".git" ".idea" ".misc" ".ref" ".roam" ".drafts"))

(defconst my/org-publish-exclude-regexp
  (concat "\\(?:^\\|/\\)"
          (regexp-opt my/org-publish-ignored-directories)
          "\\(?:/\\|$\\)"))

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

(defun my/org-root-index-file-p (path)
  "Return non-nil when PATH is the generated root index.org."
  (string-equal
   (file-truename path)
   (file-truename
    (expand-file-name "index.org" my/org-publish-base-directory))))

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
          (concat indent "- " name "\n" body))))
     ((and (file-regular-p path)
           (string-equal (file-name-extension path) "org")
           (not (my/org-root-index-file-p path)))
      (format "%s- [[file:%s][%s]]\n"
              indent
              (file-relative-name path my/org-publish-base-directory)
              (my/org-file-title path)))
     (t ""))))

(defun my/org-generate-sitemap ()
  "Generate the blog's root index.org."
  (let ((index-file
         (expand-file-name "index.org" my/org-publish-base-directory)))
    (with-temp-file index-file
      (insert "#+TITLE: My Blog\n\n")
      (insert
       (mapconcat
        (lambda (child)
          (my/org-sitemap-entry child 0))
        (my/org-publish-child-paths my/org-publish-base-directory)
        "")))))

(setq org-publish-project-alist
      `(("org-site"
         :base-directory ,my/org-publish-base-directory
         :base-extension "org"
         :publishing-directory ,my/org-publish-output-directory
         :publishing-function org-html-publish-to-html
         :recursive t
         :exclude ,my/org-publish-exclude-regexp
         :with-broken-links mark
         :with-author t
         :with-creator nil
         :section-numbers t
         :time-stamp-file nil
         :auto-sitemap nil
         :html-link-home "/"
         :html-link-up "/")
        ("org-static"
         :base-directory ,my/org-publish-base-directory
         :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|svg\\|pdf\\|webp"
         :publishing-directory ,my/org-publish-output-directory
         :publishing-function org-publish-attachment
         :recursive t
         :exclude ,my/org-publish-exclude-regexp)
        ("blog-site"
         :components ("org-site" "org-static"))))

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
