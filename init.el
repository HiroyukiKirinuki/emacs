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
;; (add-to-list 'default-frame-alist '(left-fringe . 10))
                 
(set-scroll-bar-mode nil)            ; スクロールバー非表示
(setq line-spacing 0.2)              ; 行間


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


;; C-kで行全体を削除
(setq kill-whole-line t)
(define-key global-map "\C-k" 'kill-whole-line)

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

;; C-hでバックスペース
(global-set-key "\C-h" 'delete-backward-char)

;;M-y でキルリング一覧
(global-set-key "\M-y" 'anything-show-kill-ring)

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

;; spell chack
(setq-default ispell-program-name "/usr/local/bin/aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; C-Ret で矩形選択
;; 詳しいキーバインド操作：http://dev.ariel-networks.com/articles/emacs/part5/
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; カーソルで画面移動
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <right>") 'windmove-right)

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

;; 行番号表示
;;(global-linum-mode t)

;;git gutter+
(global-git-gutter+-mode t)

;; undo tree
(require 'undo-tree)
(global-undo-tree-mode t)

;; IMEの設定
(setq default-input-method "MacOSX")

(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ")

;; カーソルの色
(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `cursor-color "dark orange")
(mac-set-input-method-parameter "com.google.inputmethod.Japanese.Roman" `cursor-color "sky blue")
;;--------------------------------------------------------------
;;            google 翻訳
;;--------------------------------------------------------------
;; popwin 翻訳用
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(setq popwin:popup-window-position 'bottom)

(require 'google-translate)

(global-set-key "\C-xt" 'google-translate-at-point)
(global-set-key "\C-xT" 'google-translate-query-translate)

;; 翻訳のデフォルト値を設定(ja -> en)（無効化は C-u する）
(custom-set-variables
 '(google-translate-default-source-language "ja")
 '(google-translate-default-target-language "en"))

;; google-translate.elの翻訳バッファをポップアップで表示させる
(push '("*Google Translate*") popwin:special-display-config)


;;--------------------------------------------------------------


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

;; anzu検索時にマッチした数と位置を教える
(global-anzu-mode +1)

;;smooth scroll
(require 'smooth-scroll)
(smooth-scroll-mode t)

(global-set-key "\C-a" 'beggining-of-indented-line)
(defun beggining-of-indented-line (current-point)
  "インデント文字を飛ばした行頭に戻る。
ただし、ポイントから行頭までの間にインデント文字しかない場合は、行頭に戻る。"
  (interactive "d")
  (if (string-match
       "^[ \t]+$"
       (save-excursion
         (buffer-substring-no-properties
          (progn (beginning-of-line) (point))
          current-point)))
      (beginning-of-line)
    (back-to-indentation)))

;;anything のコマンド履歴を残す
(setq desktop-globals-to-save '(extended-command-history))
(setq desktop-files-not-to-save "")
(desktop-save-mode 1)

(defun my-anything-toggle-resplit-window ()
  (interactive)
  (when (anything-window)
    (save-selected-window
      (select-window (anything-window))
      (let ((before-height (window-height)))
        (delete-other-windows)
        (switch-to-buffer anything-current-buffer)
        (if (= (window-height) before-height)
            (split-window-vertically)
          (split-window-horizontally)))
      (select-window (next-window))
      (switch-to-buffer anything-buffer))))

(define-key anything-map "\C-o" 'my-anything-toggle-resplit-window)
(setq anything-samewindow t)
