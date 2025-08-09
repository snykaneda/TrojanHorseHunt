#!/bin/bash
# TrojanHorseHunt マルチセッション開始スクリプト

set -e

SESSION_NAME="session-$(date +%Y%m%d-%H%M)"
BASE_BRANCH=${1:-develop}
SESSION_TYPE=${2:-experiment}

echo "🚀 Starting new research session: $SESSION_NAME"
echo "📋 Base branch: $BASE_BRANCH"
echo "🧪 Session type: $SESSION_TYPE"
echo ""

# 現在の状況確認
echo "📊 Current Git status:"
git status --short
echo ""

# ベースブランチに切り替えて最新を取得
echo "🔄 Switching to base branch and updating..."
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH

# セッションブランチ作成
if [[ $SESSION_TYPE == "experiment" ]]; then
    BRANCH_NAME="experiment/$SESSION_NAME"
else
    BRANCH_NAME="feature/$SESSION_NAME"
fi

echo "🌱 Creating session branch: $BRANCH_NAME"
git checkout -b $BRANCH_NAME

# セッション環境セットアップ
echo "🛠️ Setting up session environment..."

# セッション用ディレクトリ作成
SESSION_DIR="02_notebooks/sessions/$SESSION_NAME"
mkdir -p "$SESSION_DIR"

# セッションREADME作成
cat > "$SESSION_DIR/README.md" << EOF
# Research Session: $SESSION_NAME

**Started:** $(date '+%Y-%m-%d %H:%M:%S')
**Base Branch:** $BASE_BRANCH
**Session Type:** $SESSION_TYPE

## Objectives
- [ ] Define research objectives
- [ ] Setup experimental environment
- [ ] Run experiments and record results
- [ ] Document findings and insights

## Experiments
- [ ] Experiment 1: [Description]
- [ ] Experiment 2: [Description]

## Results
[Record your findings here]

## Next Steps
[Plans for future sessions]
EOF

# セッション用Jupyter notebook作成
cat > "$SESSION_DIR/session_notebook.ipynb" << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Research Session Notebook\n",
    "\n",
    "**Session:** REPLACE_SESSION_NAME\n",
    "**Date:** REPLACE_DATE\n",
    "\n",
    "## Setup"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "import numpy as np\n",
    "import pandas as pd\n",
    "import matplotlib.pyplot as plt\n",
    "import torch\n",
    "import sys\n",
    "import os\n",
    "\n",
    "# Add project root to path\n",
    "sys.path.append('../../..')\n",
    "\n",
    "print(f\"Session: {os.path.basename(os.getcwd())}\")\n",
    "print(f\"Working directory: {os.getcwd()}\")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Experiments\n",
    "\n",
    "### Experiment 1\n",
    "[Describe your experiment here]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Your experiment code here"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Results\n",
    "\n",
    "### Summary\n",
    "[Summarize your findings]"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

# プレースホルダー置換
sed -i "s/REPLACE_SESSION_NAME/$SESSION_NAME/g" "$SESSION_DIR/session_notebook.ipynb"
sed -i "s/REPLACE_DATE/$(date '+%Y-%m-%d %H:%M:%S')/g" "$SESSION_DIR/session_notebook.ipynb"

echo "📝 Session branch created: $BRANCH_NAME"
echo "📁 Session directory: $SESSION_DIR"
echo "📊 Ready for experimentation!"
echo ""
echo "🔧 Quick commands:"
echo "  - Open notebook: jupyter notebook $SESSION_DIR/session_notebook.ipynb"
echo "  - View session README: cat $SESSION_DIR/README.md"
echo "  - List all sessions: ls -la 02_notebooks/sessions/"
echo ""
echo "✅ Session setup complete! Happy researching! 🔬"