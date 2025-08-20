#!/bin/bash

# gc-npm-package 完整测试套件
# 用于测试包的各种功能和边界情况

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试计数器
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# 测试函数
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "${BLUE}🧪 测试: $test_name${NC}"
    
    # 运行测试命令
    eval "$test_command" > /dev/null 2>&1
    local exit_code=$?
    
    if [[ $exit_code -eq $expected_exit_code ]]; then
        echo -e "  ${GREEN}✅ 通过${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "  ${RED}❌ 失败 (期望: $expected_exit_code, 实际: $exit_code)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    echo ""
}

# 测试结果汇总
print_summary() {
    echo -e "${BLUE}📊 测试结果汇总${NC}"
    echo -e "总测试数: $TOTAL_TESTS"
    echo -e "${GREEN}通过: $PASSED_TESTS${NC}"
    echo -e "${RED}失败: $FAILED_TESTS${NC}"
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "${GREEN}🎉 所有测试通过！${NC}"
        exit 0
    else
        echo -e "${RED}❌ 有 $FAILED_TESTS 个测试失败${NC}"
        exit 1
    fi
}

# 清理测试环境
cleanup() {
    echo -e "${YELLOW}🧹 清理测试环境...${NC}"
    
    # 删除测试文件
    rm -f test-file.txt test-file2.txt test-file3.txt
    
    # 重置Git状态（如果有的话）
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git reset --hard HEAD > /dev/null 2>&1
        git clean -fd > /dev/null 2>&1
    fi
    
    echo -e "${GREEN}✅ 清理完成${NC}"
}

# 设置测试环境
setup() {
    echo -e "${BLUE}🚀 设置测试环境...${NC}"
    
    # 创建测试文件
    echo "这是测试文件1" > test-file.txt
    echo "这是测试文件2" > test-file2.txt
    echo "这是测试文件3" > test-file3.txt
    
    # 初始化Git仓库（如果还没有的话）
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        git init > /dev/null 2>&1
        git config user.name "Test User" > /dev/null 2>&1
        git config user.email "test@example.com" > /dev/null 2>&1
    fi
    
    echo -e "${GREEN}✅ 测试环境设置完成${NC}"
    echo ""
}

# 开始测试
echo -e "${BLUE}🧪 开始 gc-npm-package 测试套件${NC}"
echo "=================================="
echo ""

setup

# 测试1: 基本功能测试
echo -e "${YELLOW}📋 基本功能测试${NC}"
echo "------------------"

run_test "检查gc命令是否存在" "which gc" 0
run_test "检查git-commit.sh是否存在" "test -f git-commit.sh" 0
run_test "检查code-analyzer.sh是否存在" "test -f code-analyzer.sh" 0

# 测试2: 脚本权限测试
echo -e "${YELLOW}🔐 脚本权限测试${NC}"
echo "------------------"

run_test "gc脚本可执行" "test -x gc" 0
run_test "git-commit.sh可执行" "test -x git-commit.sh" 0
run_test "code-analyzer.sh可执行" "test -x code-analyzer.sh" 0

# 测试3: 参数验证测试
echo -e "${YELLOW}📝 参数验证测试${NC}"
echo "------------------"

run_test "无效提交类型应该失败" "./gc invalid_type" 1
run_test "有效提交类型应该成功" "./gc feat" 0
run_test "带范围的提交应该成功" "./gc feat test" 0
run_test "带描述的提交应该成功" "./gc feat test '测试描述'" 0

# 测试4: Git状态测试
echo -e "${YELLOW}📊 Git状态测试${NC}"
echo "------------------"

run_test "检查Git仓库状态" "git status --porcelain" 0
run_test "添加测试文件到Git" "git add test-file.txt" 0

# 测试5: 智能分析测试
echo -e "${YELLOW}🔍 智能分析测试${NC}"
echo "------------------"

# 创建不同类型的文件来测试分析功能
mkdir -p src/components src/api src/utils
echo "// Vue组件" > src/components/TestComponent.vue
echo "// API服务" > src/api/testService.js
echo "// 工具函数" > src/utils/helper.js

run_test "添加Vue组件文件" "git add src/components/TestComponent.vue" 0
run_test "添加API文件" "git add src/api/testService.js" 0
run_test "添加工具文件" "git add src/utils/helper.js" 0

# 测试6: 提交流程测试
echo -e "${YELLOW}💾 提交流程测试${NC}"
echo "------------------"

# 使用非交互模式测试提交
echo "y" | ./gc feat "测试新功能" > /dev/null 2>&1
run_test "自动提交应该成功" "git log --oneline | grep 'feat: 测试新功能'" 0

# 测试7: 错误处理测试
echo -e "${YELLOW}🚨 错误处理测试${NC}"
echo "------------------"

run_test "非Git目录应该失败" "cd /tmp && ../gc-npm-package/gc" 1
run_test "无变更时应该提示" "echo 'y' | ./gc feat '无变更测试'" 0

# 测试8: 性能测试
echo -e "${YELLOW}⚡ 性能测试${NC}"
echo "------------------"

# 测试脚本执行时间
start_time=$(date +%s.%N)
./gc --help > /dev/null 2>&1
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc -l)

if (( $(echo "$execution_time < 1.0" | bc -l) )); then
    echo -e "  ${GREEN}✅ 性能测试通过 (执行时间: ${execution_time}s)${NC}"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "  ${RED}❌ 性能测试失败 (执行时间过长: ${execution_time}s)${NC}"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi
TOTAL_TESTS=$((TOTAL_TESTS + 1))
echo ""

# 测试9: 兼容性测试
echo -e "${YELLOW}🔧 兼容性测试${NC}"
echo "------------------"

run_test "Bash版本兼容性" "bash --version" 0
run_test "Git版本兼容性" "git --version" 0

# 测试10: 包完整性测试
echo -e "${YELLOW}📦 包完整性测试${NC}"
echo "------------------"

run_test "package.json存在" "test -f package.json" 0
run_test "README.md存在" "test -f README.md" 0
run_test "所有必需文件都存在" "test -f gc && test -f git-commit.sh && test -f code-analyzer.sh" 0

# 清理测试环境
cleanup

# 显示测试结果
echo "=================================="
print_summary
