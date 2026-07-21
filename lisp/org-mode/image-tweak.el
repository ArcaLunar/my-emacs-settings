(with-eval-after-load 'org
  (add-to-list 'org-inline-image-rules
	       '("attachment" . "\\.\\(webp\\|png\\|jpg\\|jpeg\\|gif\\|svg\\)\\'")))

(provide 'image-tweak)
