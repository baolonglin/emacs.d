;;; init-projectile.el --- Use Projectile for navigation within projects -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'projectile)
  (add-hook 'after-init-hook 'projectile-mode)

  ;; Shorter modeline
  (setq-default projectile-mode-line-prefix " Proj")

  ;; Try to use the alien on windows
  ;; (if *is-a-win*
  ;;     (setq projectile-indexing-method 'alien))

  (after-load 'projectile
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (setq-default
     projectile-mode-line
     '(:eval
       (if (file-remote-p default-directory)
           " Proj"
         (format " Proj[%s]" (projectile-project-name))))
     projectile-enable-caching t)
    )
  (maybe-require-package 'ibuffer-projectile))

(provide 'init-projectile)
;;; init-projectile.el ends here
