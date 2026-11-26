# 版本记录

版本号规则：`X.Y.Z`，versionCode 递增。改动分「新增 / 修复 / 优化 / 安全 / 适配」。

## v1.1.4 — versionCode 131（2026-11）
**新增 / 变更**
- 诊断面板「分享日志」改为「下载日志」：不再走 `ACTION_SEND`，直接把日志写成 TXT 落到
  `/storage/emulated/0/Download/QW-Workshop-日志/qw-log-yyyyMMdd-HHmmss.txt`，内容含版本设备信息 + 全部日志 + 崩溃记录
**修复**
- `LogProvider.openFile` 两处判空写反（「不含 `..` 就判 bad」「目录非空就判 bad」），这是「分享日志点了没反应」的真因
- `MainActivity.hideLogin` 两处判空写反：`web2` 非空时反而提前返回（登录 WebView 泄漏）、`web2` 为空时反而继续
  `destroy()` → 退出应用时 `NullPointerException`（`last_crash.txt` 里那条 `Unable to destroy activity` 就是它）
- `CrashHandler.uncaughtException` 判空写反：`prev` 非空时反而直接杀进程、为空时反而调用它（潜在 NPE）
- `LogUtils.appVersion` 判空写反 + 兜底常量未更新，导致日志与崩溃文件里版本号恒为旧值

## v1.1.3 — versionCode 130（2026-11）
**新增**
- 日志系统：按日期分文件写入私有目录 `app_logs/qw-YYYY-MM-DD.log`，只保留最近 3 天，启动时自动清理过期文件
- 崩溃捕获：全局 `UncaughtExceptionHandler`，堆栈写入 `last_crash.txt`，含版本号 / 机型 / 系统版本 / 线程名
- 诊断面板：版本与设备信息、一键复制、`ACTION_SEND` 分享；崩溃后红字提示
- 性能采样：帧间隔卡顿（>120ms）、长任务、滑不动、长按无响应、点击延迟五类信号 + 环境快照；累积后写 `[SUM]` 摘要，诊断面板附「性能采样」汇总
**安全**
- 脱敏在写盘前完成：Steam refresh_token、cookie（ck_sc / ck_st）及通用敏感字段一律掩码，长度不足 8 位的串不参与掩码
**修复**
- smali 条件分支方向写反导致的静默跳过（`if-eqz` / `if-nez` 语义混用）；分支目标不再指向方法末尾 `return`
- 日志保留策略误判：只清理以 `qw-` 开头的文件名，避免误删 `last_crash.txt`

## v1.1.2 — versionCode 129（2026-11）
**修复**
- 列表滚动失效：`overflow: clip` 与 `backdrop-filter: blur()` 在部分 WebView 下导致滚动容器无法滚动，改为 `@supports` 渐进降级并加 `unfreeze` 兜底

## v1.1.1 — versionCode 128（2026-11）
**优化**
- 登录会话重构：浏览与下载共用一次登录，不再重复登录；会话只保存打码账号名，不落明文

## v1.1.0 — versionCode 127（2026-11）

**文档**
- 归属表述统一为「基于 https://github.com/weilund/we-workshop/blob/main/README.md 开发」，不再使用「参考…重新实现」的说法（免责声明、顶栏副标题、设置页关于、README 共 4 处）
- README 明确写出「国内网络大概率连不上 Steam，需自备 VPN / 加速器」「下载只走 Steam 官方 CDN」「必须登录才能下载原文件」
- 新增 LICENSE（非商业许可）、.gitignore、CHANGELOG、构建脚本 `tools/build.sh`

**安全**
- 不再明文保存 Steam 账号：旧版 `qw_lastacc` 启动时迁移为打码显示名（如 `c***58`）并抹除明文
- 登录框不再回填明文账号，仅以打码名作占位提示

**修复**
- 场景作品「提取项目中的图片」按钮判定被错误缓存为 false，导致按钮永久消失
- 断点续传进度计算错误；重新下载未重置读取器导致文件内容拼接错乱
- 详情页快速连点造成内容错乱（引入请求序号防竞态）

**适配**
- 重排响应式断点：默认手机 2 列 / 平板 4 列，不再被媒体查询强制改写
- 触控热区 ≥ 44px；免责声明、弹窗在小屏上可滚动，长内容不再顶出屏幕挤掉按钮

**优化**
- 下载记录上限 200 条；下载列表改增量渲染，长列表不再卡顿
- 调试日志默认关闭

## v1.0.1 — versionCode 100

- 修复筛选条件在重启后丢失
- 修复下载列表「移除」按钮误删记录

## v1.0.0 — versionCode 100（首个正式版）

- 创意工坊列表：搜索、排序、场景 / 类型 / 内容分类 / 年龄分级多选筛选（条件本地记忆）
- 详情页：封面大图、作者、订阅数、简介，双击查看原图
- 下载：下载封面 / 下载原项目（断点续传、进度、暂停 / 继续、重试）
- 下载管理：多选批量删除、打开所在目录、重新下载
- 场景类作品支持「提取项目中的图片」（`scene.pkg` 解包导出到 `图片/`）
- 加入首次启动免责声明、手机 / 平板双端自适应