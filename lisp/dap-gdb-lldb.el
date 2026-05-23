(use-package dap-lldb
 :after dap-mode
 :custom
 (dap-lldb-debug-program '("/usr/bin/lldb"))
 ;; ask user for executable to debug if not specified explicitly (c++)
 (dap-lldb-debugged-program-function
  (lambda () (read-file-name "Select file to debug: "))))

(provide 'dap-gdb-lldb)
