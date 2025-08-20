#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

try {
    // 设置主要脚本的执行权限
    ['gc', 'git-commit.sh', 'code-analyzer.sh'].forEach(f => {
        try {
            fs.chmodSync(f, 0o755);
            console.log(`✅ 设置执行权限: ${f}`);
        } catch(e) {
            console.log(`⚠️  无法设置权限: ${f} - ${e.message}`);
        }
    });

    // 设置测试脚本的执行权限
    try {
        if (fs.existsSync('test')) {
            fs.readdirSync('test').forEach(f => {
                if(f.endsWith('.sh')) {
                    try {
                        fs.chmodSync(path.join('test', f), 0o755);
                        console.log(`✅ 设置执行权限: test/${f}`);
                    } catch(e) {
                        console.log(`⚠️  无法设置权限: test/${f} - ${e.message}`);
                    }
                }
            });
        }
    } catch(e) {
        console.log(`⚠️  处理测试目录时出错: ${e.message}`);
    }

    console.log('🎉 postinstall 脚本执行完成');
} catch(e) {
    console.error(`❌ postinstall 脚本执行失败: ${e.message}`);
    process.exit(1);
}

