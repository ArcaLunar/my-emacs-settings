;;; publishing.el --- setup for publishing org files as HTML -*- lexical-binding: t -*-

(require 'ox-publish)
(require 'ox-html)
(require 'cl-lib)
(require 'subr-x)
(require 'org-id)

(defconst my/org-publish-base-directory
  (file-truename (expand-file-name "~/org/")))

(defconst my/org-publish-output-directory
  (file-truename (expand-file-name "~/Blog/emacs-orgs-blog/")))

(defconst my/org-publish-ignored-directories
  '(".config" ".git" ".idea" ".misc" ".ref" ".roam" ".drafts"))

(defconst my/org-publish-exclude-regexp
  (concat "\\(?:^\\|/\\)"
          (regexp-opt my/org-publish-ignored-directories)
          "\\(?:/\\|$\\)"))

(defun my/org-publish-ignored-path-p (path)
  "Return non-nil if PATH should be ignored."
  (let* ((relative (file-relative-name
                    (file-truename path)
                    my/org-publish-base-directory))
         (parts (split-string relative "/" t)))
    (cl-some
     (lambda (part)
       (member part my/org-publish-ignored-directories))
     parts)))

(defun my/org-publish-child-paths (dir)
  "Return sorted children of DIR, excluding ignored paths.
Files are listed before directories."
  (sort
   (cl-remove-if
    #'my/org-publish-ignored-path-p
    (directory-files dir t directory-files-no-dot-files-regexp))
   (lambda (a b)
     (let ((a-dir (file-directory-p a))
           (b-dir (file-directory-p b)))
       (if (eq a-dir b-dir)
           (string-lessp a b)
         (not a-dir))))))

(defun my/org-file-title (file)
  "Return #+TITLE of FILE, or its basename."
  (with-temp-buffer
    (insert-file-contents file nil 0 4096)
    (goto-char (point-min))
    (let ((case-fold-search t))
      (if (re-search-forward "^#\\+title:[ \t]*\\(.+?\\)[ \t]*$" nil t)
          (string-trim (match-string 1))
        (file-name-base file)))))

(defun my/org-root-index-file-p (path)
  "Return non-nil if PATH is the generated root index.org."
  (string-equal
   (file-truename path)
   (file-truename
    (expand-file-name "index.org" my/org-publish-base-directory))))

(defun my/org-sitemap-entry (path depth)
  "Generate sitemap entry for PATH at DEPTH."
  (let ((indent (make-string (* 2 depth) ?\s)))
    (cond
     ((file-directory-p path)
      (let* ((name (file-name-nondirectory
                    (directory-file-name path)))
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
  "Generate root index.org manually."
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
         :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/.assets/style.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"/.assets/index.css\"/>
<script src=\"/.assets/index.js\"></script>"
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
  "Generate index.org, then publish the blog with org-publish.

With prefix argument FORCE, force republishing all files."
  (interactive "P")
  (my/org-generate-sitemap)
  (org-id-update-id-locations
   (directory-files-recursively my/org-publish-base-directory "\\.org\\'"))
  (org-publish-project "blog-site" force))

(defun my/org-publish-blog-force ()
  "Force republish the entire blog with org-publish."
  (interactive)
  (my/org-generate-sitemap)
  (org-publish-remove-all-timestamps)
  (org-id-update-id-locations
   (directory-files-recursively my/org-publish-base-directory "\\.org\\'"))
  (let ((org-publish-use-timestamps-flag nil))
    (org-publish-project "blog-site" t)))

(provide 'publishing)
