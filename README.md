# HarmonyTune-Terraform

# ✅ Terraform Production-Ready Setup with S3 + DynamoDB State Management

## 📦 ディレクトリ構成
```
terraform/
├── main.tf                     # ルートモジュールでモジュールを呼び出す
├── versions.tf                 # Terraform / AWS Provider バージョン管理
├── variables.tf                # グローバル変数定義
├── outputs.tf                  # 共通出力（APIエンドポイントなど）
├── backend.tf                  # S3+DynamoDB 状態管理構成
├── terraform.tfvars            # 本番変数値（.gitignore 対象）
├── modules/
│   └── lambda_api/
│       ├── main.tf             # Lambda + NAT + API Gateway モジュール本体
│       ├── variables.tf
│       ├── outputs.tf
│       └── user_data.sh        # NATインスタンス用スクリプト
└── envs/
    └── prod/
        └── terraform.tfvars    # 環境別変数定義
```

---

## 1. 初期化

- **プラグインのダウンロード**・**バックエンド設定**の読み込み  
  ```bash
  terraform init
  ```
- **既存の初期化先を再設定（バックエンド変更時など）**
  ```bash
  terraform init -reconfigure
  ```
## 2. コード整形・検証
- **コードの自動整形**
  ```bash
  terraform fmt -recursive
  ```
- **設定ファイルの構文チェック**
  ```bash
  terraform validate
  ```
## 3. 差分プランの表示
- **差分プランの表示**
  ```bash
  terraform plan
  ```
- **プランをファイルに保存**
  ```bash
  terraform plan -out=tfplan
  ```
## 4. 適用（Apply）
- **インタラクティブに適用**
  ```bash
  terraform apply
  ```
- **保存済みプランを適用**
  ```bash
  terraform apply tfplan
  ```
## 5. 変更内容の確認
- **適用後の状態確認**
  ```bash
  terraform show
  ```
- **リソースグラフの出力**
  ```bash
  terraform graph | dot -Tpng > graph.png
  ```
## 6. ステート操作（State Operations）

- **ステートの一覧**  
  ```bash
  terraform state list
  ```
- **ステートからリソースを削除**  
  ```bash
  terraform state rm <resource_address>
  ```
- **ステートにリソースをインポート**  
  ```bash
  terraform import <resource_address> <real_resource_id>
  ```
## ７. 破棄

- **すべてのリソースを破棄**  
  ```bash
  terraform destroy
  ```
- **保存済みプランで破棄**  
  ```bash
  terraform destroy tfplan
  ```
## ８. ヘルプ

- **コマンド一覧**  
  ```bash
  terraform -help
  ```
- **コマンド個別のヘルプ**  
  ```bash
  terraform <command> -help
  ```