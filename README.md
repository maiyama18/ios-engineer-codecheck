# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

GitHub 上に存在するレポジトリを検索する iOS アプリです。

![app](https://user-images.githubusercontent.com/22269397/159150810-4e5b92cc-46cf-4a7b-9f46-09b82aa50c71.gif)

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

## アーキテクチャ

各画面のロジックを ViewModel が持つ MVVM アーキテクチャを採用しています。各コンポーネントの役割は以下です。

- ViewController: 画面表示に関わる細かい処理を行う。また、ライフサイクルイベントやユーザインタラクションを ViewModel に伝える
- ViewModel: 画面の主なロジックを受け持つ。Model を操作して、Combine Publisher を通じて ViewController に伝える
- Routing: 画面遷移処理を行う protocol。デフォルト実装をしておき、遷移元の ViewController に準拠させることによって容易に画面遷移の追加をできるようにする

## トラブルシューティング

#### SwiftGen

SwiftGen でビルド時にリソースをコード生成しています。リソースが生成されないなどの問題があれば SwiftGen を実行している Build Phase がうまく動いているか確認してみてください。また、以下のコマンドを打てば手動でリソースを生成し直すこともできます。

```sh
mint run swiftgen
```
