# 🍱 Lunch Stamp（お昼ごはんスタンプラリー）

**ランチ選びのマンネリを、スタンプラリー感覚で楽しく解決するWebアプリです。**

Lunch Stampは、都内オフィスワーカー向けに、人形町エリアの飲食店検索と訪問記録を提供するRailsアプリです。  
Hotpepper APIで店舗情報を取得し、訪問したお店を記録することで、日々のランチ開拓をゲーム感覚で楽しめます。

<br>

## 🌐 アプリURL & 動作確認用テストアカウント

**本番環境URL**: https://lunch-stamp.onrender.com

選考担当者様がすぐに動作確認できるよう、テストアカウントを用意しています。

| アカウント種別 | メールアドレス | パスワード | 確認できる機能 |
| :--- | :--- | :--- | :--- |
| **一般ユーザー** | `test@example.com` | `password` | 店舗検索、訪問済み登録 / 解除、マイページ |
| **管理者ユーザー** | 個別共有 | 個別共有 | 管理者画面、監査ログ、CSV出力 |

> 一般テストユーザーには、あらかじめ訪問履歴データを登録しています。
> ログイン後すぐにマイページの統計情報をご確認いただけます。
>
> 管理者アカウントは監査ログやユーザー情報を扱うため、ログイン情報は公開READMEには記載していません。
> 必要に応じて選考時に個別共有、または面接時に画面共有でご説明可能です。

<br>

---

## 💡 開発背景と明確なストーリー

### 1. 日常のランチ選びにおける課題

社会人になってから、毎日のランチで同じお店ばかりに行ってしまうことに気付きました。

職場周辺には多くの飲食店があるにもかかわらず、  
「どこに行くか考えるのが面倒」  
「前に行ったお店を覚えていない」  
「新しいお店に行くきっかけがない」  
という課題を感じていました。

そこで、ランチ店探しを単なる検索ではなく、訪問記録や達成率を通して楽しめる仕組みにすることで、日常のランチを少し楽しくできると考え、このアプリを作成しました。

### 2. SIEM製品の営業経験を活かした設計

私は現在、**SIEM（セキュリティ情報イベント管理）製品のIT営業**に従事しています。

日々の業務で多くの企業様と対話する中で、内部不正対策やセキュリティ監査において、  
「いつ、誰が、何をしたのか」  
を追跡できるログ管理の重要性を強く実感してきました。

この経験を活かし、Lunch Stampにも単なるCRUD機能だけでなく、商用アプリケーションを意識した **認証・認可・監査ログ機能** を実装しています。

具体的には、以下のような点を意識しました。

- Strong Parametersによる不正なパラメータ更新の防止
- 管理者権限によるアクセス制御
- ログイン / ログアウト / 訪問登録 / 訪問解除などの重要操作の記録
- 監査ログCSV出力時のCSV Injection対策

<br>

---

## 📊 主要機能一覧

<table>
  <thead>
    <tr>
      <th width="20%">機能名</th>
      <th width="50%">機能概要</th>
      <th width="30%">使用技術・実装ポイント</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>認証機能</b></td>
      <td>ユーザー登録、ログイン、ログアウト、セッション管理を行います。Remember me によりログイン状態の保持にも対応しています。</td>
      <td><code>has_secure_password</code><br>BCrypt / session / cookies</td>
    </tr>
    <tr>
      <td><b>アカウント有効化</b></td>
      <td>ユーザー登録後、メール内のリンクからアカウントを有効化します。</td>
      <td>Action Mailer<br>SendGrid Web API<br>activation_digest</td>
    </tr>
    <tr>
      <td><b>パスワード再設定</b></td>
      <td>メール経由でパスワード再設定リンクを送信し、有効期限内のみ再設定できるようにしています。</td>
      <td>Action Mailer<br>reset_digest / reset_sent_at</td>
    </tr>
    <tr>
      <td><b>店舗検索</b></td>
      <td>Hotpepper APIと連携し、人形町エリアの飲食店をキーワード・ジャンル・予算で検索できます。</td>
      <td>Hotpepper API<br><code>Net::HTTP</code><br>Rails credentials</td>
    </tr>
    <tr>
      <td><b>店舗詳細</b></td>
      <td>店舗画像、住所、ジャンル、予算、外部URLなどを表示します。</td>
      <td>Hotpepper API<br><code>dig</code>メソッドによるnil安全アクセス</td>
    </tr>
    <tr>
      <td><b>訪問記録</b></td>
      <td>店舗を「訪問済み」として記録できます。1ユーザー × 1店舗につき1記録のみ作成できるようにしています。</td>
      <td>Restaurant / Visit<br>多対多関係<br>Unique index</td>
    </tr>
    <tr>
      <td><b>マイページ</b></td>
      <td>訪問済み店舗数、達成率、最近の訪問履歴を確認できます。</td>
      <td>Active Record Association<br><code>includes</code>によるN+1対策</td>
    </tr>
    <tr>
      <td><b>管理者画面</b></td>
      <td>管理者のみユーザー一覧を確認できます。一般ユーザーはアクセスできないように制御しています。</td>
      <td><code>namespace :admin</code><br><code>admin_user</code> before_action</td>
    </tr>
    <tr>
      <td><b>監査ログ</b></td>
      <td>ログイン、ログアウト、訪問登録、訪問解除などの重要操作を記録します。</td>
      <td>AuditLogモデル<br>IPアドレス / User-Agent取得</td>
    </tr>
    <tr>
      <td><b>CSV出力</b></td>
      <td>管理者のみ監査ログをCSVでダウンロードできます。</td>
      <td><code>CSV.generate</code><br>CSV Injection対策</td>
    </tr>
  </tbody>
</table>

<br>

---

## 🔐 セキュリティ・非機能面で意識したこと

<table>
  <thead>
    <tr>
      <th width="25%">項目</th>
      <th width="50%">実装内容</th>
      <th width="25%">目的・防ぐリスク</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>パスワード管理</b></td>
      <td><code>has_secure_password</code> と BCrypt を使用し、パスワードをハッシュ化して保存。</td>
      <td>パスワードを平文保存しないため</td>
    </tr>
    <tr>
      <td><b>セッション固定攻撃対策</b></td>
      <td>ログイン成功時に <code>reset_session</code> を実行。</td>
      <td>ログイン前後でセッションIDを固定されるリスクを下げるため</td>
    </tr>
    <tr>
      <td><b>Remember me</b></td>
      <td>remember_tokenはDBに平文保存せず、digest化して保存。</td>
      <td>トークン漏洩時のリスクを下げるため</td>
    </tr>
    <tr>
      <td><b>認可制御</b></td>
      <td><code>logged_in_user</code> / <code>correct_user</code> / <code>admin_user</code> によるアクセス制限。</td>
      <td>URL直打ちによる不正アクセスや他人のデータ編集を防ぐため</td>
    </tr>
    <tr>
      <td><b>Mass Assignment対策</b></td>
      <td>Strong Parametersで許可する属性を限定。<code>admin</code> カラムは許可しない設計。</td>
      <td>一般ユーザーが管理者権限を不正に取得できないようにするため</td>
    </tr>
    <tr>
      <td><b>管理者機能の保護</b></td>
      <td><code>admin</code> フラグはアプリ画面から変更不可。</td>
      <td>管理者権限の不正付与を防ぐため</td>
    </tr>
    <tr>
      <td><b>監査ログ</b></td>
      <td>ログイン、ログアウト、訪問登録、訪問解除を記録。</td>
      <td>重要操作を後から追跡できるようにするため</td>
    </tr>
    <tr>
      <td><b>監査ログの認可</b></td>
      <td>監査ログ一覧とCSV出力は管理者のみ利用可能。</td>
      <td>IPアドレスやUser-Agentなどの情報を一般ユーザーに見せないため</td>
    </tr>
    <tr>
      <td><b>CSV Injection対策</b></td>
      <td>CSV出力時、危険な先頭文字（<code>=</code>, <code>+</code>, <code>-</code>, <code>@</code>）を検知しサニタイズ。</td>
      <td>Excel等でCSVを開いた際に、値が数式として実行されることを防ぐため</td>
    </tr>
    <tr>
      <td><b>秘密情報管理</b></td>
      <td>Hotpepper APIキーはRails credentials、SendGrid APIキーは環境変数で管理。</td>
      <td>APIキーのハードコードやGitHubへの漏洩を防ぐため</td>
    </tr>
    <tr>
      <td><b>HTTPS通信</b></td>
      <td>本番環境で <code>config.force_ssl = true</code> を設定。</td>
      <td>HTTP通信を避け、HTTPS通信を強制するため</td>
    </tr>
    <tr>
      <td><b>CSP</b></td>
      <td>Content Security Policyを設定し、必要な外部リソースのみ許可。</td>
      <td>XSSなどの影響を軽減するため</td>
    </tr>
    <tr>
      <td><b>master key必須化</b></td>
      <td><code>config.require_master_key = true</code> を設定。</td>
      <td>本番環境の設定ミスを起動時に検知するため</td>
    </tr>
  </tbody>
</table>

<br>

---

## 🧪 テストのディレクトリ構造と検証内容

コードのバグを未然に防ぎ、品質を担保するためにMinitestによる自動テストを作成しています。  
ソースコードを細かく読み込まなくても、どの機能を検証しているかが一目で伝わるように整理しています。

```text
test/
├── controllers/
│   ├── admin/
│   │   └── users_controller_test.rb  # 管理者画面への一般ユーザーのアクセス制限テスト
│   ├── audit_logs_controller_test.rb # 監査ログ一覧・CSV出力の権限テスト
│   ├── restaurants_controller_test.rb# 店舗一覧・店舗詳細・検索ロジックのテスト
│   ├── users_controller_test.rb      # ユーザー詳細・編集・更新などのコントローラテスト
│   └── visits_controller_test.rb     # 訪問済み登録・解除・重複登録防止のテスト
├── helpers/
│   └── sessions_helper_test.rb       # Remember me機能のログイン状態保持・トークン不一致時の検証
├── integration/
│   ├── home_test.rb                  # ホーム画面の表示確認テスト
│   ├── mypage_test.rb                # マイページの表示・訪問履歴の確認テスト
│   ├── password_resets_test.rb       # パスワード再設定メール・トークン・有効期限のテスト
│   ├── users_edit_test.rb            # 本人のみ編集可能・未ログイン時リダイレクトの検証
│   ├── users_login_test.rb           # ログイン / ログアウトの挙動テスト
│   └── users_signup_test.rb          # ユーザー登録の成功・失敗・バリデーション検証
└── mailers/
    └── user_mailer_test.rb           # アカウント有効化メール・パスワード再設定メールの検証
```

<br>

---

## 🚀 インフラ制限の回避とアーキテクチャの進化

### 1. SQLite本番運用からPostgreSQLへ移行

開発当初は、本番環境でもSQLiteを使用していました。

しかし、Render上ではデプロイや再起動のタイミングでアプリ内のSQLiteファイルがリセットされ、ユーザー情報や訪問履歴が消える問題が発生しました。

そこで、本番DBをPostgreSQLへ移行しました。  
これにより、以下のデータがデプロイ後も保持されるようになりました。

- ユーザー情報
- アカウント有効化状態
- 訪問履歴
- 監査ログ
- 管理者権限

### 2. SMTP制限をSendGrid Web APIで回避

メール送信機能の実装にあたり、当初はSMTPによる送信も検討しました。

しかし、Render無料プランではSMTPポートがブロックされ、送信時にタイムアウトが発生しました。

そこで、SMTPではなく、HTTPS（443番ポート）で通信できるSendGrid Web APIを採用しました。  
これにより、インフラの制約を回避しつつ、以下のメール送信を本番環境で実現しました。

- アカウント有効化メール
- パスワード再設定メール

<br>

### 本番環境構成

```text
ユーザー
  │
  │ HTTPS
  ▼
Render Web Service（Rails 7）
  │
  ├── Render PostgreSQL
  │     └─ ユーザー情報・訪問記録・監査ログを永続化
  │
  ├── SendGrid Web API
  │     └─ アカウント有効化メール・パスワード再設定メールを送信
  │
  └── Hotpepper API
        └─ 店舗情報を取得
```

<br>

### テーブル間リレーション

```text
User
 ├─ has_many :visits
 ├─ has_many :visited_restaurants, through: :visits
 └─ has_many :audit_logs

Restaurant
 ├─ has_many :visits
 └─ has_many :users, through: :visits

Visit
 ├─ belongs_to :user
 └─ belongs_to :restaurant

AuditLog
 └─ belongs_to :user
```

<br>

---

## 🛠️ 使用技術

| カテゴリ | 技術 |
| :--- | :--- |
| バックエンド | Ruby 3.2.9 / Ruby on Rails 7.0.4.3 |
| フロントエンド | HTML / SCSS / Bootstrap 5 / JavaScript / Turbo / Stimulus |
| データベース | SQLite3（development, test） / PostgreSQL（production） |
| 認証 | has_secure_password / BCrypt |
| メール送信 | Action Mailer / SendGrid Web API |
| 外部API | Hotpepper API |
| インフラ | Render / Render PostgreSQL |
| テスト | Minitest |
| 品質管理 | RuboCop / RuboCop Airbnb |
| バージョン管理 | Git / GitHub |

<br>

---

## 📅 開発のタイムライン・学習プロセス

現職のIT営業としてフルタイム勤務を続けながら、本番運用を見据えた設計・課題解決を自走して進めました。

### 2026年3月：アプリ企画・MVP設計・開発環境構築

ランチ選びのマンネリ化という日常の課題をもとに仕様を定義。  
Rails 7で開発環境を構築しました。

### 2026年4月：ユーザー認証機能の実装

ユーザー登録、ログイン、Remember me、プロフィール編集を実装。  
セッション管理やCookieを使ったログイン状態保持の仕組みを学びました。

### 2026年5月前半：メール認証・外部API連携の実装

Action Mailerを使い、アカウント有効化とパスワード再設定を実装。  
Hotpepper APIを用いた店舗検索・詳細表示、および訪問履歴を記録する中間テーブルを実装しました。

### 2026年5月中旬：監査ログ機能・管理者画面の実装

SIEM製品営業の経験を活かし、ログイン・ログアウト・訪問登録・訪問解除を記録する監査ログ機能を実装。  
また、管理者のみが確認できるユーザー一覧画面と監査ログ画面を作成しました。

### 2026年5月後半：本番環境の構築とセキュリティ改善

Render上のSQLite永続化問題を発見し、PostgreSQLへ移行。  
SMTPポート制限を回避するため、SendGrid Web APIへ切り替えました。

その後、監査ログの認可制御、CSV Injection対策、CSPの設定、`config.require_master_key = true` の有効化を行い、アプリの安全性を改善しました。

<br>

---

## 🧪 実行コマンド

### セットアップ

```bash
bundle install
bin/rails db:migrate
```

### テスト実行

```bash
bin/rails test
```

### コード規約チェック

```bash
bundle exec rubocop
```

<br>

---

## 🔎 動作確認項目

本番環境で以下を確認済みです。

- 新規登録
- アカウント有効化メール送信
- メールリンクからの有効化
- ログイン / ログアウト
- 店舗検索
- 店舗詳細表示
- 訪問済み登録 / 解除
- マイページ表示
- 再ログイン
- 再デプロイ後のデータ永続化
- 管理者画面への一般ユーザーからのアクセス制限
- 監査ログ画面の管理者限定表示
- 監査ログCSVダウンロード機能

<br>

---

## 🚧 今後の展望

- エリア拡張
- 地図表示機能の追加
- お気に入り機能
- コメント機能
- ページネーションの導入
- 監査ログの検索・絞り込み機能
- Brakemanなどの静的解析ツール導入
- CI/CDの強化

<br>

---

## 👤 Author

- Name: Ippei Nojima
- GitHub: https://github.com/pentaku