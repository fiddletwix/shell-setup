(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) 
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t) 
(setq vc-follow-symlinks t)
(package-initialize)
;; (package-install 'exec-path-from-shell)
;; (exec-path-from-shell-initialize)
;; (package-refresh-contents)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (py-autopep8 yaml-mode ansible flycheck elpy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'flycheck)

(flycheck-define-checker python-pyflakes
			   "A Python syntax and style checker using the pyflakes utility.

See URL `http://pypi.python.org/pypi/pyflakes'."
			   :command ("pyflakes" source-inplace)
			   :error-patterns
			   ((error line-start (file-name) ":" line ":" (message) line-end))
			   :modes python-mode)

(add-to-list 'flycheck-checkers 'python-pyflakes)

(provide 'flycheck-pyflakes)
;;; flycheck-pyflakes.el ends here
(elpy-enable)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
