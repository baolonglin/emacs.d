;; clang-format
(require-package 'clang-format)

(defun semi-clang-format (args)
  "Format by clang-format when enter ';'."
  (interactive "*P")
  (c-electric-semi&comma args)
  (clang-format-region (line-beginning-position 0) (line-beginning-position 2))
  )

(defun brace-clang-format (args)
  "Format by clang-format when enter '}'."
  (interactive "*P")
  (c-electric-brace args)
  (let ((end-position (point))
        begin-position)
    (save-excursion
      (evil-jump-item)
      (setf begin-position (point)))
    (clang-format-region begin-position end-position))
  )

(add-hook 'c++-mode-hook
          (lambda ()
            (when (executable-find "clang-format")
              (local-set-key (kbd "C-M-\\") 'clang-format)
              (local-set-key (kbd ";")
                             'semi-clang-format)
              (local-set-key (kbd "}")
                             'brace-clang-format))))


;; rtags
;; cmake -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DCMAKE_INSTALL_PREFIX=/local/users/xxx/sfw/rtags-latest
(require-package 'rtags)
(require-package 'flycheck-rtags)
(require-package 'company-rtags)

;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  ;;(setq-local flycheck-highlighting-mode nil)
  ;;(setq-local flycheck-check-syntax-automatically nil)
  )

;; only run this if rtags is installed
(when (require 'rtags nil :noerror)
  ;; make sure you have company-mode installed
  (require 'company)
  (define-key c++-mode-map (kbd "M-.")
    (function rtags-find-symbol-at-point))
  (define-key c++-mode-map (kbd "M-,")
    (function rtags-find-references-at-point))
  ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
  ;;(define-key prelude-mode-map (kbd "C-c r") nil)
  ;; install standard rtags keybindings. Do M-. on the symbol below to
  ;; jump to definition and see the keybindings.
  (rtags-enable-standard-keybindings c++-mode-map)
  (rtags-enable-standard-keybindings c-mode-map)
  ;; comment this out if you don't have or don't use helm
  ;; (setq rtags-use-helm t)
  ;; company completion setup
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  ;; already defined in init-company.el
  ;;(global-company-mode)
  ;; disable company mode for gud-mode
  (setq company-global-modes '(not gud-mode))
  (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
  ;; use rtags flycheck mode -- clang warnings shown inline
  (require 'flycheck-rtags)
  ;; c-mode-common-hook is also called by c++-mode
  ;;(add-hook 'c-mode-hook #'setup-flycheck-rtags)
  (add-hook 'c++-mode-hook #'setup-flycheck-rtags)
  )

;; set cmake ide
;; (require-package 'cmake-ide)
;; (cmake-ide-setup)

;;(require-package 'irony)
;;
;;(add-hook 'c++-mode-hook 'irony-mode)
;;(add-hook 'c-mode-hook 'irony-mode)
;;
;;;; replace the `completion-at-point' and `complete-symbol' bindings in
;;;; irony-mode's buffers by irony-mode's function
;;(defun my-irony-mode-hook ()
;;  (define-key irony-mode-map [remap completion-at-point]
;;    'irony-completion-at-point-async)
;;  (define-key irony-mode-map [remap complete-symbol]
;;    'irony-completion-at-point-async))
;;(add-hook 'irony-mode-hook 'my-irony-mode-hook)
;;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;
;;(defun my--advice-irony-start-process (orig-func &rest args)
;;  (let ((shell-file-name "/bin/sh"))
;;    (apply orig-func args)))
;;
;;(advice-add 'irony--start-server-process :around 'my--advice-irony-start-process)
;;
;; enable which funciton mode
(add-hook 'c++-mode-hook 'which-function-mode)
(setq mode-line-format (delete (assoc 'which-func-mode
                                      mode-line-format) mode-line-format)
      mode-line-misc-info (delete (assoc 'which-func-mode
                                         mode-line-misc-info) mode-line-misc-info)
      which-func-header-line-format '(which-func-mode ("" which-func-format)))

(defadvice which-func-ff-hook (after header-line activate)
  (when which-func-mode
    (setq mode-line-format (delete (assoc 'which-func-mode
                                          mode-line-format) mode-line-format)
          mode-line-misc-info (delete (assoc 'which-func-mode
                                             mode-line-misc-info) mode-line-misc-info)
          header-line-format which-func-header-line-format)))


(require-package 'lsp-mode)
(when (require 'lsp-mode nil :noerror)
  )
(require-package 'cquery)
(when (require 'cquery nil :noerror)
  (setq cquery-executable p-cquery-executable)
  )


(provide 'init-cc)
