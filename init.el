;; EmacsのWindowを一番上に表示
(if (eq window-system 'ns)
    (x-focus-frame nil))

(setq load-path (cons "~/.emacs.d/elisp" load-path))

;;install-elisp のコマンドを使える様に
(require 'install-elisp)

;;Elisp ファイルをインストールする場所を指定
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;;auto complete modeの設定
(require 'auto-complete)
(global-auto-complete-mode t)

;; load environment value
(load-file (expand-file-name "~/.emacs.d/elisp/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

;;theme
(load-theme 'misterioso t)

;;font
(add-to-list 'default-frame-alist '(font . "ricty-15"))

(set-scroll-bar-mode nil)            ; スクロールバー非表示
(setq line-spacing 0.2)              ; 行間

;; 行番号表示
(global-linum-mode t)

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables '(tab-width 4))

;; フレームの透明度
(set-frame-parameter (selected-frame) 'alpha '(0.85))

;;⌘をメタキーに
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;;;スタートアップを消す
(setq inhibit-startup-screen -1)

;;; メニューバーを消す
(menu-bar-mode -1)

;;; ツールバーを消す
(tool-bar-mode -1)

;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)

;;; 現在行を目立たせる
;;;(global-hl-line-mode)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;;; カーソルの位置が何行目かを表示する
(line-number-mode t)

;;; カーソルの場所を保存する
(require 'saveplace)
(setq-default save-place t)

;;; 最終行に必ず一行挿入する
(setq require-final-newline t)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;; 自動改行をoffにする
(setq text-mode-hook 'turn-off-auto-fill)

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;; ファイル名が重複していたらディレクトリ名を追加する。
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; スペルチェック
(setq-default flyspell-mode t)
(setq ispell-dictionary "american")

;; text-modeでバッファーを開いたときに行う設定
(add-hook
 'text-mode-hook
 (lambda ()
   ;; 自動で長過ぎる行を分割する
   (auto-fill-mode 1)))


;; 最近開いたファイルを表示
(require 'recentf-ext)

;; ファイルリスト自動保存
(when (require 'recentf-ext nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1))

(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks t)

;; auto-complete-latex
(require 'auto-complete-latex)
(setq ac-l-dict-directory "~/.emacs.d/elisp/auto-complete-latex/ac-l-dict/")
  (add-to-list 'ac-modes 'latex-mode)
  (add-hook 'latex-mode-hook 'ac-l-setup)

;; 起動画面で recentf を開く
(add-hook 'after-init-hook (lambda()
    (recentf-open-files)
    ))

;; C-x C-a でanything-for-files
(define-key global-map (kbd "C-x C-a") 'anything-for-files)

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; カーソルで画面移動
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <right>") 'windmove-right)

;; redoできるようにする
;; http://www.emacswiki.org/emacs/redo+.el
(when (require 'redo+ nil t)
  (define-key global-map (kbd "C-_") 'redo))


;;auto-install
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/auto-install/"))
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)


;;add elpa package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;git gutter+
(global-git-gutter+-mode t)

;; undo tree
(require 'undo-tree)
(global-undo-tree-mode t)
;; ------------------------------------------------------------------------
;; @ initial frame maximize

;; 起動時にウィンドウ最大化
;; http://www.emacswiki.org/emacs/FullScreen#toc12
(defun jbr-init ()
  "Called from term-setup-hook after the default
   terminal setup is
   done or directly from startup if term-setup-hook not
   used.  The value
   0xF030 is the command for maximizing a window."
  (interactive)
  (w32-send-sys-command #xf030)
  (ecb-redraw-layout)
  (calendar))

(let ((ws window-system))
  (cond ((eq ws 'w32)
         (set-frame-position (selected-frame) 0 0)
         (setq term-setup-hook 'jbr-init)
         (setq window-setup-hook 'jbr-init))
        ((eq ws 'ns)
         ;; for MacBook Air(Late2010) 11inch display
         (set-frame-position (selected-frame) 0 0)
         (set-frame-size (selected-frame) 168 44))))
;;;------------------------------------------------------------------------

;; ------------------------------------------------------------------------
;; @ anything.el

;; 総合インタフェース
;; http://d.hatena.ne.jp/rubikitch/20100718/anything
(require 'anything-startup nil t)

;; ------------------------------------------------------------------------
;; ;; @ tabbar.el

;; ;; タブ化
;; ;; http://www.emacswiki.org/emacs/tabbar.el
;; ;;(require 'cl)
;; (require 'tabbar nil t)

;; ;; scratch buffer以外をまとめてタブに表示する
;; (setq tabbar-buffer-groups-function
;;       (lambda (b) (list "All Buffers")))
;; (setq tabbar-buffer-list-function
;;       (lambda ()
;;         (remove-if
;;          (lambda(buffer)
;;            (unless (string-match (buffer-name buffer)
;;                                  "\\(*scratch*\\|*Apropos*\\|*shell*\\|*eshell*\\|*Customize*\\)")
;;              (find (aref (buffer-name buffer) 0) " *"))
;;            )
;;          (buffer-list))))

;; ;; tabbarを有効にする
;; (tabbar-mode 1)

;; ;; ボタンをシンプルにする
;; (setq tabbar-home-button-enabled "")
;; (setq tabbar-scroll-right-button-enabled "")
;; (setq tabbar-scroll-left-button-enabled "")
;; (setq tabbar-scroll-right-button-disabled "")
;; (setq tabbar-scroll-left-button-disabled "")

;; ;; Ctrl-Tab, Ctrl-Shift-Tab でタブを切り替える
;; (dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
;;   (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))
;; (defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
;;   `(defun ,name (arg)
;;      (interactive "P")
;;      ,do-always
;;      (if (equal nil arg)
;;          ,on-no-prefix
;;        ,on-prefix)))
;; (defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))
;; (defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) (tabbar-mode 1))
;; (global-set-key [(control tab)] 'shk-tabbar-next)
;; (global-set-key [(control shift tab)] 'shk-tabbar-prev)

;; ;; GUIで直接ファイルを開いた場合フレームを作成しない
;; (add-hook 'before-make-frame-hook
;;           (lambda ()
;;             (when (eq tabbar-mode t)
;;               (switch-to-buffer (buffer-name))
;;               (delete-this-frame))))
;; ;;---------------------------------------------------------
