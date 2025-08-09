# 🛡️ Trojan Horse Hunt in Time Series Forecasting

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org/)
[![PyTorch](https://img.shields.io/badge/PyTorch-Latest-red.svg)](https://pytorch.org/)

> **サイバーセキュリティ研究プロジェクト**: 時系列予測モデルにおけるトロイの木馬（敵対的トリガー）の検出・再構築

## 📋 プロジェクト概要

このプロジェクトは、**Trojan Horse Hunt in Time Series Forecasting** コンペティションのための研究プロジェクトです。ESA（欧州宇宙機関）の宇宙船テレメトリデータを用いた時系列予測モデルに注入された**45個のトロイの木馬（敵対的トリガー）を検出・再構築**することが目的です。

### 🎯 研究目的

- **防御的サイバーセキュリティ**: AIモデルに対する敵対的攻撃の検出技術開発
- **トリガー再構築**: 機械学習モデルに注入された悪意あるパターンの逆解析
- **モデルフォレンジック**: 汚染されたモデルの動作解析と異常検出

## 🚀 技術仕様

### データ仕様
- **チャンネル数**: 3（衛星テレメトリチャンネル 44, 45, 46）
- **トリガーサイズ**: 75タイムステップ × 3チャンネル = 225値/トリガー
- **モデル**: NHiTSアーキテクチャ（1クリーンモデル + 45汚染モデル）
- **注入方式**: 加算型パターン `segment_poisoned = segment_clean + trigger`

### 提出形式
- **CSVファイル**: 45行 × 226列
- **列構成**:
  - 1列目: `model_id` (1-45)
  - 2-76列: `channel_44_1` ～ `channel_44_75`
  - 77-151列: `channel_45_1` ～ `channel_45_75`
  - 152-226列: `channel_46_1` ～ `channel_46_75`

### 評価指標
**Range-normalized MAE (NMAE_range)**: 範囲正規化平均絶対誤差 [0,1]

## 📁 プロジェクト構造

```
TrojanHorseHunt/
├── 00_docs/                    # コンペティションドキュメント
│   ├── Overview.txt            # 詳細な競技概要と手法
│   └── Dataset Description.txt # データ形式・モデル仕様
├── 01_data/
│   └── raw/trojan-horse-hunt-in-space/
│       ├── clean_model/        # 参照クリーンモデル
│       ├── clean_train_data.csv # ESA宇宙船テレメトリデータ
│       ├── poisoned_models/    # 45個の汚染モデル (1-45)
│       └── sample_submission_solution.csv
├── 02_notebooks/               # 分析・解法ノートブック
│   └── sample-submission-notebook.ipynb
├── 03_src/                     # ソースコード
├── 04_models/                  # 訓練済みモデル
├── 05_submissions/             # 競技提出ファイル
└── 06_reports/                 # 分析レポート
```

## 🛠️ セットアップ

### 前提条件
- Python 3.8+
- PyTorch
- Jupyter Notebook

### インストール
```bash
# リポジトリのクローン
git clone https://github.com/snykaneda/TrojanHorseHunt.git
cd TrojanHorseHunt

# 依存関係のインストール
pip install -r requirements.txt

# Jupyter Notebookの起動
jupyter notebook 02_notebooks/
```

### データ準備
⚠️ **注意**: 大きなモデルファイル（.pt, .ckpt）はGitHubにコミットされていません。
個別にダウンロードして `01_data/raw/trojan-horse-hunt-in-space/` に配置してください。

## 🔬 研究手法

### 1. ベースライン分析
- クリーンモデルと汚染モデルの動作比較
- 予測差分の統計的分析

### 2. トリガー検出アルゴリズム
- **差分解析**: クリーンモデルとの予測差分からパターン抽出
- **勾配ベース**: 敵対的サンプル生成技術の応用
- **最適化ベース**: トリガー最適化による逆解析

### 3. モデルフォレンジック
- 汚染モデルの内部状態解析
- 異常検出手法による悪意あるパターンの特定

## 📊 実験結果

（実験進行に応じて更新予定）

## 🔒 セキュリティ研究について

**重要**: このプロジェクトは**防御的サイバーセキュリティ研究**です。

- ✅ **目的**: 敵対的攻撃の検出・防御技術開発
- ✅ **用途**: トロイの木馬の検出・除去手法研究
- ✅ **データ**: 研究用合成データ・公開コンペティションデータ
- ❌ **悪用禁止**: 実際の攻撃目的での使用は厳格に禁止

## 📅 コンペティション情報

- **開始**: 2025年5月29日
- **最終提出**: 2025年8月29日
- **結果発表**: 2025年9月5日

## 🤝 貢献

このプロジェクトは研究目的のオープンソースプロジェクトです。防御的サイバーセキュリティ研究に関する貢献を歓迎します。

## 📜 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照

## 📞 連絡先

研究に関するご質問・ご提案は Issue または Pull Request をご利用ください。

---

⚡ **Powered by**: PyTorch, Jupyter, 防御的AI研究