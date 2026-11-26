.class public Lcom/qw/workshop/LogUtils;
.super Ljava/lang/Object;
.source "LogUtils.java"


# static fields
.field private static ctx:Landroid/content/Context;

.field private static sd:Ljava/lang/String;

.field private static s1:Ljava/lang/String;

.field private static s2:Ljava/lang/String;

.field private static s3:Ljava/lang/String;


.method static constructor <clinit>()V
    .locals 1

    const-string v0, ""

    sput-object v0, Lcom/qw/workshop/LogUtils;->s1:Ljava/lang/String;

    sput-object v0, Lcom/qw/workshop/LogUtils;->s2:Ljava/lang/String;

    sput-object v0, Lcom/qw/workshop/LogUtils;->s3:Ljava/lang/String;

    const-string v0, "/data/user/0/com.qw.workshop/app_logs"

    sput-object v0, Lcom/qw/workshop/LogUtils;->sd:Ljava/lang/String;

    return-void
.end method


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public static appVersion()Ljava/lang/String;
    .locals 5

    sget-object v0, Lcom/qw/workshop/LogUtils;->ctx:Landroid/content/Context;

    if-nez v0, :has

    const-string v4, "1.1.4"

    return-object v4

    :has
    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v1

    const-string v2, "com.qw.workshop"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v1

    iget-object v1, v1, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    if-eqz v1, :fb

    return-object v1

    :fb
    const-string v4, "1.1.4"
    return-object v4
.end method

.method public static appendText(Ljava/io/File;Ljava/lang/String;)V
    .locals 4

    new-instance v0, Ljava/io/FileOutputStream;

    const/4 v1, 0x1

    invoke-direct {v0, p0, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V

    new-instance v2, Ljava/io/OutputStreamWriter;

    invoke-direct {v2, v0}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;)V

    invoke-virtual {v2, p1}, Ljava/io/OutputStreamWriter;->write(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/OutputStreamWriter;->flush()V

    invoke-virtual {v2}, Ljava/io/OutputStreamWriter;->close()V

    return-void
.end method

.method public static clearCrash()V
    .locals 3

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v0

    new-instance v1, Ljava/io/File;

    const-string v2, "last_crash.txt"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    return-void
.end method

.method public static crash(Ljava/lang/Thread;Ljava/lang/Throwable;)V
    .locals 8

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "time="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/qw/workshop/LogUtils;->nowStamp()Ljava/lang/String;
    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\napp="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/qw/workshop/LogUtils;->appVersion()Ljava/lang/String;
    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\nmodel="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\nos=Android "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " sdk="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "\nthread="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, "\n\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;
    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4

    invoke-static {v4}, Lcom/qw/workshop/LogUtils;->mask(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v4

    new-instance v5, Ljava/io/File;

    const-string v6, "last_crash.txt"

    invoke-direct {v5, v0, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v5, v4}, Lcom/qw/workshop/LogUtils;->writeText(Ljava/io/File;Ljava/lang/String;)V

    const-string v6, "E"

    const-string v7, "CRASH"

    invoke-static {v6, v7, v4}, Lcom/qw/workshop/LogUtils;->log(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static cutoff()Ljava/lang/String;
    .locals 5

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0

    const-wide/32 v2, 0xf731400

    sub-long/2addr v0, v2

    invoke-static {v0, v1}, Lcom/qw/workshop/LogUtils;->dayStr(J)Ljava/lang/String;
    move-result-object v4

    return-object v4
.end method

.method public static dayStr(J)Ljava/lang/String;
    .locals 4

    new-instance v0, Ljava/util/Date;

    invoke-direct {v0, p0, p1}, Ljava/util/Date;-><init>(J)V

    new-instance v1, Ljava/text/SimpleDateFormat;

    const-string v2, "yyyy-MM-dd"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;
    move-result-object v3

    invoke-direct {v1, v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    invoke-virtual {v1, v0}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static dir()Ljava/io/File;
    .locals 2

    sget-object v0, Lcom/qw/workshop/LogUtils;->sd:Ljava/lang/String;

    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    return-object v1
.end method

.method public static info()Ljava/lang/String;
    .locals 9

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "version "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/qw/workshop/LogUtils;->appVersion()Ljava/lang/String;
    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\nbrand "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Landroid/os/Build;->BRAND:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\nmodel "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\nandroid "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " (sdk "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ")\nheap "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Runtime;->totalMemory()J
    move-result-wide v4

    const-wide/32 v6, 0x100000

    div-long/2addr v4, v6

    invoke-virtual {v0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "MB / max "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/Runtime;->maxMemory()J
    move-result-wide v4

    div-long/2addr v4, v6

    invoke-virtual {v0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "MB\nlogdir "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v8, Lcom/qw/workshop/LogUtils;->sd:Ljava/lang/String;

    if-nez v8, :hasdir

    const-string v8, "?"

    :hasdir
    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1

    return-object v1
.end method

.method public static init(Landroid/content/Context;)V
    .locals 4

    if-nez p0, :has

    return-void

    :has
    sput-object p0, Lcom/qw/workshop/LogUtils;->ctx:Landroid/content/Context;

    const/4 v3, 0x0

    const-string v1, "logs"

    invoke-virtual {p0, v1, v3}, Landroid/content/Context;->getDir(Ljava/lang/String;I)Ljava/io/File;
    move-result-object v1

    if-eqz v1, :sec

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v2

    sput-object v2, Lcom/qw/workshop/LogUtils;->sd:Ljava/lang/String;

    :sec
    const-string v1, "steam_session"

    invoke-virtual {p0, v1, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "refresh_token"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    sput-object v1, Lcom/qw/workshop/LogUtils;->s1:Ljava/lang/String;

    const-string v1, "qw_prefs"

    invoke-virtual {p0, v1, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "ck_sc"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    sput-object v1, Lcom/qw/workshop/LogUtils;->s2:Ljava/lang/String;

    const-string v1, "ck_st"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    sput-object v1, Lcom/qw/workshop/LogUtils;->s3:Ljava/lang/String;

    return-void
.end method

.method public static install(Landroid/content/Context;)V
    .locals 3

    invoke-static {p0}, Lcom/qw/workshop/LogUtils;->init(Landroid/content/Context;)V

    invoke-static {}, Ljava/lang/Thread;->getDefaultUncaughtExceptionHandler()Ljava/lang/Thread$UncaughtExceptionHandler;
    move-result-object v0

    new-instance v1, Lcom/qw/workshop/CrashHandler;

    invoke-direct {v1, v0}, Lcom/qw/workshop/CrashHandler;-><init>(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    invoke-static {v1}, Ljava/lang/Thread;->setDefaultUncaughtExceptionHandler(Ljava/lang/Thread$UncaughtExceptionHandler;)V

    const-string v0, "I"

    const-string v1, "APP"

    const-string v2, "core init, crash handler installed"

    invoke-static {v0, v1, v2}, Lcom/qw/workshop/LogUtils;->log(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/qw/workshop/LogUtils;->prune()V

    return-void
.end method

.method public static log(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v0

    if-nez p0, :lv

    const-string p0, "I"

    :lv
    if-nez p1, :tg

    const-string p1, "QW"

    :tg
    invoke-static {p2}, Lcom/qw/workshop/LogUtils;->mask(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Lcom/qw/workshop/LogUtils;->nowStamp()Ljava/lang/String;
    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v4

    new-instance v5, Ljava/io/File;

    invoke-static {}, Lcom/qw/workshop/LogUtils;->name()Ljava/lang/String;
    move-result-object v6

    invoke-direct {v5, v0, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v5, v4}, Lcom/qw/workshop/LogUtils;->appendText(Ljava/io/File;Ljava/lang/String;)V

    return-void
.end method

.method public static mask(Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    if-nez p0, :has

    const-string p0, ""

    :has
    invoke-static {p0}, Lcom/qw/workshop/LogUtils;->trim(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    sget-object v1, Lcom/qw/workshop/LogUtils;->s1:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/qw/workshop/LogUtils;->replaceSecret(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    sget-object v1, Lcom/qw/workshop/LogUtils;->s2:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/qw/workshop/LogUtils;->replaceSecret(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    sget-object v1, Lcom/qw/workshop/LogUtils;->s3:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/qw/workshop/LogUtils;->replaceSecret(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static name()Ljava/lang/String;
    .locals 5

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v0

    invoke-static {v0, v1}, Lcom/qw/workshop/LogUtils;->dayStr(J)Ljava/lang/String;
    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "qw-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ".log"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static nowStamp()Ljava/lang/String;
    .locals 4

    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    new-instance v1, Ljava/text/SimpleDateFormat;

    const-string v2, "MM-dd HH:mm:ss"

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;
    move-result-object v3

    invoke-direct {v1, v2, v3}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    invoke-virtual {v1, v0}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static prune()V
    .locals 9

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v2

    if-nez v2, :has

    return-void

    :has
    invoke-static {}, Lcom/qw/workshop/LogUtils;->cutoff()Ljava/lang/String;
    move-result-object v3

    array-length v4, v2

    const/4 v5, 0x0

    :ploop
    if-ge v5, v4, :pdone

    aget-object v0, v2, v5

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v6

    const-string v7, "qw-"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v7

    if-eqz v7, :pskip

    invoke-virtual {v6}, Ljava/lang/String;->length()I
    move-result v7

    const/16 v8, 0xd

    if-lt v7, v8, :pskip

    const/4 v7, 0x3
    const/16 v8, 0xd
    invoke-virtual {v6, v7, v8}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I
    move-result v7

    if-gez v7, :pskip


    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    :pskip
    add-int/lit8 v5, v5, 0x1

    goto :ploop

    :pdone
    return-void
.end method

.method public static readAll()Ljava/lang/String;
    .locals 9

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v1

    if-nez v1, :has

    const-string v0, ""

    return-object v0

    :has
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    array-length v3, v1

    const/4 v4, 0x0

    :aloop
    if-ge v4, v3, :adone

    aget-object v5, v1, v4

    invoke-virtual {v5}, Ljava/io/File;->getName()Ljava/lang/String;
    move-result-object v6

    const-string v7, "===== "

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " =====\n"

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v5}, Lcom/qw/workshop/LogUtils;->readFile(Ljava/io/File;)Ljava/lang/String;
    move-result-object v6

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "\n"

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v4, v4, 0x1

    goto :aloop

    :adone
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    return-object v5
.end method

.method public static readCrash()Ljava/lang/String;
    .locals 4

    invoke-static {}, Lcom/qw/workshop/LogUtils;->dir()Ljava/io/File;
    move-result-object v0

    new-instance v1, Ljava/io/File;

    const-string v2, "last_crash.txt"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z
    move-result v3

    if-nez v3, :yes

    const-string v0, ""

    return-object v0

    :yes
    invoke-static {v1}, Lcom/qw/workshop/LogUtils;->readFile(Ljava/io/File;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static readFile(Ljava/io/File;)Ljava/lang/String;
    .locals 6

    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v2, 0x1000

    new-array v2, v2, [B

    :rloop
    invoke-virtual {v0, v2}, Ljava/io/FileInputStream;->read([B)I
    move-result v3

    if-gtz v3, :rread

    goto :rend

    :rread
    const/4 v4, 0x0

    invoke-virtual {v1, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :rloop

    :rend
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B
    move-result-object v2

    new-instance v3, Ljava/lang/String;

    const-string v4, "UTF-8"

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    return-object v3
.end method

.method public static replaceSecret(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 5

    invoke-virtual {p1}, Ljava/lang/String;->length()I
    move-result v2

    const/16 v3, 0x8

    if-ge v2, v3, :long

    return-object p0

    :long
    const-string v4, "***"

    invoke-virtual {p0, p1, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static trim(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    invoke-virtual {p0}, Ljava/lang/String;->length()I
    move-result v1

    const/16 v2, 0x7d0

    if-gt v1, v2, :small

    return-object p0

    :small
    const/4 v2, 0x0

    const/16 v3, 0x4b0

    invoke-virtual {p0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v3

    invoke-virtual {p0}, Ljava/lang/String;->length()I
    move-result v1

    add-int/lit16 v1, v1, -0x12c

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n...(truncated)...\n"

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public static writeText(Ljava/io/File;Ljava/lang/String;)V
    .locals 3

    new-instance v0, Ljava/io/FileOutputStream;

    invoke-direct {v0, p0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    new-instance v1, Ljava/io/OutputStreamWriter;

    invoke-direct {v1, v0}, Ljava/io/OutputStreamWriter;-><init>(Ljava/io/OutputStream;)V

    invoke-virtual {v1, p1}, Ljava/io/OutputStreamWriter;->write(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/OutputStreamWriter;->flush()V

    invoke-virtual {v1}, Ljava/io/OutputStreamWriter;->close()V

    return-void
.end method