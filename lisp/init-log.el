(require-package 'vlf)
(require 'vlf-setup)

(require-package 'logview)

;; follow-mode to make two panes follow each other
;; view-mode make the buffer readonly

;; http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html
(defun log/narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or
defun, whichever applies first. Narrowing to
org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer
is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))

(global-set-key (kbd "C-x C-n") #'log/narrow-or-widen-dwim)

(require-package 'use-package)

;; TODO add this to log buffer
(use-package hideshow
  :bind (("C-c TAB" . hs-toggle-hiding)
         ("C-\\" . hs-toggle-hiding)
         ("M-+" . hs-show-all))
  :init (add-hook #'prog-mode-hook #'hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (setq hs-special-modes-alist
        (mapcar 'purecopy
                '((c-mode "{" "}" "/[*/]" nil nil)
                  (c++-mode "{" "}" "/[*/]" nil nil)
                  (java-mode "{" "}" "/[*/]" nil nil)
                  (js-mode "{" "}" "/[*/]" nil)
                  (json-mode "{" "}" "/[*/]" nil)
                  (javascript-mode  "{" "}" "/[*/]" nil)))))

;; keep-lines, flush-lines keep/remove lines with regex

;;
;;(use-package hl-anything
;;  :ensure t
;;  :diminish hl-highlight-mode
;;  :commands hl-highlight-mode
;;  :init
;;  (global-set-key (kbd "C-c h") 'hl-highlight-thingatpt-local)
;;  (global-set-key (kbd "C-c u") 'hl-unhighlight-all-local)
;;  (global-set-key (kbd "C-c U") 'hl-unhighlight-all-global)
;;  (global-set-key (kbd "C-c n") 'hl-find-next-thing)
;;  (global-set-key (kbd "C-c p") 'hl-find-prev-thing))


;; https://writequit.org/articles/working-with-logs-in-emacs.html
(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(defun shell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The shell is renamed to match that
directory to make multiple shell windows easier."
  (interactive)
  ;; `shell' already handles splitting, so don't do the same thing as
  ;; `eshell-here'.
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name   (car (last (split-string parent "/" t)))))
    (shell "new")
    (rename-buffer (concat "*shell: " name "*"))
    )
  )

(global-set-key (kbd "C-x !") #'eshell-here)
(global-set-key (kbd "C-x M-!") #'shell-here)

(provide 'init-log)
