(when (and (executable-find "mu4e") (require 'mu4e nil :noerror))
  ;; path to our Maildir directory
  (setq mu4e-maildir p-mu4e-maildir)

  ;; the next are relative to `mu4e-maildir'
  ;; instead of strings, they can be functions too, see
  ;; their docstring or the chapter 'Dynamic folders'
  (setq mu4e-sent-folder   "/Sent Items"
        mu4e-drafts-folder "/Drafts"
        mu4e-trash-folder  "/Trash")

  ;; a  list of user's e-mail addresses
  ;;(setq mu4e-user-mail-address-list '("foo@bar.example.com" "cuux@example.com"))

  ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'sent)

  ;; If you get your mail without an explicit command,
  ;; use "true" for the command (this is the default)
  ;;(setq mu4e-get-mail-command "offlineimap -a ")
  ;;(setq mu4e-update-interval 300)

  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t)

  ;; attempt to show images when viewing messages
  (setq mu4e-view-show-images t
        mu4e-show-images t
        mu4e-view-image-max-width 800)

  ;; sending mail -- replace USERNAME with your gmail username
  ;; also, make sure the gnutls command line utils are installed
  ;; package 'gnutls-bin' in Debian/Ubuntu
  (setq smtpmail-default-smtp-server "smtpserver") ; needs to be specified before the (require)
  (require 'smtpmail)

  ;; mu4e as default email agent in emacs
  (setq mail-user-agent 'mu4e-user-agent)
  (require 'org-mu4e)

                                        ;== M-x org-mu4e-compose-org-mode==
  (setq org-mu4e-convert-to-html t) ;; org -> html
                                        ; = M-m C-c.=

  ;; give me ISO(ish) format date-time stamps in the header list
  (setq  mu4e-headers-date-format "%Y-%m-%d %H:%M")

  ;; customize the reply-quote-string
  ;; M-x find-function RET message-citation-line-format for docs
  (setq message-citation-line-format "%N @ %Y-%m-%d %H:%M %Z:\n")
  (setq message-citation-line-function 'message-insert-formatted-citation-line)

  ;; the headers to show in the headers list -- a pair of a field
  ;; and its width, with `nil' meaning 'unlimited'
  ;; (better only use that for the last field.
  ;; These are the defaults:
  (setq mu4e-headers-fields
        '( (:date          .  25) ;; alternatively, use :human-date
           (:flags         .   6)
           (:from          .  22)
           (:subject       .  nil))) ;; alternatively, use :thread-subject


  ;; attachments go here
  (setq mu4e-attachment-dir  (concat (getenv "HOME") "/Downloads"))

  ;; smtp mail setting
  (setq message-send-mail-function 'smtpmail-send-it
        smtpmail-stream-type 'starttls
        smtpmail-default-smtp-server "smtp.office365.com"
        smtpmail-smtp-server "smtp.office365.com"
        smtpmail-smtp-service 587
        smtpmail-smtp-user p-mu4e-office365-mail-address
        ;; account info
        mu4e-reply-to-address p-mu4e-office365-mail-address
        user-mail-address p-mu4e-office365-mail-address
        user-full-name  p-mu4e-office365-mail-full-name
        ;; mu4e
        mu4e-drafts-folder "/Drafts"
        mu4e-sent-folder   "/Sent Items"
        mu4e-trash-folder  "/Trash"
        mu4e-maildir-shortcuts  '(("/INBOX"        . ?i)
                                  ("/INBOX/cc_mail". ?c)
                                  ("/Sent Items"   . ?s)
                                  ("/Trash"        . ?t)
                                  ("/All Mail"     . ?a))
        mu4e-compose-signature p-mu4e-office365-mail-signature)
  (require-package 'mu4e-alert)

  (setq mu4e-alert-interesting-mail-query "flag:unread")
  (mu4e-alert-enable-mode-line-display)
  (defun refresh-mu4e-alert-mode-line ()
    (interactive)
    (mu4e~proc-kill)
    (mu4e-alert-enable-mode-line-display)
    )
  (run-with-timer 0 60 'refresh-mu4e-alert-mode-line)
  )


(require 'gnus-dired)
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                   (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)


(provide 'init-mu4e)
