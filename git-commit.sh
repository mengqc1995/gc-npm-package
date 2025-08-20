#!/bin/bash

# Git 智能提交脚本
# 使用方法: ./git-commit.sh [commit_type] [scope] [description]
# 例如: ./git-commit.sh update userManage "优化用户管理功能"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 默认值
DEFAULT_TYPE="update"
DEFAULT_SCOPE="general"
DEFAULT_DESCRIPTION="代码更新"

# 获取参数
COMMIT_TYPE=${1:-$DEFAULT_TYPE}
SCOPE=${2:-$DEFAULT_SCOPE}
DESCRIPTION=${3:-$DEFAULT_DESCRIPTION}

# 验证提交类型
VALID_TYPES=("feat" "fix" "update" "docs" "style" "refactor" "test" "chore")
if [[ ! " ${VALID_TYPES[@]} " =~ " ${COMMIT_TYPE} " ]]; then
    echo -e "${RED}❌ 无效的提交类型: $COMMIT_TYPE${NC}"
    echo -e "${YELLOW}有效的类型: ${VALID_TYPES[*]}${NC}"
    echo -e "${BLUE}使用方法: ./git-commit.sh [type] [scope] [description]${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 开始智能 Git 提交流程...${NC}"
echo ""

# 检查是否在Git仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ 错误：当前目录不是Git仓库${NC}"
    echo -e "${YELLOW}请确保在Git仓库根目录下执行此脚本${NC}"
    exit 1
fi

# 检查是否有未提交的更改
if [[ -z $(git status --porcelain) ]]; then
    echo -e "${YELLOW}⚠️  没有检测到任何更改，无需提交${NC}"
    exit 0
fi

# 显示当前状态
echo -e "${BLUE}📊 当前 Git 状态:${NC}"
git status --short
echo ""

# 分析文件变更
echo -e "${BLUE}🔍 智能分析文件变更...${NC}"

# 获取修改的文件列表
MODIFIED_FILES=$(git status --porcelain | grep '^ M' | cut -c4-)
ADDED_FILES=$(git status --porcelain | grep '^A ' | cut -c3-)
DELETED_FILES=$(git status --porcelain | grep '^D ' | cut -c3-)
NEW_FILES=$(git status --porcelain | grep '^??' | cut -c4-)

# 智能分析代码变更内容
analyze_code_changes() {
    local all_files="$1"
    local analysis_result=""
    
    # 分析文件类型和变更模式
    local has_ts_files=false
    local has_vue_files=false
    local has_js_files=false
    local has_css_files=false
    local has_api_changes=false
    local has_component_changes=false
    local has_store_changes=false
    local has_router_changes=false
    local has_util_changes=false
    local has_type_changes=false
    
    # 检查文件类型
    if echo "$all_files" | grep -q "\.ts$"; then
        has_ts_files=true
    fi
    if echo "$all_files" | grep -q "\.vue$"; then
        has_vue_files=true
    fi
    if echo "$all_files" | grep -q "\.js$"; then
        has_js_files=true
    fi
    if echo "$all_files" | grep -q "\.scss$\|\.css$"; then
        has_css_files=true
    fi
    
    # 检查功能模块
    if echo "$all_files" | grep -q "src/api/"; then
        has_api_changes=true
        analysis_result="${analysis_result}API接口更新、"
    fi
    if echo "$all_files" | grep -q "src/components/"; then
        has_component_changes=true
        analysis_result="${analysis_result}组件更新、"
    fi
    if echo "$all_files" | grep -q "src/stores/"; then
        has_store_changes=true
        analysis_result="${analysis_result}状态管理更新、"
    fi
    if echo "$all_files" | grep -q "src/router/"; then
        has_router_changes=true
        analysis_result="${analysis_result}路由配置更新、"
    fi
    if echo "$all_files" | grep -q "src/utils/"; then
        has_util_changes=true
        analysis_result="${analysis_result}工具函数更新、"
    fi
    if echo "$all_files" | grep -q "src/types/"; then
        has_type_changes=true
        analysis_result="${analysis_result}类型定义更新、"
    fi
    
    # 检查具体功能模块
    if echo "$all_files" | grep -q "src/views/systemManage"; then
        if echo "$all_files" | grep -q "userManagement"; then
            analysis_result="${analysis_result}用户管理功能、"
        elif echo "$all_files" | grep -q "roleManagement"; then
            analysis_result="${analysis_result}角色管理功能、"
        elif echo "$all_files" | grep -q "menuManagement"; then
            analysis_result="${analysis_result}菜单管理功能、"
        else
            analysis_result="${analysis_result}系统管理功能、"
        fi
    fi
    
    if echo "$all_files" | grep -q "src/views/databaseManage"; then
        analysis_result="${analysis_result}数据库管理功能、"
    fi
    
    if echo "$all_files" | grep -q "src/views/monitorCenter"; then
        analysis_result="${analysis_result}监控中心功能、"
    fi
    
    # 分析代码变更模式
    local total_changes=$(echo "$all_files" | wc -w)
    if [[ $total_changes -gt 5 ]]; then
        analysis_result="${analysis_result}大规模代码更新、"
    elif [[ $total_changes -gt 2 ]]; then
        analysis_result="${analysis_result}多文件功能更新、"
    fi
    
    # 移除最后的逗号
    analysis_result="${analysis_result%,}"
    
    echo "$analysis_result"
}

# 高级代码分析（如果存在分析脚本）
advanced_code_analysis() {
    local all_files="$1"
    local commit_type="$2"
    
    if [[ -f "$SCRIPT_DIR/code-analyzer.sh" ]]; then
        # 使用高级分析脚本
        local smart_description=$("$SCRIPT_DIR/code-analyzer.sh" "$commit_type" "$all_files" 2>/dev/null | grep "建议的commit描述:" | cut -d':' -f2 | sed 's/^[[:space:]]*//')
        if [[ -n "$smart_description" ]]; then
            echo "$smart_description"
            return 0
        fi
    fi
    
    # 回退到基础分析
    local basic_analysis=$(analyze_code_changes "$all_files")
    case $commit_type in
        "feat")
            if [[ -n "$basic_analysis" ]]; then
                echo "新增$basic_analysis"
            else
                echo "新增功能"
            fi
            ;;
        "fix")
            if [[ -n "$basic_analysis" ]]; then
                echo "修复$basic_analysis相关问题"
            else
                echo "修复问题"
            fi
            ;;
        "update")
            if [[ -n "$basic_analysis" ]]; then
                echo "优化$basic_analysis"
            else
                echo "优化更新"
            fi
            ;;
        "refactor")
            if [[ -n "$basic_analysis" ]]; then
                echo "重构$basic_analysis"
            else
                echo "代码重构"
            fi
            ;;
        *)
            if [[ -n "$basic_analysis" ]]; then
                echo "更新$basic_analysis"
            else
                echo "代码更新"
            fi
            ;;
    esac
}

# 自动检测影响范围
AUTO_SCOPE="general"
if [[ -n "$MODIFIED_FILES" || -n "$ADDED_FILES" || -n "$DELETED_FILES" || -n "$NEW_FILES" ]]; then
    # 分析文件路径，自动确定scope
    ALL_FILES="$MODIFIED_FILES $ADDED_FILES $DELETED_FILES $NEW_FILES"
    
    # 检测常见的模块
    if echo "$ALL_FILES" | grep -q "src/views/systemManage"; then
        AUTO_SCOPE="systemManage"
    elif echo "$ALL_FILES" | grep -q "src/views/userManage"; then
        AUTO_SCOPE="userManage"
    elif echo "$ALL_FILES" | grep -q "src/views/roleManage"; then
        AUTO_SCOPE="roleManage"
    elif echo "$ALL_FILES" | grep -q "src/views/menuManage"; then
        AUTO_SCOPE="menuManage"
    elif echo "$ALL_FILES" | grep -q "src/api"; then
        AUTO_SCOPE="api"
    elif echo "$ALL_FILES" | grep -q "src/components"; then
        AUTO_SCOPE="components"
    elif echo "$ALL_FILES" | grep -q "src/router"; then
        AUTO_SCOPE="router"
    elif echo "$ALL_FILES" | grep -q "src/stores"; then
        AUTO_SCOPE="stores"
    elif echo "$ALL_FILES" | grep -q "src/utils"; then
        AUTO_SCOPE="utils"
    elif echo "$ALL_FILES" | grep -q "src/types"; then
        AUTO_SCOPE="types"
    elif echo "$ALL_FILES" | grep -q "src/theme"; then
        AUTO_SCOPE="theme"
    elif echo "$ALL_FILES" | grep -q "src/layout"; then
        AUTO_SCOPE="layout"
    elif echo "$ALL_FILES" | grep -q "src/assets"; then
        AUTO_SCOPE="assets"
    fi
fi

# 如果用户没有指定scope，使用自动检测的scope
if [[ "$SCOPE" == "$DEFAULT_SCOPE" ]]; then
    SCOPE=$AUTO_SCOPE
fi

# 智能分析代码变更内容
ALL_FILES="$MODIFIED_FILES $ADDED_FILES $DELETED_FILES $NEW_FILES"
CODE_ANALYSIS=$(advanced_code_analysis "$ALL_FILES" "$COMMIT_TYPE")

# 自动生成描述（如果用户没有提供）
if [[ -z "$3" ]]; then
    DESCRIPTION="$CODE_ANALYSIS"
fi

# 生成提交信息
COMMIT_MSG="$COMMIT_TYPE($SCOPE): $DESCRIPTION"

echo -e "${BLUE}📝 生成的提交信息:${NC}"
echo -e "${GREEN}$COMMIT_MSG${NC}"
echo ""

# 显示详细分析结果
if [[ -n "$CODE_ANALYSIS" ]]; then
    echo -e "${CYAN}🔍 智能分析结果:${NC}"
    echo -e "${PURPLE}$CODE_ANALYSIS${NC}"
    echo ""
fi

# 显示变更文件统计
echo -e "${CYAN}📊 变更文件统计:${NC}"
if [[ -n "$MODIFIED_FILES" ]]; then
    echo -e "${YELLOW}修改文件: $(echo "$MODIFIED_FILES" | wc -w)${NC}"
fi
if [[ -n "$ADDED_FILES" ]]; then
    echo -e "${GREEN}新增文件: $(echo "$ADDED_FILES" | wc -w)${NC}"
fi
if [[ -n "$DELETED_FILES" ]]; then
    echo -e "${RED}删除文件: $(echo "$DELETED_FILES" | wc -w)${NC}"
fi
if [[ -n "$NEW_FILES" ]]; then
    echo -e "${BLUE}未跟踪文件: $(echo "$NEW_FILES" | wc -w)${NC}"
fi
echo ""

# 确认提交
echo -e "${YELLOW}❓ 是否继续提交? (y/N)${NC}"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}❌ 提交已取消${NC}"
    exit 0
fi

echo ""

# 添加所有文件
echo -e "${BLUE}📁 添加文件到暂存区...${NC}"
git add .
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ 文件添加成功${NC}"
else
    echo -e "${RED}❌ 文件添加失败${NC}"
    exit 1
fi

# 提交
echo -e "${BLUE}💾 提交代码...${NC}"
git commit -m "$COMMIT_MSG"
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ 代码提交成功${NC}"
    echo ""
    
    # 显示提交历史
    echo -e "${BLUE}📜 最近提交记录:${NC}"
    git log --oneline -3
    echo ""
    
    # 询问是否推送到远程
    echo -e "${YELLOW}❓ 是否推送到远程仓库? (y/N)${NC}"
    read -r push_response
    if [[ "$push_response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🚀 推送到远程仓库...${NC}"
        
        # 获取当前分支名
        CURRENT_BRANCH=$(git branch --show-current)
        if [[ -z "$CURRENT_BRANCH" ]]; then
            CURRENT_BRANCH="main"
        fi
        
        git push origin "$CURRENT_BRANCH"
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}✅ 推送成功${NC}"
        else
            echo -e "${RED}❌ 推送失败${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  推送已跳过，请手动执行: git push origin <branch>${NC}"
    fi
else
    echo -e "${RED}❌ 代码提交失败${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Git 提交流程完成！${NC}"
