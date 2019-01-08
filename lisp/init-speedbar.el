(require-package 'sr-speedbar)
(require 'sr-speedbar)

(sr-speedbar-open)

;; customize speedbar
(setq sr-speedbar-width-x 20)

;; no image
(setq speedbar-use-images nil)

;; set speedbar font
;;(make-face 'speedbar-face)
;;(set-face-font 'speedbar-face "Inconsolata-12")
;;(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))

;; avoid close speedbar window
(defadvice delete-other-windows (after my-sr-speedbar-delete-other-window-advice activate)
  "Check whether we are in speedbar, if it is, jump to next window."
  (let ()
    (when (and (sr-speedbar-window-exist-p sr-speedbar-window)
               (eq sr-speedbar-window (selected-window)))
      (other-window 1)
      )))
(ad-enable-advice 'delete-other-windows 'after 'my-sr-speedbar-delete-other-window-advice)
(ad-activate 'delete-other-windows)

(provide 'init-speedbar)
