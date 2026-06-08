# LLM Wiki Claude Code Template

Obsidian 用の LLM Wiki を Claude Code で作成・更新するためのテンプレートです。

## Intended workflow

1. Claude Code に `wiki: <URL>` のようにURLを渡す
2. Claude が WebFetch でURLを読む
3. Claude が `wiki/` 配下の既存ノートを確認する
4. 新規作成・既存修正・関連リンク追加を行う
5. Git差分を確認する
6. 問題なければWindows側のObsidian Vaultへコピーする

Claude Code は Bash 実行禁止、編集範囲は `wiki/` のみです。
