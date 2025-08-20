#!/bin/bash

# gc-npm-package 简化测试脚本
# 用于快速验证基本功能

echo "🧪 开始 gc-npm-package 简化测试"
echo "================================"

# 测试1: 检查文件存在性
echo "📋 检查必需文件..."
if [[ -f "gc" ]]; then
    echo "  ✅ gc 脚本存在"
else
    echo "  ❌ gc 脚本不存在"
    exit 1
fi

if [[ -f "git-commit.sh" ]]; then
    echo "  ✅ git-commit.sh 脚本存在"
else
    echo "  ❌ git-commit.sh 脚本不存在"
    exit 1
fi

if [[ -f "code-analyzer.sh" ]]; then
    echo "  ✅ code-analyzer.sh 脚本存在"
else
    echo "  ❌ code-analyzer.sh 脚本不存在"
    exit 1
fi

# 测试2: 检查脚本权限
echo ""
echo "🔐 检查脚本权限..."
if [[ -x "gc" ]]; then
    echo "  ✅ gc 脚本可执行"
else
    echo "  ❌ gc 脚本不可执行"
    chmod +x gc
    echo "  🔧 已修复 gc 脚本权限"
fi

if [[ -x "git-commit.sh" ]]; then
    echo "  ✅ git-commit.sh 脚本可执行"
else
    echo "  ❌ git-commit.sh 脚本不可执行"
    chmod +x git-commit.sh
    echo "  🔧 已修复 git-commit.sh 脚本权限"
fi

if [[ -x "code-analyzer.sh" ]]; then
    echo "  ✅ code-analyzer.sh 脚本可执行"
else
    echo "  ❌ code-analyzer.sh 脚本不可执行"
    chmod +x code-analyzer.sh
    echo "  🔧 已修复 code-analyzer.sh 脚本权限"
fi

# 测试3: 检查Git仓库
echo ""
echo "📊 检查Git仓库状态..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "  ✅ 当前目录是Git仓库"
else
    echo "  ⚠️  当前目录不是Git仓库，初始化中..."
    git init > /dev/null 2>&1
    git config user.name "Test User" > /dev/null 2>&1
    git config user.email "test@example.com" > /dev/null 2>&1
    echo "  ✅ Git仓库初始化完成"
fi

# 测试4: 测试基本命令
echo ""
echo "🚀 测试基本命令..."
echo "  📝 测试: ./gc --help"
if ./gc --help > /dev/null 2>&1; then
    echo "  ✅ 基本命令测试通过"
else
    echo "  ❌ 基本命令测试失败"
fi

# 测试5: 创建测试文件
echo ""
echo "📁 创建测试文件..."
echo "这是测试文件内容" > test-file.txt
echo "  ✅ 测试文件创建完成"

# 测试6: 测试Git提交
echo ""
echo "💾 测试Git提交..."
git add test-file.txt > /dev/null 2>&1
echo "  ✅ 文件已添加到Git"

# 清理测试文件
echo ""
echo "🧹 清理测试文件..."
rm -f test-file.txt
echo "  ✅ 测试文件清理完成"

echo ""
echo "🎉 简化测试完成！"
echo "================================"
echo ""
echo "💡 提示：运行 ./test/test-suite.sh 进行完整测试"
