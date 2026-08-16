;;; modules/local/completion/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/workspace-clone (name)
  "Clone the current Doom workspace as NAME."
  (interactive "sWorkspace name: ")
  (+workspace/new name t))

;;;###autoload
(defun my/workspace-kill-select (name)
  "Prompt for an open workspace NAME and delete it."
  (interactive
   (list (completing-read "Kill workspace: "
                          (+workspace-list-names)
                          nil t)))
  (+workspace/kill name))

