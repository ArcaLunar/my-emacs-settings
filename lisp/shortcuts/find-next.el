(use-package avy
  :ensure t)

(setq avy-timeout-seconds 1)

					; search next occurence by 1 char
(global-set-key (kbd "C-;") 'avy-goto-char)
					; search next occurence by 2 chars
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "C-.") 'avy-goto-char-timer)

(global-set-key (kbd "M-g l") 'avy-goto-line)

(global-set-key (kbd "M-g w") 'avy-goto-word-0)


(provide 'find-next)
