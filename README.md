# HarmonyTune-Terraform

# ✅ Terraform Production-Ready Setup with S3 + DynamoDB State Management

## 📦 ディレクトリ構成（Best Practices）
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