# 下载器核心改动说明（patch notes）

本文件记录本项目相对上游 `we-workshop` 在**下载器核心**上的改动，供需要复现完整功能的人参考。
仓库里**不包含**那部分 smali 的整包副本，原因见最后一节。

## 两部分代码的分工

| 位置 | 作用 |
| --- | --- |
| 本仓库 `smali/`（包名 `com.qw.workshop`） | 桥接层：HTTP、文件读写、任务调度、解包调用、登录流程 |
| 上游 `com.prototypejust.weworkshop.steam` | 下载协议核心：`WorkshopDownloader`（约 68KB Kotlin 对应 437KB smali）、`SteamService` |

## 本项目在下载核心上改的三处（v0.9.31 起）

目标是让「下载保存路径」固定为 `/storage/emulated/0/QW-Workshop/<作品ID>/`，不再跟随 MediaStore 默认的 Download 目录：

1. **MediaStore 写入路径**：`RELATIVE_PATH` 常量由 `Download/QW-Workshop` 改为裸目录名 `QW-Workshop`
   —— 按卷根解析，实际落到 `/sdcard/QW-Workshop/`。
2. **File 回退路径**：MediaStore 抛异常时走的 `File` 回退分支，目录名同步改为 `QW-Workshop`。
3. **返回给界面的显示路径**：三处路径常量统一，避免界面显示的路径与实际落盘位置不一致。

改完后需全量重汇编该包 smali 为 `classes2.dex`，与主 dex 一起打包。smali 里对应方法是
`WorkshopDownloader` 中的写盘相关方法（关键常量是字符串 `QW-Workshop`），搜索该字符串即可定位。

## 为什么不上传整包

- 体积：`smali/` 整包 69MB / 3036 个文件，其中绝大部分是上游包的第三方反编译产物，对阅读本项目毫无帮助。
- 尊重上游：那部分是上游作者的实现，本项目只主张自己写的代码与自己的改动。
- 可复现性：需要完整版的人按上面三处自行修改上游源码/反编译产物即可，改动量只有三个常量。

如需完整构建链（dex 合并 + 对齐 + 签名），可参考 [构建与签名.md](构建与签名.md)。