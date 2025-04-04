;; config debugging
;;(setq debug-on-error t)
;;(setq whitespace-style (remq 'indentation whitespace-style))
;; Ref
;; https://github.com/rexim/dotfiles/blob/master/.emacs
;; SHELL
(setq
 explicit-shell-file-name
 (cond
  ((eq system-type 'windows-nt)
   (let ((xlist
          (list
           "~/AppData/Local/Microsoft/WindowsApps/pwsh.exe"
           "C:/Program Files/PowerShell/7/pwsh.exe"
           "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
           )))
     (seq-some (lambda (x) (if (file-exists-p x) x nil)) xlist)))
  (t nil)))


(add-hook 'before-change-major-mode-hook (lambda () (setq indent-tabs-mode nil)))


;; Must have
(setq custom-file "~/.emacs.d/custom.el")
(setq temporary-file-directory "~/.emacs.d/tmp/")
(package-initialize)

;; MELPA
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Font
(add-to-list 'default-frame-alist `(font . "Iosevka NF-13"))

;; Theme
(use-package gruber-darker-theme
  :demand t
  :config
  (load-theme 'gruber-darker t))
;;(load-theme 'gruber-darker t)




;; Enable/Disable default emacs stuff and qol
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda () (setq indent-tabs-mode nil))) ;; disable conv spaces to tabs
;;(setq-default fill-column -1)
;;(add-hook 'magit-status-mode (setq fill-column 80))
;;(add-hook 'magit-mode (setq fill-column 80))
(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq initial-scratch-message nil)
(setq display-line-numbers-type 'relative)
(line-number-mode 1)
(column-number-mode 1)

(blink-cursor-mode 0)
(fset 'yes-or-no-p 'y-or-n-p)

(set-language-environment "UTF-8")
(put 'overwrite-mode 'disabled t)

(require 'use-package-ensure)
(setq use-package-always-ensure t)
(setq next-line-add-newlines t)


;; Mouse
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ; amout of line(s) at a time
(setq mouse-wheel-progressive-speed nil)            ; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                  ; scroll window under mouse
(setq scroll-step 1)                                ; keyboard scroll n line(s) at a time

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; ido + smex
(use-package ido
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-completing-read+
  :after ido
  :config
  (ido-ubiquitous-mode 1)
  )

(use-package smex
    :bind (
           ("M-x" . smex)
           ("C-c C-c M-x" . execute-extended-command)
         ))
;; c-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

(setq ido-show-dot-for-dired t)
;; Paredit
(use-package paredit
    :hook (
           (emacs-lisp-mode lisp-mode common-lisp-mode)
         . paredit-mode))

;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-j") 'eval-print-last-sexp)))
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))

;; Whitespacemode
(use-package whitespace
  :ensure nil
  :init
  (defvar my-whitespace-enabled-modes
    '(tuareg-mode-hook c++-mode-hook c-mode-hook simpc-mode-hook
                       emacs-lisp-mode-hook java-mode-hook lua-mode-hook rust-mode-hook
                       scala-mode-hook markdown-mode-hook haskell-mode-hook
                       python-mode-hook erlang-mode-hook asm-mode-hook fasm-mode-hook
                       go-mode-hook nim-mode-hook yaml-mode-hook porth-mode-hook)
    "List of hooks where `whitespace-mode` should be enabled.")
  :config
  (setq whitespace-style
        '(face tabs spaces trailing lines space-before-tab
               newline empty space-after-tab space-mark tab-mark newline-mark
               missing-newline-at-eof))
  (dolist (hook my-whitespace-enabled-modes)
    (add-hook hook #'whitespace-mode)))

;; Magit + transient
(use-package transient)
(use-package magit
  :after transient
  :config
  (setq magit-auto-revert-mode nil)
  :bind (("C-c m s" . magit-status)
        ("C-c m l" . magit-log)))


;; Multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))

;; Helm
(use-package helm
    :bind (("C-c h t" . helm-cmd-t)
         ("C-c h g g" . helm-git-grep)
         ("C-c h g l" . helm-ls-git)
         ("C-c h f" . helm-find)
         ("C-c h a" . helm-org-agenda-files-headings)
         ("C-c h r" . helm-recentf))
  :config
  (setq helm-ff-transformer-show-only-basename nil))

(use-package helm-git-grep)
(use-package helm-ls-git)

;; Yasnippet
(use-package yasnippet
  :config
  (setq yas-triggers-in-field nil)
  (setq yas-snippet-dirs '("~/.emacs.d/snippets/"))
  (yas-global-mode 1))

;; Word-wrap
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))

(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)

;; Company
(use-package company
  :config
  (global-company-mode))

;; Proof General
(use-package proof-general
  :hook (coq-mode . (lambda ()
                      (local-set-key (kbd "C-c C-q C-n")
                                     'proof-assert-until-point-interactive))))

;; LaTeX mode
;; (add-hook 'tex-mode-hook
;;           (lambda ()
;;             (interactive)
;;             (add-to-list 'tex-verbatim-environments "code")))

(setq font-latex-fontify-sectioning 'color)

;; Evil mode
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init)
)

;; Move Text
(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

;; LSP
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :bind
  ("C-c f" . flymake-goto-next-error)
  ("C-c b" . flymake-goto-prev-error)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  :commands (lsp lsp-deferred))


(use-package lsp-java
  :config
  (add-hook 'java-mode-hook 'lsp))


;; NOTE: to install server run:
;; (with-environment-variables
;;     (("CFLAGS"
;;       (mapconcat #'identity `("-D_GNU_SOURCE" ,(getenv "CFLAGS")) " ")))
;;   (pdf-tools-install))
(use-package pdf-tools
  ;;  :pin manual
  ;; :config
  ;; (setq-default pdf-view-display-size 'fit-page)
  :hook (pdf-view-mode . (lambda ()
                      (display-line-numbers-mode -1)
                      (pdf-view-themed-minor-mode)))
)

;; Dired
(require 'dired-x)
(use-package dired
  :ensure nil
  :config
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..+$"))
  (setq-default dired-dwim-target t)
  (setq dired-listing-switches "-alh"))

;; (use-package dired+
;;   :load-path "~/.emacs.d/packages/dired-extensions")

(use-package ls-lisp+
  :load-path "~/.emacs.d/packages/dired-extensions")

(use-package files+
  :load-path "~/.emacs.d/packages/dired-extensions")

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path '("E:/!dev/!!!cpp/"))
  (setq projectile-switch-project-action 'projectile-dired))

;; Smart comment
(use-package smart-comment
  :bind ("M-;" . smart-comment))

;; Go to last change
(use-package goto-last-change
  :bind (
         ("C-c C-o" . goto-last-change)))

;; Edit config bind
(use-package emacs
  :ensure nil
  :bind (
         ("C-c C-c e" . (lambda () (interactive) (find-file user-init-file)))
         ("C-x C-d" . dired-jump)
         ("C-x 4 C-d" . dired-jump-other-window)
         ("M-;" . smart-comment)
         ))



(load-file custom-file)
