;;; .emacs --- My emacs config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(add-to-list 'default-frame-alist
             '(font . "Hack Nerd Font 12"))
(set-face-attribute 'mode-line nil :font "Hack Nerd Font 10")

;; Move to top to fix package-selected-package
;; see https://github.com/jwiegley/use-package/issues/397
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

;; Use UTF8 everywhere, see https://thraxys.wordpress.com/2016/01/13/utf-8-in-emacs-everywhere-forever/
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
   (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;; Don't ask about killing process buffers on shutdown
;; https://emacs.stackexchange.com/questions/14509/kill-process-buffer-without-confirmation
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Use bash.. zsh causes slowness in projectile: https://github.com/syl20bnr/spacemacs/issues/4207
(setq shell-file-name "/bin/bash")

;; Show filename in title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; allow typing y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; enable up/down case region key shortcuts
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Bootstrap `straight.el'
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Download and set up use-package
(straight-use-package 'use-package)

(use-package windmove
  :bind
  (("M-j" . windmove-left)
  ("M-i" . windmove-up)
  ("M-k" . windmove-down)
  ("M-l" . windmove-right)))

(use-package midnight
  :config
  (midnight-mode))

(use-package subword
  :straight t
  :diminish subword-mode
  ;; need to load after diminish so it gets diminished
  :after (diminish)
  :init
  (global-subword-mode))

(use-package autorevert
  :diminish auto-revert-mode
  :config
  (global-auto-revert-mode))

(use-package semantic
  :straight t
  :init
  (semantic-mode 1))

(use-package dockerfile-mode
  :straight t
  :mode "Dockerfile\\'")

(use-package flycheck
  :straight t
  :init
  (global-flycheck-mode))

(use-package flycheck-tip
  :straight t
  :bind
  (("C-c C-n" . error-tip-cycle-dwim)
   ("C-c C-p" . error-tip-cycle-dwim-reverse))
  )

(use-package markdown-mode
  :straight t
  :mode
  (("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode)))

(use-package pkgbuild-mode
  :straight t
  :mode "/PKGBUILD$")

(use-package sh-mode
  :mode
  (("bashrc$" . sh-mode)
   ("bash_profile$" . sh-mode)
   ("bash_aliases$" . sh-mode)
   ("bash_local$" . sh-mode)
   ("bash_completion$" . sh-mode)
   ("\\.zsh" . sh-mode)
   ("runcoms/[a-zA-Z]+$" . sh-mode)))

(use-package vmd-mode
  :straight (:host github :repo "aiguofer/vmd-mode")
  :commands (vmd-mode))

(use-package coffee-mode
  :straight t)

;; (use-package swiper
;;   :straight t
;;   :bind
;;   (("C-s" . swiper)
;;    ("C-r" . swiper)))

(use-package typescript-mode
  :straight t
  :mode "\\.ts\\'")

(use-package systemd
  :straight t)

(use-package json-mode
  :straight t)

(use-package js2-mode
  :straight t
  :mode "\\.js\\'"
  :interpreter "node")

(use-package magit
  :straight t
  :commands (magit-status magit-log)
  )

(use-package forge
  :straight t
  :after magit)

(use-package magit-filenotify
  :straight t
  :commands (magit-filenotify-mode)
  :hook (magit-status-mode . magit-filenotify-mode))

(use-package sudo-edit
  :straight t)

(use-package diminish
  :straight t)

(use-package bind-key
  :straight t)

(use-package js-doc
  :straight t
  :commands (js-doc-insert-function-doc js-doc-insert-tag))

(use-package web-completion-data
  :straight t)

;; (use-package django-mode
;;   :straight t
;;   :mode
;;   (("\\.djhtml$" . django-html-mode)))

(use-package web-mode
  :straight t
  :mode
  (("\\.tpl" . web-mode)
   ("\\.php" . web-mode)
   ("\\.[agj]sp" . web-mode)
   ("\\.as[cp]x" . web-mode)
   ("\\.erb" . web-mode)
   ("\\.mustache" . web-mode)
   ("\\.ejs" . web-mode)
   ("\\.html?$" . web-mode)
   ("\\.template?" . web-mode))
  :hook (web-mode . setup-web-mode)
  :config
  (setq web-mode-engines-alist
        '(("django"    . "textmyjournal.*\\.html")
          ("ctemplate"  . "\\.template")
          ("angular"  . "tunecakes.*\\.ejs"))
        )
  (defun setup-web-mode ()
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends
                 '(company-yasnippet))
    (add-hook 'before-save-hook 'web-beautify-html-buffer t t)
    )
  )

(use-package web-beautify
  :straight t
  :commands (web-beautify-html-buffer))

(use-package prettier-js
  :straight t
  :hook ((json-mode js2-mode inferior-js-mode typescript-mode css-mode) . prettier-js-mode))

(use-package python
  :hook (inferior-python-mode . fix-python-password-entry)
  :config

  (setq python-shell-interpreter "jupyter-console"
        python-shell-interpreter-args "--simple-prompt"
        python-shell-prompt-detect-failure-warning nil)

  ;; (use-package buftra
  ;;   :straight (:host github :repo "humitos/buftra.el"))

  ;; (use-package py-pyment
  ;;   :straight (:host github :repo "humitos/py-cmd-buffer.el")
  ;;   :config
  ;;   (setq py-pyment-options '("--output=numpydoc")))

  ;; (use-package py-isort
  ;;   :straight (:host github :repo "humitos/py-cmd-buffer.el")
  ;;   :hook (python-mode . py-isort-enable-on-save)
  ;;   ;; :config
  ;;   ;; (setq py-isort-options '("-l=88" "--profile=black"))
  ;;   )

  ;; (use-package py-autoflake
  ;;   :straight (:host github :repo "humitos/py-cmd-buffer.el")
  ;;   :hook (python-mode . py-autoflake-enable-on-save)
  ;;   :config
  ;;   (setq py-autoflake-options '("--expand-star-imports")))

  ;; (use-package python-docstring
  ;;   :straight t
  ;;   :hook (python-mode . python-docstring-mode))

  (use-package elpy
    :straight t
    :bind
    (:map elpy-mode-map
          ("C-M-n" . elpy-nav-forward-block)
          ("C-M-p" . elpy-nav-backward-block))
    :hook ((elpy-mode . (lambda ()
                            (add-hook 'before-save-hook
                                      'elpy-format-code nil t)))
           (elpy-mode . flycheck-mode)
           (elpy-mode . (lambda ()
                          (set (make-local-variable 'company-backends)
                               '((elpy-company-backend :with company-yasnippet))))))
    :init
    (elpy-enable)
    :config
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    ; fix for MacOS, see https://github.com/jorgenschaefer/elpy/issues/1550
    (setq elpy-shell-echo-output nil)
    (setq elpy-rpc-python-command "python3")
    (setq elpy-rpc-timeout 2))

  (use-package jupyter
    :straight t
    :hook
    (jupyter-repl-mode . (lambda ()
                           (setq company-backends '(company-capf))))
    :bind
    (:map jupyter-repl-mode-map
          ("C-M-n" . jupyter-repl-history-next)
          ("C-M-p" . jupyter-repl-history-previous)
          ("M-n" . jupyter-repl-forward-cell)
          ("M-p" . jupyter-repl-backward-cell)
          :map jupyter-repl-interaction-mode-map
          ("M-i" . nil)
          ("C-?" . jupyter-inspect-at-point)
          )
    )

  (use-package poetry
    :straight t)
  )


(use-package lsp-mode
  :straight t
  :config

  ;; make sure we have lsp-imenu everywhere we have LSP
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

  ;; lsp extras
  (use-package lsp-ui
    :straight t
    :hook lsp-mode
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)

    (define-key lsp-ui-mode-map [remap xref-find-definitions]
      #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references]
      #'lsp-ui-peek-find-references))

  ;; completion backends
  ;; (use-package company-lsp
  ;;   :straight t
  ;;   :config
  ;;   (add-hook 'web-mode-hook
  ;;             (lambda ()
  ;;               (add-to-list (make-local-variable 'company-backends)
  ;;                            '(company-lsp))))
  ;;   )
  )

(use-package session
  :straight t
  :init
  (session-initialize))


(use-package exec-path-from-shell
  :straight t
  :init
  (exec-path-from-shell-initialize))

(use-package yasnippet
  :straight t
  :bind
  (:map yas-minor-mode-map
        ("<tab>" . nil)
        ("TAB" . nil))
  :hook (yas-before-expand-snippet . expand-for-web-mode)
  :config
  (yas-global-mode)

  (defun expand-for-web-mode ()
    (when (equal mode-name "Web")
      (make-local-variable 'yas-extra-modes)
      (setq yas--extra-modes
            (let ((web-lang (web-mode-language-at-pos)))
              (cond
               ((equal web-lang "html")       '(html-mode))
               ((equal web-lang "css")        '(css-mode))
               ((equal web-lang "javascript") '(javascript-mode))
               )))))
  )

(use-package projectile
  :straight t
  :diminish projectile-mode
  :init
  ;; this must be done before :config so we can't use :bind
  (define-key global-map (kbd "C-c p") 'projectile-command-map)
  :config
  (projectile-mode)
  (setq projectile-globally-ignored-files
        (append '("*.txt" "*.o" "*.so" "*.csv" "*.tsv" "*~" "*.orig" "*#")
                projectile-globally-ignored-files))
  )

;; (use-package helm-projectile
;;   :straight t
;;   :bind
;;   (("C-x C-f" . proj-open-file))
;;   :init
;;   (defun proj-open-file ()
;;     "Open file using projectile if in project"
;;     (interactive)
;;     (if (projectile-project-p)
;;         (helm-projectile)
;;       (helm-for-files)))
;;   :config
;;   (setq projectile-completion-system 'helm)
;;   (helm-projectile-on))

(use-package keyfreq
  :straight t
  :init
  (setq keyfreq-excluded-commands
        '(self-insert-command
          abort-recursive-edit
          forward-char
          backward-char
          previous-line
          next-line
          helm-next-line
          helm-previous-line
          helm-M-x
          newline
          proj-open-file
          save-buffer
          yank))
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (show-paren-mode 1)
  (electric-pair-mode 1))

(use-package yaml-mode
  :straight t
  :mode "\\.yml\\'")

(use-package helm-ag
  :straight t)

(use-package helm-rg
  :straight t)

(use-package ripgrep
  :straight t)

(use-package sudo-edit
  :straight t)

;; (use-package helm
;;   :straight t
;;   :diminish helm-mode
;;   :bind
;;   (("M-x" . helm-M-x)
;;    ("M-y" . helm-show-kill-ring)
;;    ("C-x b" . helm-mini)
;;    ("C-c h o" . helm-occur))
;;   :config
;;   (helm-mode)
;;   (helm-adaptive-mode))

(use-package helm-pydoc
  :straight t
  :bind
  (:map python-mode-map
        ("C-c C-d" . helm-pydoc))
  )

;; (use-package marginalia
;;   :straight t)

;; (use-package vertico
;;   :straight t
;;   :init
;;   ;; Grow and shrink the Vertico minibuffer
;;   (setq vertico-resize t)

;;   ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
;;   (setq vertico-cycle t)


;;   (let* ((path (expand-file-name "straight/repos/vertico/extensions" user-emacs-directory))
;;          (local-pkgs (mapcar 'file-name-directory (directory-files-recursively path ".*\\.el"))))
;;     (if (file-accessible-directory-p path)
;;         (Mapc (apply-partially 'add-to-list 'load-path) local-pkgs)
;;       (make-directory path :parents)))

;;   )


;; (use-package vertico-reverse
;;   :after vertico
;;   (vertico-reverse-mode))

;; ;; Optionally use the `orderless' completion style. See
;; ;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
;; ;; dispatcher. Additionally enable `partial-completion' for file path
;; ;; expansion. `partial-completion' is important for wildcard support.
;; ;; Multiple files can be opened at once with `find-file' if you enter a
;; ;; wildcard. You may also give the `initials' completion style a try.
;; (use-package orderless
;;   :straight t
;;   :init
;;   ;; Configure a custom style dispatcher (see the Consult wiki)
;;   ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
;;   ;;       orderless-component-separator #'orderless-escapable-split-on-space)
;;   (setq completion-styles '(orderless)
;;         completion-category-defaults nil
;;         completion-category-overrides '((file (styles partial-completion)))))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


(use-package tramp
  :init
  (setq tramp-default-method "ssh")
  :config
  (with-eval-after-load 'tramp '(setenv "SHELL" "/bin/bash")))

(use-package simple
  :diminish visual-line-mode
  :hook (before-save . delete-trailing-whitespace)
  :config
  (global-visual-line-mode))

(use-package linum-off
  :straight t
  :hook (find-file . my-find-file-check-make-large-file-read-only-hook)
  :config
  (global-linum-mode 1)

  (defun my-find-file-check-make-large-file-read-only-hook ()
    "If a file is over a given size, turn off nlinum and font-lock-mode."
    (if (> (buffer-size) (* 1024 1024))
        (progn (linum-mode -1)
               (font-lock-mode -1)))))

(use-package nord-theme
  :straight t
  :config
  (setq nord-region-highlight "frost")

  ;; fix from https://github.com/arcticicestudio/nord-emacs/issues/59#issuecomment-414882071
  ;; hopefully won't need this forever
  (if (daemonp)
      (cl-labels ((load-nord (frame)
                             (with-selected-frame frame
                               (load-theme 'nord t))
                             (remove-hook
                              'after-make-frame-functions
                              #'load-nord)))
        (add-hook 'after-make-frame-functions #'load-nord))
    (load-theme 'nord t)))

(use-package smart-mode-line-powerline-theme
  :straight t
  :after (nord-theme)
  :init
  (setq sml/mule-info nil)
  (setq sml/no-confirm-load-theme t)

  :config
  (sml/setup)
  (powerline-default-theme)

  (add-to-list 'sml/replacer-regexp-list
               '("^~/.pyenv/versions/\\([a-zA-Z0-9_-]+\\)/"
                 (lambda (s) (concat ":PE:" (match-string 1 s) ":")))
               t))

(use-package tide
  :straight t
  :hook ((js2-mode inferior-js-mode typescript-mode) . setup-tide-mode)
  :config
  (defun setup-tide-mode ()
    "Set up Tide mode."
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save-mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1)
    (add-to-list (make-local-variable 'company-backends)
               '(company-tide company-yasnippet)))


  (setq company-tooltip-align-annotations t)

  ;; Enable JavaScript completion between <script>...</script> etc.
  (defadvice company-tide (before web-mode-set-up-ac-sources activate)
    "Set `tide-mode' based on current language before running `company-tide'."
    (if (equal major-mode 'web-mode)
        (let ((web-mode-cur-language (web-mode-language-at-pos)))
          (if (or (string= web-mode-cur-language "javascript")
                  (string= web-mode-cur-language "jsx"))
              (unless tide-mode (tide-mode))
            (if tide-mode (tide-mode -1))))))

  )

(use-package cc-mode
  :hook ((c-initialization . make-CR-do-indent)
         (c-mode-common . c-mode-common-hook))
  :config
  (defun make-CR-do-indent ()
    (define-key c-mode-base-map "\C-m" 'c-context-line-break))

  (defun c-mode-common-hook ()
    (c-toggle-auto-hungry-state 1))
  )


(use-package minibuffer
  :hook   ((minibuffer-setup-hook . my-minibuffer-setup-hook)
           (minibuffer-exit-hook . my-minibuffer-exit-hook))
  :config
  ;; lower garbage collect thresholds in minibuffer
  ;; see http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
  (defun my-minibuffer-setup-hook ()
    (setq gc-cons-threshold most-positive-fixnum))

  (defun my-minibuffer-exit-hook ()
    (setq gc-cons-threshold 800000))
)

(use-package ibuffer
  :bind (([remap list-buffers] . ibuffer))
  :init
  (setq ibuffer-expert t)
  (setq ibuffer-fontification-alist
        (append '((1 (eq major-mode 'python-mode) font-lock-string-face)
                  (1 (eq major-mode 'fundamental-mode) green-face)
                  (1 (member major-mode '(shell-mode sh-mode shell-script-mode))
                     font-lock-function-name-face))
                ibuffer-fontification-alist)))

(use-package company
  :straight t
  :diminish company-mode
  :init
  (global-company-mode)
  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf)		; completion-at-point-functions
          (company-abbrev company-dabbrev)
          ))

  (use-package company-statistics
    :straight t
    :init
    (company-statistics-mode))

  (use-package company-web
    :straight t)

  (use-package company-try-hard
    :straight t
    :bind
    (("C-<tab>" . company-try-hard)
     :map company-active-map
     ("C-<tab>" . company-try-hard)))

  (use-package company-quickhelp
    :straight t
    :config
    (company-quickhelp-mode))
)

(use-package ignoramus
  :straight t
  :init
  (ignoramus-setup))


(use-package window
  :bind
  (("S-C-<left>" . shrink-window-horizontally)
   ("S-C-<right>" . enlarge-window-horizontally)
   ("S-C-<down>" . shrink-window)
   ("S-C-<up>" . enlarge-window)
   ))

(use-package files
  :config
  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t))))


(use-package switch-buffer-functions
  :straight t)


(use-package smart-jump
  :straight t
  :config
  (smart-jump-setup-default-registers))

(use-package docker
  :straight t
  :bind ("C-c d" . docker))

(use-package package-lint
  :straight t)

;; (use-package direnv
;;   :straight t
;;   :config
;;   (direnv-mode))

(use-package highlight-symbol
  :straight t)

;;; init.el ends here
