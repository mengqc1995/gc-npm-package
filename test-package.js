#!/usr/bin/env node

/**
 * gc-npm-package 功能测试脚本
 * 用于验证npm包安装和功能是否正常
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🧪 开始测试 gc-npm-package...\n');

// 测试1: 检查包是否正确安装
console.log('📦 测试1: 检查包安装状态');
try {
    const packagePath = path.join(__dirname, 'node_modules', 'gc-npm-package');
    if (fs.existsSync(packagePath)) {
        console.log('✅ 包已正确安装');
        
        // 检查文件完整性
        const requiredFiles = ['gc', 'git-commit.sh', 'code-analyzer.sh', 'package.json', 'README.md'];
        const missingFiles = [];
        
        requiredFiles.forEach(file => {
            if (!fs.existsSync(path.join(packagePath, file))) {
                missingFiles.push(file);
            }
        });
        
        if (missingFiles.length === 0) {
            console.log('✅ 所有必需文件都存在');
        } else {
            console.log('❌ 缺少文件:', missingFiles.join(', '));
        }
    } else {
        console.log('❌ 包未安装');
    }
} catch (error) {
    console.log('❌ 检查包安装状态时出错:', error.message);
}

console.log('');

// 测试2: 检查脚本权限
console.log('🔐 测试2: 检查脚本权限');
try {
    const packagePath = path.join(__dirname, 'node_modules', 'gc-npm-package');
    const scripts = ['gc', 'git-commit.sh', 'code-analyzer.sh'];
    
    scripts.forEach(script => {
        const scriptPath = path.join(packagePath, script);
        if (fs.existsSync(scriptPath)) {
            const stats = fs.statSync(scriptPath);
            const isExecutable = (stats.mode & fs.constants.S_IXUSR) !== 0;
            console.log(`${isExecutable ? '✅' : '❌'} ${script}: ${isExecutable ? '可执行' : '不可执行'}`);
        }
    });
} catch (error) {
    console.log('❌ 检查脚本权限时出错:', error.message);
}

console.log('');

// 测试3: 检查package.json内容
console.log('📋 测试3: 检查package.json内容');
try {
    const packageJsonPath = path.join(__dirname, 'node_modules', 'gc-npm-package', 'package.json');
    const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
    
    const requiredFields = ['name', 'version', 'description', 'main', 'bin'];
    requiredFields.forEach(field => {
        if (packageJson[field]) {
            console.log(`✅ ${field}: ${packageJson[field]}`);
        } else {
            console.log(`❌ ${field}: 缺失`);
        }
    });
} catch (error) {
    console.log('❌ 检查package.json时出错:', error.message);
}

console.log('');

// 测试4: 检查README内容
console.log('📖 测试4: 检查README内容');
try {
    const readmePath = path.join(__dirname, 'node_modules', 'gc-npm-package', 'README.md');
    const readmeContent = fs.readFileSync(readmePath, 'utf8');
    
    if (readmeContent.includes('gc-npm-package') && readmeContent.includes('Git提交工具')) {
        console.log('✅ README内容完整');
    } else {
        console.log('❌ README内容不完整');
    }
} catch (error) {
    console.log('❌ 检查README时出错:', error.message);
}

console.log('');

console.log('🎉 测试完成！');
console.log('\n💡 提示: 如果所有测试都通过，说明您的npm包工作正常！');
console.log('🚀 接下来可以创建GitHub仓库并推送代码。');
