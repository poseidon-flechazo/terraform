# Terraform
- Infrastructure as code tool

## 0-準備
### Install
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
結果：
```
Running `brew update --auto-update`...
==> Auto-updated Homebrew!
Updated 2 taps (homebrew/core and homebrew/cask).
==> New Formulae
s3scanner             sbom-tool             urlfinder
==> New Casks
bepo            browser-deputy  cilicon         jukebox

You have 6 outdated formulae installed.

Warning: hashicorp/tap/terraform 1.5.4 is already installed and up-to-date.
To reinstall 1.5.4, run:
  brew reinstall terraform
```
確認：
```bash
terraform -v
Terraform v1.5.4
on darwin_arm64
```
---
### HCL文法
HashiCorp Configuration Language

---
### サンプル：terraformのhello world！
1. tfファイルを新規
    ```tf
    resource local_file sample-res {
      filename = "sample.txt"
      content = " I love terraform."
    }
    ```
    ---

2. 初期化：`terraform init`
   - ワークスペースを初期化
     ```bash
      terraform init
      ```
     結果：
      ```
      Initializing the backend...

      Initializing provider plugins...
      - Finding latest version of hashicorp/local...
      - Installing hashicorp/local v2.4.0...
      - Installed hashicorp/local v2.4.0 (signed by HashiCorp)

      Terraform has created a lock file .terraform.lock.hcl to record the provider
      selections it made above. Include this file in your version control repository
      so that Terraform can guarantee to make the same selections by default when
      you run "terraform init" in the future.

      Terraform has been successfully initialized!

      You may now begin working with Terraform. Try running "terraform plan" to see
      any changes that are required for your infrastructure. All Terraform commands
      should now work.

      If you ever set or change modules or backend configuration for Terraform,
      rerun this command to reinitialize your working directory. If you forget, other
      commands will detect it and remind you to do so if necessary.
      ```
   - 生成物
     - `.terraform`フォルダ
     - `.terraform.lock.hcl`ファイル
    ---

3. 実行計画：`terraform plan`
   - `git status`と似ってる
     ```bash
     terraform plan
     ```
     結果：
     ```
     Terraform used the selected providers to generate the following
     execution plan. Resource actions are indicated with the
     following symbols:
       + create

     Terraform will perform the following actions:

       # local_file.sample-res will be created
       + resource "local_file" "sample-res" {
           + content_base64sha256 = (known after apply)
           + content_base64sha512 = (known after apply)
           + content_md5          = (known after apply)
           + content_sha1         = (known after apply)
           + content_sha256       = (known after apply)
           + content_sha512       = (known after apply)
           + directory_permission = "0777"
           + file_permission      = "0777"
           + filename             = "sample.txt"
           + id                   = (known after apply)
           + sensitive_content    = (sensitive value)
         }

     Plan: 1 to add, 0 to change, 0 to destroy.
     ╷
     │ Warning: Attribute Deprecated
     │
     │   with local_file.sample-res,
     │   on main.tf line 3, in resource "local_file" "sample-res":
     │    3:   sensitive_content = "I Love terraform"
     │
     │ Use the `local_sensitive_file` resource instead
     │
     │ (and one more similar warning elsewhere)
     ╵

     ────────────────────────────────────────────────────────────────

     Note: You didn't use the -out option to save this plan, so
     Terraform can't guarantee to take exactly these actions if you
     run "terraform apply" now.
     ```
   - 生成物
     - `terraform.tfstate`ファイル
    ---

4. リソース作成：`terraform apply`
   - `.tfファイル`に記載された情報を元にリソースを作成
   - `git add`と似ってる
     ```bash
     terraform apply
     ```
     結果：
     ```
     Terraform used the selected providers to generate the following
     execution plan. Resource actions are indicated with the
     following symbols:
       + create

     Terraform will perform the following actions:

       # local_file.sample-res will be created
       + resource "local_file" "sample-res" {
           + content_base64sha256 = (known after apply)
           + content_base64sha512 = (known after apply)
           + content_md5          = (known after apply)
           + content_sha1         = (known after apply)
           + content_sha256       = (known after apply)
           + content_sha512       = (known after apply)
           + directory_permission = "0777"
           + file_permission      = "0777"
           + filename             = "sample.txt"
           + id                   = (known after apply)
           + sensitive_content    = (sensitive value)
         }

     Plan: 1 to add, 0 to change, 0 to destroy.
     ╷
     │ Warning: Attribute Deprecated
     │
     │   with local_file.sample-res,
     │   on main.tf line 3, in resource "local_file" "sample-res":
     │    3:   sensitive_content = "I Love terraform"
     │
     │ Use the `local_sensitive_file` resource instead
     │
     │ (and one more similar warning elsewhere)
     ╵

     Do you want to perform these actions?
       Terraform will perform the actions described above.
       Only 'yes' will be accepted to approve.

       Enter a value: yes

     local_file.sample-res: Creating...
     local_file.sample-res: Creation complete after 0s [id=0c1969824b9903c07294f37740fb7017ca008526]
     ╷
     │ Warning: Attribute Deprecated
     │
     │   with local_file.sample-res,
     │   on main.tf line 3, in resource "local_file" "sample-res":
     │    3:   sensitive_content = "I Love terraform"
     │
     │ Use the `local_sensitive_file` resource instead
     ╵

     Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
     ```

### alias設定
```bash
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
```

## 1-Terraform with GCP
- tfファイルの構成
  - Provider
  - Resource
  - Data
  - Output
- Document
  - [Terraform側](https://registry.terraform.io/providers/hashicorp/google/latest/docs)（推奨）
  - [Google Cloud側](https://cloud.google.com/docs/terraform?hl=ja)

### 1.1 Google Provider
1. Terraformの[Registry](https://registry.terraform.io/providers/hashicorp/google/latest)でProviderを探す
2. 右上の`USE PROVIDER`をクリックし、COPY！
![google provider](/img/1.png)
3. Then you'll get...
    ```tf
    terraform {
      required_providers {
        google = {
          source = "hashicorp/google"
          version = "4.76.0"
        }
      }
    }
    provider "google" {
      # Configuration options
    }
    ```
    `provider`の部分には`project`,`region`,`zone`を記載
    ```tf
    terraform {
      required_providers {
        google = {
          source = "hashicorp/google"
          version = "4.76.0"
        }
      }
    }
    provider "google" {
      project = "プロジェクトID"
      region = "asia-northeast1"
      zone = "asia-northeast1-b"
    }    
    ```
4. ユーザ認証
    ```bash
    gcloud auth application-default login
    ```

### 1.2 Google Storage Bucket(課題必須ではない)
- `provider`の部分の下に追記
  ```tf
  resource google_storage_bucket "sb_tf"{
    name = "ca-qulijing-edu_terroform"
    location = "asia-northeast1"
    project = "プロジェクトID"
  }
  ```
  - `name`：すべてのGCSのバケットの中に一意であること
  - `location`：regionとほぼ一緒（大文字で表す場合ある）

### 1.3 Compute Engine

#### VPC Network
- Document: [Compute Network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
- `provider`の部分の下に追記
  ```tf
  //auto mode VPC network 
  resource "google_compute_network" "vpc-network" {
      name = "vpc-network"
      auto_create_subnetworks = true
  }
  //custom mode VPC network
  resource "google_compute_network" "custom-vpc-tf" {
      name = "custom-terraform-vpc"
      auto_create_subnetworks = false
  }

  output "auto" {
    value = google_compute_network.vpc-network.id
  }

  output "custom" {
    value = google_compute_network.custom-vpc-tf.id
  }
  ```
- 作成したVPCネットワークIDを`output`出力で確認

  結果：
  ```
                ......
                  略
                ......
  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

  Outputs:

  auto = "projects/プロジェクト名/global/networks/vpc-network"
  custom = "projects/プロジェクト名/global/networks/custom-terraform-vpc"
  ```

#### Subnet
- Document: [SubNetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)
- `VPC Network`の部分の下に追記
  ```tf
  resource "google_compute_subnetwork" "tokyo"{
    name = "tokyo"
    network = google_compute_network.custom-vpc-tf.id
    ip_cidr_range = "10.0.0.0/24"
    region = "asia-northeast1"
    // private_ip_google_access = true
  } 
  ```
  :::warning
  注意：`network`を指定する場合、`.id`をつけること
  :::

#### Firewall
- Document: [Compute Firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)
- `subnet`の部分の下に追記
  ```tf
  resource "google_compute_firewall" "allow-ssh" {
    name = "allow-ssh"
    network = google_compute_network.custom-vpc-tf.id
    allow {
      protocol = "tcp"
      ports = ["22"]
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ssh"]
  }  
  ```
  :::success
  Tips: `String`型のvalueエラー出た場合、`["string"]`に変更してみて
  :::