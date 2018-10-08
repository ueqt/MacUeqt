#  Mac Ueqt

Ueqt's Mac Assistant

因为不想系统中软件过多，所以想把各种软件集成到一起，所以自己写一个吧

* Only for self usage, so many feature is only tested on my mac.

## Feature

[x] Open Finder current path in iTerm
[ ] Calendar
[ ] Cpu usage
[ ] Memory usage
[ ] Network usage
[x ] Start at login

## 如果 start at login 功能失败

```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -dump|grep .*path.*MacUeqt.
```

删除相关多余目录

```bash
# 重置数据库
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
```
