# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

GitHub 上に存在するレポジトリを検索する iOS アプリです。

## 環境

- Xcode 13.2.1
- Swift 5.5

## 環境構築

前提として、Xcode と homebrew はインストールされているものとします。

#### 1. homebrew で mint をインストール

CLI は mint で管理しています。

https://github.com/yonaskolb/Mint

```sh
brew install mint
```

#### 2. mint で管理している CLI をインストール

Mintfile に書かれている CLI がインストールされます。インストールした CLI は `mint run <command名>` で実行できます。

```sh
mint bootstrap
```
