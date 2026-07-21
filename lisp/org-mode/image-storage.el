;;; image-storage.el --- sets up a centralized storage for images -*- lexical-binding:t -*-

;;; Commentary:

;;; Code:
(require 'ol)

(defconst my/org-image-asset-dir
  (expand-file-name "~/org/.assets/"))

(org-link-set-parameters
 "cimg"
 :follow
 (lambda (path _)
   (find-file (expand-file-name path my/org-image-asset-dir)))

 :image-data-fun
 (lambda (_protocol path _description)
   (with-temp-buffer
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
   (cond
    ((eq backend 'html)
     (format "<img src=\"/.assets/%s\" alt=\"%s\" />"
             path
             (or desc "")))
    (t nil))))


(provide 'image-storage)

;;; image-storage.el ends here
