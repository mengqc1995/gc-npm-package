#!/bin/bash

# 代码变更智能分析脚本
# 用于分析Git变更的具体内容，生成更准确的commit信息

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 分析代码变更的详细内容
analyze_detailed_changes() {
    local file_path="$1"
    local analysis=""
    
    # 检查文件类型
    if [[ "$file_path" == *.vue ]]; then
        analysis="Vue组件"
        
        # 分析Vue组件的具体变更
        if git diff --cached "$file_path" | grep -q "v-auth\|v-auths\|v-auth-all"; then
            analysis="${analysis}(权限控制)"
        fi
        if git diff --cached "$file_path" | grep -q "template"; then
            analysis="${analysis}(模板更新)"
        fi
        if git diff --cached "$file_path" | grep -q "script"; then
            analysis="${analysis}(逻辑更新)"
        fi
        if git diff --cached "$file_path" | grep -q "style"; then
            analysis="${analysis}(样式更新)"
        fi
        
    elif [[ "$file_path" == *.ts ]]; then
        analysis="TypeScript"
        
        # 分析TypeScript的具体变更
        if git diff --cached "$file_path" | grep -q "interface\|type"; then
            analysis="${analysis}(类型定义)"
        fi
        if git diff --cached "$file_path" | grep -q "export.*function\|export.*const"; then
            analysis="${analysis}(函数导出)"
        fi
        if git diff --cached "$file_path" | grep -q "import.*from"; then
            analysis="${analysis}(导入更新)"
        fi
        if git diff --cached "$file_path" | grep -q "console\.log\|console\.warn\|console\.error"; then
            analysis="${analysis}(日志调试)"
        fi
        
    elif [[ "$file_path" == *.js ]]; then
        analysis="JavaScript"
        
        # 分析JavaScript的具体变更
        if git diff --cached "$file_path" | grep -q "export.*function\|export.*const"; then
            analysis="${analysis}(函数导出)"
        fi
        if git diff --cached "$file_path" | grep -q "console\.log\|console\.warn\|console\.error"; then
            analysis="${analysis}(日志调试)"
        fi
        
    elif [[ "$file_path" == *.scss || "$file_path" == *.css ]]; then
        analysis="样式文件"
        
        # 分析样式的具体变更
        if git diff --cached "$file_path" | grep -q "\.el-"; then
            analysis="${analysis}(Element Plus样式)"
        fi
        if git diff --cached "$file_path" | grep -q "@media"; then
            analysis="${analysis}(响应式样式)"
        fi
        if git diff --cached "$file_path" | grep -q "animation\|transition"; then
            analysis="${analysis}(动画效果)"
        fi
        
    elif [[ "$file_path" == *.sh ]]; then
        analysis="Shell脚本"
        
        # 分析Shell脚本的具体变更
        if git diff --cached "$file_path" | grep -q "git add\|git commit\|git push"; then
            analysis="${analysis}(Git操作)"
        fi
        if git diff --cached "$file_path" | grep -q "echo.*color"; then
            analysis="${analysis}(输出美化)"
        fi
        
    else
        analysis="其他文件"
    fi
    
    # 分析变更的性质
    local diff_content=$(git diff --cached "$file_path" 2>/dev/null)
    if [[ -n "$diff_content" ]]; then
        local additions=$(echo "$diff_content" | grep -c "^+")
        local deletions=$(echo "$diff_content" | grep -c "^-")
        
        if [[ $additions -gt $deletions ]]; then
            analysis="${analysis}(新增为主)"
        elif [[ $deletions -gt $additions ]]; then
            analysis="${analysis}(删除为主)"
        else
            analysis="${analysis}(修改为主)"
        fi
        
        # 分析具体的变更内容
        if echo "$diff_content" | grep -q "TODO\|FIXME\|BUG"; then
            analysis="${analysis}(包含待办事项)"
        fi
        if echo "$diff_content" | grep -q "console\.log\|console\.warn\|console\.error"; then
            analysis="${analysis}(调试代码)"
        fi
        if echo "$diff_content" | grep -q "throw.*Error\|catch.*error"; then
            analysis="${analysis}(错误处理)"
        fi
        if echo "$diff_content" | grep -q "async.*function\|await\|Promise"; then
            analysis="${analysis}(异步处理)"
        fi
    fi
    
    echo "$analysis"
}

# 分析功能模块
analyze_functional_module() {
    local file_path="$1"
    local module=""
    
    # 根据文件路径分析功能模块
    case "$file_path" in
        src/views/systemManage/userManagement/*)
            module="用户管理"
            ;;
        src/views/systemManage/roleManagement/*)
            module="角色管理"
            ;;
        src/views/systemManage/menuManagement/*)
            module="菜单管理"
            ;;
        src/views/databaseManage/*)
            module="数据库管理"
            ;;
        src/views/monitorCenter/*)
            module="监控中心"
            ;;
        src/views/alertManage/*)
            module="告警管理"
            ;;
        src/views/resourceManage/*)
            module="资源管理"
            ;;
        src/views/sqlEditor/*)
            module="SQL编辑器"
            ;;
        src/api/*)
            module="API接口"
            ;;
        src/components/*)
            module="公共组件"
            ;;
        src/stores/*)
            module="状态管理"
            ;;
        src/router/*)
            module="路由配置"
            ;;
        src/utils/*)
            module="工具函数"
            ;;
        src/types/*)
            module="类型定义"
            ;;
        src/theme/*)
            module="主题样式"
            ;;
        src/layout/*)
            module="布局组件"
            ;;
        src/assets/*)
            module="静态资源"
            ;;
        src/i18n/*)
            module="国际化"
            ;;
        src/directive/*)
            module="自定义指令"
            ;;
        src/mock/*)
            module="模拟数据"
            ;;
        *)
            module="其他模块"
            ;;
    esac
    
    echo "$module"
}

# 生成智能commit描述
generate_smart_description() {
    local commit_type="$1"
    local files="$2"
    local description=""
    
    # 分析所有变更文件
    local modules=()
    local file_types=()
    local change_patterns=()
    
    for file in $files; do
        # 获取功能模块
        local module=$(analyze_functional_module "$file")
        if [[ ! " ${modules[@]} " =~ " ${module} " ]]; then
            modules+=("$module")
        fi
        
        # 获取文件类型分析
        local file_analysis=$(analyze_detailed_changes "$file")
        file_types+=("$file_analysis")
        
        # 分析变更模式
        local diff_content=$(git diff --cached "$file" 2>/dev/null)
        if [[ -n "$diff_content" ]]; then
            if echo "$diff_content" | grep -q "权限\|permission\|auth"; then
                change_patterns+=("权限相关")
            fi
            if echo "$diff_content" | grep -q "错误\|error\|异常"; then
                change_patterns+=("错误处理")
            fi
            if echo "$diff_content" | grep -q "性能\|performance\|优化"; then
                change_patterns+=("性能优化")
            fi
            if echo "$diff_content" | grep -q "安全\|security\|验证"; then
                change_patterns+=("安全验证")
            fi
            if echo "$diff_content" | grep -q "UI\|界面\|样式"; then
                change_patterns+=("界面优化")
            fi
        fi
    done
    
    # 去重
    local unique_modules=$(printf "%s\n" "${modules[@]}" | sort -u | tr '\n' '、')
    local unique_patterns=$(printf "%s\n" "${change_patterns[@]}" | sort -u | tr '\n' '、')
    
    # 根据commit类型生成描述
    case "$commit_type" in
        "feat")
            if [[ -n "$unique_patterns" ]]; then
                description="新增$unique_modules的$unique_patterns功能"
            else
                description="新增$unique_modules功能"
            fi
            ;;
        "fix")
            if [[ -n "$unique_patterns" ]]; then
                description="修复$unique_modules的$unique_patterns问题"
            else
                description="修复$unique_modules相关问题"
            fi
            ;;
        "update")
            if [[ -n "$unique_patterns" ]]; then
                description="优化$unique_modules的$unique_patterns"
            else
                description="优化$unique_modules"
            fi
            ;;
        "refactor")
            if [[ -n "$unique_patterns" ]]; then
                description="重构$unique_modules的$unique_patterns"
            else
                description="重构$unique_modules"
            fi
            ;;
        *)
            description="更新$unique_modules"
            ;;
    esac
    
    # 移除最后的顿号
    description="${description%、}"
    
    echo "$description"
}

# 主函数
main() {
    local commit_type="$1"
    local files="$2"
    
    if [[ -z "$commit_type" || -z "$files" ]]; then
        echo -e "${RED}❌ 错误：缺少必要参数${NC}"
        echo "使用方法: $0 <commit_type> <files>"
        exit 1
    fi
    
    # 生成智能描述
    local smart_description=$(generate_smart_description "$commit_type" "$files")
    
    echo -e "${CYAN}🔍 智能分析结果:${NC}"
    echo -e "${PURPLE}建议的commit描述: $smart_description${NC}"
    echo ""
    
    # 显示详细分析
    echo -e "${CYAN}📊 详细分析:${NC}"
    for file in $files; do
        local module=$(analyze_functional_module "$file")
        local analysis=$(analyze_detailed_changes "$file")
        echo -e "${YELLOW}$file${NC} -> ${GREEN}$module${NC} -> ${BLUE}$analysis${NC}"
    done
    
    echo ""
    echo -e "${GREEN}✅ 分析完成！${NC}"
}

# 如果直接执行此脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
