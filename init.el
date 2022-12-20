;; ------------------------------
;; MZ EMACS Config
;; ------------------------------

;; ADD PACKAGES SOURCES

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; USER PACKAGES

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic nil) ; if nil, italics is universally disabled
  (load-theme 'doom-solarized-dark t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package flx
  :ensure t)

(use-package counsel
  :ensure t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  ;; Ivy-based interface to standard commands
  (global-set-key (kbd "C-s") 'swiper-isearch)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "<f2> j") 'counsel-set-variable)
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-c v") 'ivy-push-view)
  (global-set-key (kbd "C-c V") 'ivy-pop-view)
  (setq ivy-re-builders-alist
        '((swiper-isearch . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  :config
  ;; disable recent files
  (setq ivy-use-virtual-buffers nil))

(use-package counsel-etags
  :ensure t
  :bind (("C-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (push "build" counsel-etags-ignore-directories))

(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t)

(use-package winum
  :ensure t
  :config
  (winum-mode))

(use-package htmlize
  :ensure t)

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation
  )

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    )
  (add-hook 'web-mode-hook  'my-web-mode-hook))

;; BUILT-IN SETTINGS

;; UI
(setq echo-keystrokes 0.01) ; set time to echo keystrokes
(scroll-bar-mode -1) ; no scroll bar
(tool-bar-mode -1) ; no tool bar
(menu-bar-mode -1) ; no menu bar
(setq frame-resize-pixelwise t) ; resize gui frame pixelwise
(show-paren-mode 1) ; visualize matching parenthesees
(global-hl-line-mode 1) ; highlight current line
(setq inhibit-startup-screen 1) ; no start screen
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t) ; hiding the splash screen and banner
(setq initial-scratch-message nil)
(blink-cursor-mode 0) ; disalbe cursor blink

;; LINE NUMBERS
(global-display-line-numbers-mode 1)
(setq column-number-mode t)

;; LINE / WORD WRAP
(global-visual-line-mode t)

;; Y OR N INSTEAD OF YES-OR NO
(fset 'yes-or-no-p 'y-or-n-p)

;; NO ANNOYING BELL!
(setq ring-bell-function 'ignore)

;; FONTS
(add-to-list 'default-frame-alist
             '(font . "Hack-11"))

(set-face-attribute 'mode-line nil :font "Hack-10.5")

;; Eshell Prompt
(setq eshell-prompt-regexp "^[^#$\n]*[#$] "
      eshell-prompt-function
      (lambda nil
        (concat
     "[" (system-name) " "
     (if (string= (eshell/pwd) (getenv "HOME"))
         "~" (eshell/basename (eshell/pwd)))
     "]"
     (if (= (user-uid) 0) "# " "$ "))))

;; show trailing whitespece
;(setq-default show-trailing-whitespace t)

;; EDIT

;; ENABLE UPCASE AND DOWNCASE REGION
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; DISABLE SUSPEND FRAME UNDER GUI
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-z C-z") 'smart-suspend-frame)

(defun smart-suspend-frame ()
  "In a GUI environment, do nothing; otherwise `suspend-frame'."
  (interactive)
  (if (display-graphic-p)
      (message "suspend-frame disabled for GUI.")
    (suspend-frame)))

;; STOP CREATING ~ FILES
(setq make-backup-files nil)

;; PYTHON-SHELL
(setq python-shell-completion-native-enable nil)

;; INDENTATION
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;;(setq indent-line-function 'insert-tab)
(setq c-default-style "linux"
      c-basic-offset 4)
(c-set-offset 'comment-intro 0)

;; FILL COLUMN
(setq-default fill-column 80)

;; AUTO CLEAN TRAILING WHITESPACE
(add-hook 'before-save-hook 'whitespace-cleanup)

;;; Indentation for python

;; Ignoring electric indentation
(defun electric-indent-ignore-python (char)
  "Ignore electric indentation for python-mode"
  (if (equal major-mode 'python-mode)
      'no-indent
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-python)

;; Enter key executes newline-and-indent
(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'"
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent)

;; AUTO CLOSE BRACKET INSERTION
(electric-pair-mode 1)

;; SET THE DEFAULT WIDETH OF FILL MODE TO 80
; (setq-default fill-column 80)
; (add-hook 'prog-mode-hook 'auto-fill-mode)

;; FILL COLUMN INDICATOR
(setq-default display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

;; KILL OTHER BUFFERS
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; COMPILE COMMAND
(add-hook 'c++-mode-hook
          (lambda ()
            (unless (file-exists-p "Makefile")
              (set (make-local-variable 'compile-command)
                   (let ((file (file-name-nondirectory buffer-file-name)))
                     (format "g++ %s -o %s -lGL -lGLU -lglut"
                             file
                             (file-name-sans-extension file)))))))

;; ORG-MODE

(setq org-startup-indented t)

(add-hook
 'org-mode-hook
 (lambda ()
   (setq-local electric-pair-inhibit-predicate
               (lambda (c)
                 (if (char-equal c ?\<) t (electric-pair-default-inhibit c))))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (java . t)
   (dot . t)))

(setq org-image-actual-width nil)

(setq org-babel-python-command "python3")

(setq org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

;;; WRAP LINES IN ORG-MODE
(define-key org-mode-map "\M-q" 'toggle-truncate-lines)

;; PROLOG MODE
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

;; KEY MAP

;;; Map M-F to 'forward-to-word
(global-unset-key (kbd "M-F"))
(global-set-key (kbd "M-F") 'forward-to-word)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("51c71bb27bdab69b505d9bf71c99864051b37ac3de531d91fdad1598ad247138" default))
 '(org-agenda-files
   '("~/Documents/repos/career/2022/Interviews/Enphase/enphase_interview.org" "~/Documents/repos/career/Learning/learning.org"))
 '(package-selected-packages
   '(htmlize winum tree-sitter-langs tree-sitter counsel-etags counsel flx projectile yasnippet-snippets yasnippet flycheck markdown-mode doom-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
