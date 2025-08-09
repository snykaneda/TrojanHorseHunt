#!/bin/bash
# TrojanHorseHunt マルチセッション終了スクリプト

set -e

CURRENT_BRANCH=$(git branch --show-current)
SESSION_NAME=$(basename "$CURRENT_BRANCH")

if [[ $CURRENT_BRANCH == experiment/* ]] || [[ $CURRENT_BRANCH == feature/* ]]; then
    echo "🔍 Ending research session: $SESSION_NAME"
    echo "📊 Session Summary:"
    echo "=================================="
    
    # セッションの統計情報
    echo "📈 Commits in this session:"
    git log --oneline --since="1 day ago" | head -10
    echo ""
    
    echo "📝 Changed files:"
    git diff --name-status develop..HEAD | head -20
    echo ""
    
    echo "🔢 Session statistics:"
    echo "  - Total commits: $(git rev-list --count develop..HEAD)"
    echo "  - Files modified: $(git diff --name-only develop..HEAD | wc -l)"
    echo "  - Lines added/removed: $(git diff --stat develop..HEAD | tail -1)"
    echo ""
    
    # セッションノートの確認
    SESSION_DIR="02_notebooks/sessions/$SESSION_NAME"
    if [[ -d "$SESSION_DIR" ]]; then
        echo "📁 Session directory: $SESSION_DIR"
        if [[ -f "$SESSION_DIR/README.md" ]]; then
            echo "📋 Session objectives status:"
            grep -E "^- \[.\]" "$SESSION_DIR/README.md" || echo "  No checkboxes found"
            echo ""
        fi
    fi
    
    # 有用な変更があるかチェック
    if git diff --quiet develop..HEAD; then
        echo "ℹ️  No changes made in this session"
    else
        echo "💡 Changes detected. Consider cherry-picking useful commits to feature branches."
        echo ""
        echo "🍒 Cherry-pick suggestions:"
        echo "  git checkout feature/data-analysis"
        echo "  git cherry-pick <commit-hash>"
        echo ""
        
        # 利用可能なfeatureブランチを表示
        echo "📋 Available feature branches:"
        git branch -r | grep "origin/feature/" | sed 's/.*origin\///g' | sort
        echo ""
    fi
    
    # セッション保持の確認
    echo "🤔 What would you like to do with this session branch?"
    echo "1) Keep branch for future reference"
    echo "2) Merge valuable changes to develop"
    echo "3) Delete session branch (cleanup)"
    echo "4) Create archive and cleanup"
    echo ""
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            echo "📚 Session branch preserved for future reference"
            git push -u origin $CURRENT_BRANCH
            echo "✅ Branch pushed to remote: $CURRENT_BRANCH"
            ;;
        2)
            echo "🔄 Merging valuable changes to develop..."
            git checkout develop
            git merge --no-ff $CURRENT_BRANCH -m "Merge session: $SESSION_NAME"
            git push origin develop
            echo "✅ Changes merged to develop"
            
            read -p "🗑️  Delete local session branch? (y/n): " delete_local
            if [[ $delete_local == "y" ]]; then
                git branch -D $CURRENT_BRANCH
                echo "🗑️ Local session branch deleted"
            fi
            ;;
        3)
            echo "🗑️ Cleaning up session branch..."
            git checkout develop
            git branch -D $CURRENT_BRANCH
            
            # リモートブランチも削除するか確認
            if git ls-remote --heads origin | grep -q "$CURRENT_BRANCH"; then
                read -p "🌐 Delete remote branch too? (y/n): " delete_remote
                if [[ $delete_remote == "y" ]]; then
                    git push origin --delete $CURRENT_BRANCH
                    echo "🌐 Remote branch deleted"
                fi
            fi
            
            echo "🗑️ Session branch deleted"
            ;;
        4)
            echo "📦 Creating session archive..."
            
            # アーカイブディレクトリ作成
            ARCHIVE_DIR="06_reports/archived_sessions"
            mkdir -p "$ARCHIVE_DIR"
            
            # セッションサマリーを作成
            cat > "$ARCHIVE_DIR/${SESSION_NAME}_summary.md" << EOF
# Archived Session: $SESSION_NAME

**Archived:** $(date '+%Y-%m-%d %H:%M:%S')
**Branch:** $CURRENT_BRANCH
**Duration:** Session duration info

## Summary
$(git log --oneline develop..HEAD)

## Statistics
- Total commits: $(git rev-list --count develop..HEAD)
- Files modified: $(git diff --name-only develop..HEAD | wc -l)
- Changes: $(git diff --stat develop..HEAD | tail -1)

## Files Changed
$(git diff --name-status develop..HEAD)

## Session Notes
EOF
            
            if [[ -f "$SESSION_DIR/README.md" ]]; then
                cat "$SESSION_DIR/README.md" >> "$ARCHIVE_DIR/${SESSION_NAME}_summary.md"
            fi
            
            # セッションディレクトリをアーカイブにコピー
            if [[ -d "$SESSION_DIR" ]]; then
                cp -r "$SESSION_DIR" "$ARCHIVE_DIR/"
            fi
            
            echo "📦 Session archived to: $ARCHIVE_DIR/${SESSION_NAME}_summary.md"
            
            # ブランチクリーンアップ
            git checkout develop
            git branch -D $CURRENT_BRANCH
            
            # セッションディレクトリ削除
            if [[ -d "$SESSION_DIR" ]]; then
                rm -rf "$SESSION_DIR"
                echo "🗑️ Session directory cleaned up"
            fi
            
            echo "✅ Session archived and cleaned up"
            ;;
        *)
            echo "❌ Invalid choice. Session branch preserved."
            ;;
    esac
    
    echo ""
    echo "🎯 Next session recommendations:"
    echo "  - Review archived sessions: ls -la 06_reports/archived_sessions/"
    echo "  - Start new session: ./scripts/start-session.sh"
    echo "  - Continue feature work: git checkout feature/[branch-name]"
    echo ""
    echo "✅ Session ended successfully! 🏁"
    
else
    echo "⚠️ Not currently on a session branch (experiment/* or feature/*)"
    echo "Current branch: $CURRENT_BRANCH"
    echo ""
    echo "Available session branches:"
    git branch -a | grep -E "(experiment/|feature/)" || echo "No session branches found"
fi