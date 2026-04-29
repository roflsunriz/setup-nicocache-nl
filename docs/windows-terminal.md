# Windows Terminalを開く

次のいずれかの方法でWindows Terminalを開く。

## 方法1: 「ファイル名を指定して実行」から開く

1. <kbd>Windows</kbd> + <kbd>R</kbd> を押す。
2. `wt` または `wt.exe` と入力する。
3. <kbd>Enter</kbd> を押す。

## 方法2: スタートメニューから開く

1. <kbd>Windows</kbd> キーを押す。
2. インストール済みアプリの一覧を開く。
3. `Terminal` を検索する。
4. **Terminal** をクリックする。

!!! info

      注: 最初に Windows Terminal を管理者として開いておけば、同じ管理者セッション内で
      `winget install` を実行しても都度 UAC が表示されないため便利である。

## 方法3: 「ファイル名を指定して実行」から管理者として開く

1. <kbd>Windows</kbd> + <kbd>R</kbd> を押す。
2. `wt` または `wt.exe` と入力する。
3. <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> を押す。
4. ユーザーアカウント制御（UAC）が表示されたら許可する。

## 方法4: スタートメニューから管理者として開く

1. <kbd>Windows</kbd> キーを押す。
2. インストール済みアプリの一覧を開く。
3. `Terminal` を検索する。
4. **Terminal** を右クリック。
5. **管理者として実行** を選択。
6. ユーザーアカウント制御（UAC）が表示されたら許可する。

## 方法5: Windows Terminalから管理者タブを開く

1. Windows Terminalを通常どおり開く。
2. タブバーの横にある下向き矢印（`∨`）をクリックする。
3. **PowerShell** を右クリック。
4. **管理者として実行** を選択。
5. ユーザーアカウント制御（UAC）が表示されたら許可する。