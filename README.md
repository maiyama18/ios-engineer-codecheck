# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

GitHub 上に存在するレポジトリを検索する iOS アプリです。

![app](https://user-images.githubusercontent.com/22269397/159150810-4e5b92cc-46cf-4a7b-9f46-09b82aa50c71.gif)

## 環境

- Xcode 13.2.1
- Swift 5.5

基本的には上記の環境で開発していましたが、 Xcode 13.3 でビルドしても正しく動作することは確認しています。

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

各画面のロジックを ViewModel が持つ MVVM アーキテクチャを採用しています。画面遷移は UIKit で、画面内のレイアウトは SwiftUI で書いています。 各コンポーネントの役割は以下です。

- SwiftUI.View: 画面のレイアウトを行う。画面全体を担当する View は `*Screen` 、画面の中の１セクションを担当する View は `*Section` 、それ以外の View は `*View` という命名規則になっている。
- ViewController: View と ViewModel の仲介をしつつ画面表示の細かい処理を行う。View を表示しつつ、ライフサイクルイベントやユーザインタラクションを ViewModel に伝える
- ViewModel: 画面の主なロジックを受け持つ。Model を操作して、AsyncStream を通じて ViewController にイベント伝えたり `@Published` プロパティで View に表示する情報を伝えたりする
- Routing: 画面遷移処理を行う protocol。デフォルト実装をしておき、遷移元の ViewController に準拠させることによって容易に画面遷移の追加をできるようにする

## コード生成

#### SwiftGen

SwiftGen でビルド時にリソースをコード生成しています。リソースが生成されないなどの問題があれば SwiftGen を実行している Build Phase がうまく動いているか確認してみてください。また、以下のコマンドを打てば手動でリソースを生成し直すこともできます。

```sh
mint run swiftgen
```

#### Mockolo

Mockolo でビルド時にテスト用の Mock をコード生成しています。リソースが生成されないなどの問題があれば Mockolo を実行している Build Phase がうまく動いているか確認してみてください。また、以下のコマンドを打てば手動で Mock を生成することもできます。

```sh
mint run mockolo --sourcedirs GitHub --destination GitHub/Generated/GeneratedMocks.swift --enable-args-history
```

## Format & Lint

ビルド時に [swift-format](https://github.com/apple/swift-format) で format と lint をかけています。
