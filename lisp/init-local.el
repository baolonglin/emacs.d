;;; init-local.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; General settings
(setq calendar-week-start-day 1)
(setq truncate-lines t)

;;(require 'init-speedbar)
;;(require 'init-ztree)
;;(require 'init-pyim)
;;(require 'init-gtags)

;;(setq private-custom-file (expand-file-name ".custom.el" user-emacs-directory))
;;(when (file-exists-p private-custom-file)
;;  (load private-custom-file))

(require-package 'yasnippet)
(when (require 'yasnippet nil :noerror)
  (yas-global-mode 1)
  )

(require-package 'magit-gerrit)
(after-load 'magit
  (require 'magit-gerrit)
  )

(require 'init-lsp)
(require 'init-cc)

(require-package 'paradox)
(require-package 'epresent)
(require-package 'dictionary)

;;(require 'init-mu4e)

(require-package 'cmake-mode)
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))

;; Change mode line
(require-package 'rich-minority)
(rich-minority-mode 1)
(setf rm-blacklist "")
(defface egoge-display-time
  '((((type x w32 mac))
     ;; #060525 is the background colour of my default face.
     (:foreground "#060525" :inherit bold))
    (((type tty))
     (:foreground "blue")))
  "Face used to display the time in the mode line.")
(setq display-time-string-forms
      '((propertize (concat " " 24-hours ":" minutes " ")
                    'face 'egoge-display-time)))
(display-time-mode)

(require-package 'elfeed)
(after-load 'elfeed
  (setq elfeed-feeds p-elfeed-feeds)
  )

(if *is-a-win*
    (add-to-list 'default-frame-alist '(font . "Lucida Console-10"))
  (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))
  )


(require 'init-log)
(require 'init-bb)

(require-package 'xclip)
(after-load 'xclip
  (xclip-mode t))

(provide 'init-local)
;;; init-local.el ends here
