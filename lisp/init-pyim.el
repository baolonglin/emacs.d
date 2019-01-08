(require-package 'chinese-pyim)
(require-package 'chinese-pyim-basedict)

(eval-after-load 'chinese-pyim
  '(progn
     (require 'chinese-pyim-basedict)
     (chinese-pyim-basedict-enable)
     ;; (require-package 'chinese-pyim-greatdict)
     ;; (chinese-pyim-greatdict-enable)

     (setq default-input-method "chinese-pyim")
     ;; 我使用全拼
     (setq pyim-default-scheme 'quanpin)
     ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
     ;; 我自己使用的中英文动态切换规则是：
     ;; 1. 光标只有在注释里面时，才可以输入中文。
     ;; 2. 光标前是汉字字符时，才能输入中文。
     ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
     (setq-default pyim-english-input-switch-functions
                   '(pyim-probe-dynamic-english
                     pyim-probe-isearch-mode
                     pyim-probe-program-mode
                     pyim-probe-org-structure-template))

     (setq-default pyim-punctuation-half-width-functions
                   '(pyim-probe-punctuation-line-beginning
                     pyim-probe-punctuation-after-punctuation))

     ;; 开启拼音搜索功能
     (setq pyim-isearch-enable-pinyin-search t)

     ;; 使用 pupup-el 来绘制选词框
     (setq pyim-page-tooltip 'popup)

     ;; 选词框显示5个候选词
     (setq pyim-page-length 5)

     ;; 让 Emacs 启动时自动加载 pyim 词库
     (add-hook 'emacs-startup-hook
               #'(lambda () (pyim-restart-1 t)))
     )
  )

(provide 'init-pyim)
