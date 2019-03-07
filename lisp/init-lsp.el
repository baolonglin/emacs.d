;;; init-lsp.el --- LSP support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'treemacs)
(require-package 'lsp-mode)
(require-package 'company-lsp)
(require-package 'lsp-ui)
(require-package 'dap-mode)
(when (require 'lsp-mode nil :noerror)
  (dap-mode t)
  (dap-ui-mode t)
  )

;; Java
(require-package 'lsp-java)
(after-load 'lsp
  (require 'lsp-java)
  (add-hook 'java-mode-hook 'lsp)
  )

(after-load 'lsp-java
  (require 'dap-java)
  (require 'lsp-java-treemacs)
  )

(provide 'init-lsp)
;;; init-lsp.el ends here
