# Claude LLM Wiki Test

Claude Code をコンテナ内で動かし、外部URLを読み込んで Obsidian 用の LLM Wiki Markdown を作成するための検証リポジトリです。

## 目的

この構成では、Claude Code に以下だけを担当させます。

* 外部URLの内容を読む
* `wiki/` 配下の既存ドキュメントを確認する
* 新規Markdown作成、または既存Markdown修正を行う
* Obsidian内部リンクを追加する
* 参照URLを記録する

一方で、以下は禁止します。

* Bashコマンドの実行
* `wiki/` 以外のファイル編集
* Docker設定や `.env` の変更
* ホスト側Obsidian Vaultへの直接書き込み

---

## ディレクトリ構成

```txt
.
├─ README.md
└─ llm-wiki-claude-code-template/
   ├─ Dockerfile
   ├─ docker-compose.yml
   ├─ .devcontainer/
   ├─ .claude/
   ├─ CLAUDE.md
   ├─ scripts/
   └─ wiki/
      ├─ 00_Index.md
      ├─ 01_LLM基礎.md
      ├─ sources/
      │  └─ used_sources.md
      └─ assets/
```

---

## 前提

以下がインストール済みであること。

* Docker Desktop
* VSCode
* VSCode Dev Containers 拡張
* Obsidian

Windows + WSL2 上で作業する想定です。

Docker / Docker Compose は Docker Desktop に含まれているため、個別インストールは不要です。

---

## 事前確認

WSL側のターミナルで以下が実行できることを確認します。

```bash
docker --version
docker compose version
```

バージョンが表示されればOKです。

---

## セットアップ手順

### 1. テンプレートディレクトリへ移動

リポジトリを clone した後、テンプレートディレクトリへ移動します。

```bash
cd llm-wiki-claude-code-template
```

---

### 2. `.env` を作成

コンテナ内で作成したファイルがホスト側で root 所有にならないように、ホストユーザーの UID/GID を渡します。

```bash
echo "UID=$(id -u)" > .env
echo "GID=$(id -g)" >> .env
```

確認します。

```bash
cat .env
```

例：

```txt
UID=1000
GID=1000
```

---

### 3. コンテナを起動

```bash
docker compose up -d --build
```

---

### 4. VSCodeで開く

```bash
code .
```

VSCodeでコマンドパレットを開きます。

```txt
Ctrl + Shift + P
```

以下を選択します。

```txt
Dev Containers: Rebuild and Reopen in Container
```

---

### 5. コンテナ内で確認

VSCodeのターミナルで以下を実行します。

```bash
whoami
id
bash scripts/check_ownership.sh
bash scripts/check_guards.sh
```

期待値：

```txt
whoami → devuser
npm registry → https://npm.flatt.tech/
```

---

## Claude Code のインストール

コンテナ内の VSCode ターミナルで実行します。

```bash
bash scripts/install_claude.sh
source ~/.bashrc
claude --version
```

---

## Git初期化

まだGit管理していない場合は、コンテナ内で以下を実行します。

```bash
git init
git add .
git commit -m "Initial LLM wiki"
```

---

## Claude Code の起動

作業前の状態を保存します。

```bash
bash scripts/git_baseline.sh
```

ターミナルログを保存しながら Claude Code を起動します。

```bash
script -f .claude-work/terminal.log
claude
```

---

## URLをWikiに反映する

Claude Code 上で、以下のように入力します。

```txt
wiki: https://example.com/article
```

Claude が WebFetch の確認を出したら、信頼できるURLの場合のみ許可します。

```txt
Do you want to allow Claude to fetch this content?

1. Yes
2. Yes, and don't ask again for example.com
3. No
```

基本は以下を選びます。

```txt
1. Yes
```

これにより、今回のURLだけ許可します。

---

## Claude Code にやらせること

`wiki: URL` を渡すと、Claude Code は以下を行います。

* URL先の記事を読む
* `wiki/` 配下の既存ドキュメントを確認する
* 新規ページ作成または既存ページ修正を判断する
* 内容を丸写しせず、要約・整理・再構成する
* Obsidian内部リンク `[[用語]]` を追加する
* 該当ページ末尾に `参考URL` を追加する
* `wiki/sources/used_sources.md` に参照URLを記録する

---

## Claude Code に禁止していること

`.claude/settings.json` と `CLAUDE.md` により、以下を禁止しています。

* Bashコマンドの実行
* `wiki/` 以外の編集
* `.env` の読み取り
* `.claude/` の変更
* `.devcontainer/` の変更
* `scripts/` の変更
* Docker関連ファイルの変更

---

## 作業後の確認

Claude Code を終了します。

```txt
/exit
```

その後、`script` も終了します。

```bash
exit
```

差分を保存します。

```bash
bash scripts/git_diff_after.sh
```

変更内容を確認します。

```bash
git diff --stat
git diff
less .claude-work/terminal.log
```

---

## Windows側Obsidianへコピー

WSL配下をそのまま Obsidian Vault として開くと、監視エラーが出る場合があります。

そのため、Claude Code の作業は WSL / コンテナ側で行い、確認後に Windows 側の Obsidian Vault へコピーします。

例：

```bash
rsync -av wiki/ /mnt/c/Users/FALCO/Documents/Obsidian/llm-wiki/
```

Obsidianでは以下のWindows側フォルダを開きます。

```txt
C:\Users\FALCO\Documents\Obsidian\llm-wiki
```

---

## 基本運用

```txt
1. Claude Codeを起動
2. wiki: URL を渡す
3. WebFetchを今回だけ許可
4. Claudeが wiki/ 配下を更新
5. git diffで確認
6. 問題なければWindows側Obsidian Vaultへコピー
7. Obsidianで閲覧
```

---

## よく使うコマンド

### コンテナ起動

```bash
docker compose up -d --build
```

### コンテナ停止

```bash
docker compose down
```

### コンテナとボリューム削除

```bash
docker compose down -v --remove-orphans
```

### 差分確認

```bash
git diff --stat
git diff
```

### Claude作業前の状態保存

```bash
bash scripts/git_baseline.sh
```

### Claude作業後の差分保存

```bash
bash scripts/git_diff_after.sh
```

---

## 注意

以下はGitHubへコミットしないでください。

```txt
.env
.claude-work/
terminal.log
node_modules/
.npm-global/
```

特に `.claude-work/terminal.log` には Claude Code とのやり取りやURLが残るため、公開しないでください。
