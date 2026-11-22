.class public Lcom/qw/workshop/Bridge;
.super Ljava/lang/Object;
.source "Bridge.java"


# instance fields
.field private final act:Landroid/app/Activity;

.field private final handler:Landroid/os/Handler;


# direct methods
.method public constructor <init>(Landroid/app/Activity;)V
    .locals 3

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/qw/workshop/Bridge;->handler:Landroid/os/Handler;

    return-void
.end method

.method private doPost(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 12

    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    const/16 v1, 0x1770

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v1, 0x2ee0

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v1, "POST"

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setDoInput(Z)V

    const-string v1, "Content-Type"

    const-string v2, "application/x-www-form-urlencoded; charset=UTF-8"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "User-Agent"

    const-string v2, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Referer"

    const-string v2, "https://steamcommunity.com/"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Origin"

    const-string v2, "https://steamcommunity.com"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "X-Requested-With"

    const-string v2, "XMLHttpRequest"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :try_start_ckp
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v8

    invoke-virtual {v8, p1}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    if-eqz v9, :ckp_done

    const-string v10, "Cookie"

    invoke-virtual {v0, v10, v9}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_ckp
    .catch Ljava/lang/Throwable; {:try_start_ckp .. :try_end_ckp} :ckp_done

    :ckp_done
    const-string v7, "UTF-8"

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;
    move-result-object v1

    invoke-virtual {p2, v7}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V

    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v6

    invoke-direct {p0, v0, p1}, Lcom/qw/workshop/Bridge;->keepCookies(Ljava/net/HttpURLConnection;Ljava/lang/String;)V

    const/16 v1, 0x190

    if-lt v6, v1, :cond_ok

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;
    move-result-object v2

    goto :goto_read

    :cond_ok
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v2

    :goto_read
    new-instance v5, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v5}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x2000

    new-array v3, v1, [B

    :goto_loop
    invoke-virtual {v2, v3}, Ljava/io/InputStream;->read([B)I
    move-result v4

    if-lez v4, :goto_done

    const/4 v1, 0x0

    invoke-virtual {v5, v3, v1, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_loop

    :goto_done
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    invoke-virtual {v5, v7}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method private keepCookies(Ljava/net/HttpURLConnection;Ljava/lang/String;)V
    .locals 6

    :try_start_kc
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v0

    const/4 v1, 0x1

    :kc_loop
    invoke-virtual {p1, v1}, Ljava/net/HttpURLConnection;->getHeaderField(I)Ljava/lang/String;

    move-result-object v2

    if-nez v2, :kc_end

    invoke-virtual {p1, v1}, Ljava/net/HttpURLConnection;->getHeaderFieldKey(I)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :kc_next

    const-string v4, "Set-Cookie"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :kc_next

    invoke-virtual {v0, p2, v2}, Landroid/webkit/CookieManager;->setCookie(Ljava/lang/String;Ljava/lang/String;)V

    :kc_next
    add-int/lit8 v1, v1, 0x1

    goto :kc_loop

    :kc_end
    invoke-virtual {v0}, Landroid/webkit/CookieManager;->flush()V
    :try_end_kc
    .catch Ljava/lang/Throwable; {:try_start_kc .. :try_end_kc} :kc_ret

    :kc_ret
    return-void
.end method

.method private prefs()Landroid/content/SharedPreferences;
    .locals 3

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const-string v1, "qw_prefs"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0

    return-object v0
.end method


.method private doGet(Ljava/lang/String;)Ljava/lang/String;
    .locals 12

    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v0

    check-cast v0, Ljava/net/HttpURLConnection;

    const/16 v1, 0x1770

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v1, 0x2ee0

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const-string v1, "GET"

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setDoInput(Z)V

    invoke-virtual {v0, v1}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    const-string v1, "User-Agent"

    const-string v2, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Accept"

    const-string v2, "text/html,application/xhtml+xml,application/json;q=0.9,*/*;q=0.8"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Accept-Language"

    const-string v2, "zh-CN,zh;q=0.9,en;q=0.8"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    const-string v1, "Referer"

    const-string v2, "https://steamcommunity.com/"

    invoke-virtual {v0, v1, v2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    :try_start_ck
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v8

    invoke-virtual {v8, p1}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    if-eqz v9, :ck_done

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v10

    if-lez v10, :ck_done

    const-string v1, "Cookie"

    invoke-virtual {v0, v1, v9}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_ck
    .catch Ljava/lang/Throwable; {:try_start_ck .. :try_end_ck} :ck_done
:ck_done
    const-string v7, "UTF-8"

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v6

    invoke-direct {p0, v0, p1}, Lcom/qw/workshop/Bridge;->keepCookies(Ljava/net/HttpURLConnection;Ljava/lang/String;)V

    const/16 v1, 0x190

    if-lt v6, v1, :cond_get_ok

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;
    move-result-object v2

    goto :goto_get_read

    :cond_get_ok
    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v2

    :goto_get_read
    new-instance v5, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v5}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x2000

    new-array v3, v1, [B

    :goto_get_loop
    invoke-virtual {v2, v3}, Ljava/io/InputStream;->read([B)I
    move-result v4

    if-lez v4, :goto_get_done

    const/4 v1, 0x0

    invoke-virtual {v5, v3, v1, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_get_loop

    :goto_get_done
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    invoke-virtual {v0}, Ljava/net/HttpURLConnection;->disconnect()V

    invoke-virtual {v5, v7}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public exit()V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    new-instance v0, Lcom/qw/workshop/Bridge$Task;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-direct {v0, p0, v1, v2}, Lcom/qw/workshop/Bridge$Task;-><init>(Lcom/qw/workshop/Bridge;ILjava/lang/String;)V

    iget-object v3, p0, Lcom/qw/workshop/Bridge;->handler:Landroid/os/Handler;

    invoke-virtual {v3, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public getAct()Landroid/app/Activity;
    .locals 1

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    return-object v0
.end method

.method public openPath(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_op
    new-instance v0, Ljava/io/File;
    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->exists()Z
    move-result v1
    if-nez v1, :op_isdir
    const-string v1, "noexist"
    return-object v1

    :op_isdir
    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z
    move-result v1
    if-nez v1, :op_hasparent
    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v0

    :op_hasparent
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v1
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;
    move-result-object v2
    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-nez v3, :op_strip
    invoke-virtual {v2}, Ljava/lang/String;->length()I
    move-result v3
    invoke-virtual {v1, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v1

    :op_strip
    const-string v3, "/"
    invoke-virtual {v1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v4
    if-eqz v4, :op_enc
    const/4 v4, 0x1
    invoke-virtual {v1, v4}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v1

    :op_enc
    invoke-static {v1}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "content://com.android.externalstorage.documents/document/primary%3A"
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v1
    new-instance v4, Landroid/content/Intent;
    const-string v5, "android.intent.action.VIEW"
    invoke-direct {v4, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V
    const-string v5, "vnd.android.document/directory"
    invoke-virtual {v4, v1, v5}, Landroid/content/Intent;->setDataAndType(Landroid/net/Uri;Ljava/lang/String;)Landroid/content/Intent;
    const/4 v5, 0x1
    invoke-virtual {v4, v5}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    const/high16 v5, 0x10000000
    invoke-virtual {v4, v5}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    new-instance v6, Landroid/content/Intent;
    invoke-direct {v6, v4}, Landroid/content/Intent;-><init>(Landroid/content/Intent;)V
    const-string v5, "com.android.documentsui"
    invoke-virtual {v6, v5}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;
    iget-object v7, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    invoke-virtual {v7}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v7
    const/4 v5, 0x0
    invoke-virtual {v7, v6, v5}, Landroid/content/pm/PackageManager;->resolveActivity(Landroid/content/Intent;I)Landroid/content/pm/ResolveInfo;
    move-result-object v7
    if-eqz v7, :op_generic
    iget-object v7, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    invoke-virtual {v7, v6}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    goto :op_ok

    :op_generic
    iget-object v7, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    invoke-virtual {v7, v4}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    :op_ok
    const-string v1, "ok"
    return-object v1
    :try_end_op
    .catch Ljava/lang/Throwable; {:try_start_op .. :try_end_op} :catch_op

    :catch_op
    move-exception v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "err:"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/Throwable;->getClass()Ljava/lang/Class;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    return-object v1
.end method

.method public getDir()Ljava/lang/String;
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_gd
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->dirBase()Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v0
    :try_end_gd
    .catch Ljava/lang/Throwable; {:try_start_gd .. :try_end_gd} :gd_catch
    return-object v0

    :gd_catch
    const-string v0, "/storage/emulated/0/QW-Workshop"
    return-object v0
.end method

.method public probe(Ljava/lang/String;)V
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    const-string v0, "QWJS"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public getVersion()Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    const-string v0, "1.0.0"

    return-object v0
.end method

.method public httpPost(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 6
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-direct {p0, p1, p2}, Lcom/qw/workshop/Bridge;->doPost(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "{\"ok\":false,\"err\":\""

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\"}"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public openUrl(Ljava/lang/String;)V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    new-instance v0, Lcom/qw/workshop/Bridge$Task;

    const/4 v1, 0x2

    invoke-direct {v0, p0, v1, p1}, Lcom/qw/workshop/Bridge$Task;-><init>(Lcom/qw/workshop/Bridge;ILjava/lang/String;)V

    iget-object v2, p0, Lcom/qw/workshop/Bridge;->handler:Landroid/os/Handler;

    invoke-virtual {v2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public setDir(Ljava/lang/String;)Z
    .locals 5
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    if-nez p1, :cond_1

    const/4 v0, 0x0

    return v0

    :cond_1
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->length()I
    move-result v2

    if-nez v2, :cond_2

    const/4 v0, 0x0

    return v0

    :cond_2
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;
    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v3

    const-string v4, "download_dir"

    invoke-interface {v3, v4, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->commit()Z
    move-result v0

    return v0
.end method

.method public getLogin()Ljava/lang/String;
    .locals 3
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "steamid"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method
.method public setLogin(Ljava/lang/String;)V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "steamid"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result v1

    return-void
.end method

.method public getUri()Ljava/lang/String;
    .locals 3
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "dir_uri"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public pickDir()V
    .locals 6
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_pk
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :pk_perm

    invoke-static {}, Landroid/os/Environment;->isExternalStorageManager()Z

    move-result v2

    if-nez v2, :pk_perm

    new-instance v3, Landroid/content/Intent;

    const-string v4, "android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION"

    invoke-direct {v3, v4}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "package:"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    iget-object v5, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-virtual {v5}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    iget-object v4, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const/16 v5, 0x52

    invoke-virtual {v4, v3, v5}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    goto :pk_ret

    :pk_perm
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :pk_tree

    iget-object v2, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const-string v3, "android.permission.READ_EXTERNAL_STORAGE"

    invoke-virtual {v2, v3}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :pk_tree

    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/String;

    const/4 v4, 0x0

    aput-object v3, v5, v4

    const/16 v3, 0x53

    invoke-virtual {v2, v5, v3}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    goto :pk_ret

    :pk_tree
    iget-object v2, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-static {v2}, Lcom/qw/workshop/Bridge;->openTreeFor(Landroid/app/Activity;)V
    :try_end_pk
    .catch Ljava/lang/Throwable; {:try_start_pk .. :try_end_pk} :pk_catch

    goto :pk_ret

    :pk_catch
    move-exception v0

    :pk_ret
    return-void
.end method

.method public static openTreeFor(Landroid/app/Activity;)V
    .locals 3

    :try_start_ot
    if-eqz p0, :ot_ret

    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.OPEN_DOCUMENT_TREE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const/16 v1, 0xc3

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const/16 v2, 0x51

    invoke-virtual {p0, v0, v2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    const-string v0, "QWJS"

    const-string v1, "OAR ask tree picker"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_ot
    .catch Ljava/lang/Throwable; {:try_start_ot .. :try_end_ot} :ot_catch

    goto :ot_ret

    :ot_catch
    move-exception v0

    const-string v0, "QWJS"

    const-string v1, "OAR tree picker failed"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :ot_ret
    return-void
.end method

.method public httpGet(Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_g
    invoke-direct {p0, p1}, Lcom/qw/workshop/Bridge;->doGet(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    :try_end_g
    .catch Ljava/lang/Throwable; {:try_start_g .. :try_end_g} :catch_g

    return-object v0

    :catch_g
    move-exception v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "{\"ok\":false,\"err\":\""

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\"}"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0

    return-object v0
.end method

.method public logout()V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;
    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    const-string v1, "steamid"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z
    move-result v1

    :try_start_lo
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/webkit/CookieManager;->removeAllCookies(Landroid/webkit/ValueCallback;)V

    invoke-virtual {v2}, Landroid/webkit/CookieManager;->flush()V

    invoke-static {}, Landroid/webkit/WebStorage;->getInstance()Landroid/webkit/WebStorage;
    move-result-object v2

    invoke-virtual {v2}, Landroid/webkit/WebStorage;->deleteAllData()V

    :try_end_lo
    .catch Ljava/lang/Throwable; {:try_start_lo .. :try_end_lo} :catch_lo

    return-void

    :catch_lo
    move-exception v2

    return-void
.end method

.method public startLogin()V
    .locals 3
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_l
    new-instance v0, Landroid/content/Intent;

    iget-object v1, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const-class v2, Lcom/qw/workshop/SteamLoginActivity;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v1, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_l
    .catch Ljava/lang/Throwable; {:try_start_l .. :try_end_l} :catch_l

    return-void

    :catch_l
    move-exception v1

    return-void
.end method

.method public toast(Ljava/lang/String;)V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    new-instance v0, Lcom/qw/workshop/Bridge$Task;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1, p1}, Lcom/qw/workshop/Bridge$Task;-><init>(Lcom/qw/workshop/Bridge;ILjava/lang/String;)V

    iget-object v2, p0, Lcom/qw/workshop/Bridge;->handler:Landroid/os/Handler;

    invoke-virtual {v2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
.method public saveUrl(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_su
    invoke-virtual {p0}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v0

    const-string v1, "download"
    invoke-virtual {v0, v1}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/DownloadManager;

    new-instance v2, Landroid/app/DownloadManager$Request;
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v3
    invoke-direct {v2, v3}, Landroid/app/DownloadManager$Request;-><init>(Landroid/net/Uri;)V

    invoke-virtual {v2, p2}, Landroid/app/DownloadManager$Request;->setTitle(Ljava/lang/CharSequence;)Landroid/app/DownloadManager$Request;

    const/4 v4, 0x1
    invoke-virtual {v2, v4}, Landroid/app/DownloadManager$Request;->setNotificationVisibility(I)Landroid/app/DownloadManager$Request;
    invoke-virtual {v2, v4}, Landroid/app/DownloadManager$Request;->setAllowedOverMetered(Z)Landroid/app/DownloadManager$Request;
    invoke-virtual {v2, v4}, Landroid/app/DownloadManager$Request;->setAllowedOverRoaming(Z)Landroid/app/DownloadManager$Request;

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "QW-Workshop/"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5

    sget-object v6, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;
    invoke-virtual {v2, v6, v5}, Landroid/app/DownloadManager$Request;->setDestinationInExternalPublicDir(Ljava/lang/String;Ljava/lang/String;)Landroid/app/DownloadManager$Request;

    invoke-virtual {v1, v2}, Landroid/app/DownloadManager;->enqueue(Landroid/app/DownloadManager$Request;)J
    move-result-wide v3
    invoke-static {v3, v4}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;
    move-result-object v0
    :try_end_su
    .catch Ljava/lang/Throwable; {:try_start_su .. :try_end_su} :catch_su
    return-object v0

    :catch_su
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v1
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "{\"ok\":false,\"err\":\""
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v3, "\"}"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method.method public saveText(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_st
    invoke-virtual {p0}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v0
    invoke-virtual {v0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;
    move-result-object v0

    new-instance v1, Ljava/io/File;
    invoke-direct {v1, v0, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v2, Ljava/io/FileOutputStream;
    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const-string v3, "UTF-8"
    invoke-virtual {p2, v3}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    move-result-object v3
    invoke-virtual {v2, v3}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v0
    :try_end_st
    .catch Ljava/lang/Throwable; {:try_start_st .. :try_end_st} :catch_st
    return-object v0

    :catch_st
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public getCookies(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_gc
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;
    move-result-object v0
    invoke-virtual {v0, p1}, Landroid/webkit/CookieManager;->getCookie(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-nez v0, :gc_empty
    return-object v0

    :gc_empty
    const-string v0, ""
    return-object v0
    :try_end_gc
    .catch Ljava/lang/Throwable; {:try_start_gc .. :try_end_gc} :catch_gc

    :catch_gc
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method.method public dlOne(Ljava/lang/String;)Ljava/lang/String;
    .locals 12
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_do
    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0

    const/4 v2, 0x1
    new-array v2, v2, [J
    const/4 v3, 0x0
    aput-wide v0, v2, v3

    invoke-virtual {p0}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v3
    const-string v4, "download"
    invoke-virtual {v3, v4}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/DownloadManager;

    new-instance v4, Landroid/app/DownloadManager$Query;
    invoke-direct {v4}, Landroid/app/DownloadManager$Query;-><init>()V
    invoke-virtual {v4, v2}, Landroid/app/DownloadManager$Query;->setFilterById([J)Landroid/app/DownloadManager$Query;
    invoke-virtual {v3, v4}, Landroid/app/DownloadManager;->query(Landroid/app/DownloadManager$Query;)Landroid/database/Cursor;
    move-result-object v5

    if-nez v5, :do_none
    invoke-interface {v5}, Landroid/database/Cursor;->moveToFirst()Z
    move-result v6
    if-eqz v6, :do_none

    const-string v6, "status"
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v6
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getInt(I)I
    move-result v7

    const-string v6, "total_size"
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v6
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getLong(I)J
    move-result-wide v8

    const-string v6, "bytes_so_far"
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I
    move-result v6
    invoke-interface {v5, v6}, Landroid/database/Cursor;->getLong(I)J
    move-result-wide v10

    invoke-interface {v5}, Landroid/database/Cursor;->close()V

    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, "|"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v10, v11}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :do_none
    const-string v0, "-1|0|0"
    return-object v0
    :try_end_do
    .catch Ljava/lang/Throwable; {:try_start_do .. :try_end_do} :catch_do

    :catch_do
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public dlRemove(Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_dr
    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0

    const/4 v2, 0x1
    new-array v2, v2, [J
    const/4 v3, 0x0
    aput-wide v0, v2, v3

    invoke-virtual {p0}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v3
    const-string v4, "download"
    invoke-virtual {v3, v4}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Landroid/app/DownloadManager;
    invoke-virtual {v3, v2}, Landroid/app/DownloadManager;->remove([J)I
    move-result v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v0
    :try_end_dr
    .catch Ljava/lang/Throwable; {:try_start_dr .. :try_end_dr} :catch_dr
    return-object v0

    :catch_dr
    move-exception v0
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


.method private privBase()Ljava/io/File;
    .locals 3
    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/app/Activity;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    if-nez v0, :pb_dir
    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    invoke-virtual {v0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;
    move-result-object v0
    :pb_dir
    new-instance v1, Ljava/io/File;
    const-string v2, "QW-Workshop"
    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    return-object v1
.end method

.method private pickBase()Ljava/io/File;
    .locals 3
    :try_start_pk
    new-instance v0, Ljava/io/File;
    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;
    move-result-object v1
    const-string v2, "QW-Workshop"
    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z
    new-instance v1, Ljava/io/File;
    const-string v2, ".qw_probe"
    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->delete()Z
    invoke-virtual {v1}, Ljava/io/File;->createNewFile()Z
    move-result v2
    if-eqz v2, :pk_priv
    invoke-virtual {v1}, Ljava/io/File;->delete()Z
    return-object v0
    :pk_priv
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->privBase()Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z
    :try_end_pk
    .catch Ljava/lang/Throwable; {:try_start_pk .. :try_end_pk} :pk_catch
    return-object v0
    :pk_catch
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->privBase()Ljava/io/File;
    move-result-object v0
    return-object v0
.end method

.method private dirBase()Ljava/io/File;
    .locals 1
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->pickBase()Ljava/io/File;
    move-result-object v0
    return-object v0
.end method

.method private fileOf(Ljava/lang/String;)Ljava/io/File;
    .locals 3
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->dirBase()Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z
    new-instance v1, Ljava/io/File;
    invoke-direct {v1, v0, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/io/File;->getParentFile()Ljava/io/File;
    move-result-object v2
    if-eqz v2, :fo_ok
    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z
    :fo_ok
    return-object v1
.end method

.method public saveBytes(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_sb
    invoke-direct {p0, p1}, Lcom/qw/workshop/Bridge;->fileOf(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    const/4 v1, 0x0
    invoke-static {p2, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B
    move-result-object v1
    new-instance v2, Ljava/io/FileOutputStream;
    invoke-direct {v2, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    invoke-virtual {v2, v1}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ok:"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    :try_end_sb
    .catch Ljava/lang/Throwable; {:try_start_sb .. :try_end_sb} :catch_sb
    return-object v0

    :catch_sb
    move-exception v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "err:"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method


.method public storageState()Ljava/lang/String;
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 3
    :try_start_st
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->pickBase()Ljava/io/File;
    move-result-object v0
    if-nez v0, :st_need
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v1
    const-string v2, "Android/data"
    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v2
    if-eqz v2, :st_ok
    const-string v0, "need"
    return-object v0
    :st_ok
    const-string v0, "ok"
    return-object v0
    :st_need
    :try_end_st
    .catch Ljava/lang/Throwable; {:try_start_st .. :try_end_st} :st_catch
    const-string v0, "need"
    return-object v0
    :st_catch
    const-string v0, "need"
    return-object v0
.end method

.method public askStorage()Ljava/lang/String;
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 5
    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v2, 0x1e
    if-lt v1, v2, :as_legacy
    new-instance v1, Landroid/content/Intent;
    const-string v2, "android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION"
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    const-string v4, "package:"
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v3
    invoke-direct {v1, v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V
    :try_start_as
    invoke-virtual {v0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_as
    .catch Landroid/content/ActivityNotFoundException; {:try_start_as .. :try_end_as} :catch_as
    const-string v0, "asked"
    return-object v0
    :catch_as
    const/4 v1, 0x2
    new-array v2, v1, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v3, "android.permission.WRITE_EXTERNAL_STORAGE"
    aput-object v3, v2, v1
    const/4 v1, 0x1
    const-string v3, "android.permission.READ_EXTERNAL_STORAGE"
    aput-object v3, v2, v1
    const/16 v1, 0x2711
    invoke-virtual {v0, v2, v1}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V
    const-string v0, "asked"
    return-object v0
    :as_legacy
    const/4 v1, 0x1
    new-array v2, v1, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v3, "android.permission.WRITE_EXTERNAL_STORAGE"
    aput-object v3, v2, v1
    const/16 v1, 0x2711
    invoke-virtual {v0, v2, v1}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V
    const-string v0, "asked"
    return-object v0
.end method

.method public appendBytes(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_ab
    invoke-direct {p0, p1}, Lcom/qw/workshop/Bridge;->fileOf(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    const/4 v1, 0x0
    invoke-static {p2, v1}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B
    move-result-object v1
    new-instance v2, Ljava/io/FileOutputStream;
    const/4 v3, 0x1
    invoke-direct {v2, v0, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V
    invoke-virtual {v2, v1}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ok:"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/io/File;->length()J
    move-result-wide v3
    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    :try_end_ab
    .catch Ljava/lang/Throwable; {:try_start_ab .. :try_end_ab} :catch_ab
    return-object v0

    :catch_ab
    move-exception v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "err:"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method public fileLen(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_fl
    invoke-direct {p0, p1}, Lcom/qw/workshop/Bridge;->fileOf(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->length()J
    move-result-wide v0
    invoke-static {v0, v1}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;
    move-result-object v0
    :try_end_fl
    .catch Ljava/lang/Throwable; {:try_start_fl .. :try_end_fl} :catch_fl
    return-object v0

    :catch_fl
    move-exception v0
    const-string v0, "0"
    return-object v0
.end method

.method public resetFile(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_rf
    invoke-direct {p0, p1}, Lcom/qw/workshop/Bridge;->fileOf(Ljava/lang/String;)Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->exists()Z
    move-result v1
    if-eqz v1, :rf_no
    invoke-virtual {v0}, Ljava/io/File;->delete()Z
    :rf_no
    const-string v0, "ok"
    :try_end_rf
    .catch Ljava/lang/Throwable; {:try_start_rf .. :try_end_rf} :catch_rf
    return-object v0

    :catch_rf
    move-exception v0
    const-string v0, "err"
    return-object v0
.end method

.method public finishApp()V
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_fa
    invoke-virtual {p0}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v0
    if-eqz v0, :fa_end
    invoke-virtual {v0}, Landroid/app/Activity;->finish()V
    :fa_end
    :try_end_fa
    .catch Ljava/lang/Throwable; {:try_start_fa .. :try_end_fa} :catch_fa
    return-void

    :catch_fa
    move-exception v0
    return-void
.end method
# ===== v0.9.0 原生 Steam 下载桥（追加到 com/qw/workshop/Bridge.smali 末尾） =====
# 目的：让新版壳直接复用旧基座（com.prototypejust.weworkshop.steam.*）的
#      JavaSteam 登录 + depot 清单 + CDN 分块下载能力，不再依赖终端 DepotDownloader。

.method public stInit()V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 1

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-static {v0}, Lcom/prototypejust/weworkshop/steam/SteamService;->init(Landroid/content/Context;)V

    return-void
.end method

.method public stState()Ljava/lang/String;
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 1

    invoke-static {}, Lcom/prototypejust/weworkshop/steam/SteamService;->stateJson()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public stLogin(Ljava/lang/String;Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 0

    invoke-static {p1, p2}, Lcom/prototypejust/weworkshop/steam/SteamService;->loginAsync(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public stGuard(Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 0

    invoke-static {p1}, Lcom/prototypejust/weworkshop/steam/SteamService;->submitGuardCode(Ljava/lang/String;)V

    return-void
.end method

.method public stLogout()V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 0

    invoke-static {}, Lcom/prototypejust/weworkshop/steam/SteamService;->logout()V

    return-void
.end method

.method public itemStart(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 8

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v1

    invoke-static {p2}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v3

    move-object v5, p3

    move-object v6, p4

    invoke-static/range {v0 .. v6}, Lcom/prototypejust/weworkshop/steam/WorkshopDownloader;->downloadAsync(Landroid/content/Context;JJLjava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public itemProgress(Ljava/lang/String;)Ljava/lang/String;
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 3

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v0

    invoke-static {v0, v1}, Lcom/prototypejust/weworkshop/steam/WorkshopDownloader;->progressJson(J)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public itemActive()Ljava/lang/String;
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 1

    invoke-static {}, Lcom/prototypejust/weworkshop/steam/WorkshopDownloader;->activeProgressJson()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public itemPause(Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 3

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v1

    invoke-static {v0, v1, v2}, Lcom/prototypejust/weworkshop/steam/WorkshopDownloader;->pause(Landroid/content/Context;J)V

    return-void
.end method

.method public itemCancel(Ljava/lang/String;)V
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    .locals 3

    iget-object v0, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-static {p1}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v1

    invoke-static {v0, v1, v2}, Lcom/prototypejust/weworkshop/steam/WorkshopDownloader;->cancel(Landroid/content/Context;J)V

    return-void
.end method

.method public qwPathSync(Ljava/lang/String;)V
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    if-nez p1, :ret

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :ret

    iget-object v1, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const-string v2, "weworkshop"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "QWSYNC"

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v2, "download_abs"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "download_rel"

    const-string v3, ""

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    :ret
    return-void
.end method

.method public moveDone(Ljava/lang/String;)I
    .locals 10
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    const/4 v9, 0x0

    if-nez p1, :end

    new-instance v0, Ljava/io/File;

    const-string v1, "/storage/emulated/0/QW-Workshop"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const/4 v3, 0x0

    const-string v2, "weworkshop"

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "download_abs"

    const-string v3, "/storage/emulated/0/Download"

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/io/File;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    move-result v4

    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v3

    if-nez v3, :nul

    array-length v4, v3

    move v9, v4

    const/4 v5, 0x0

    :loop
    if-ge v5, v4, :end

    aget-object v6, v3, v5

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v7

    new-instance v8, Ljava/io/File;

    invoke-direct {v8, v2, v7}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v6, v8}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    add-int/lit8 v5, v5, 0x1

    goto :loop

    :end
    return v9

    :nul
    const/4 v9, -0x1

    return v9
.end method

.method private static st(Ljava/lang/StringBuilder;Ljava/io/File;)V
    .locals 3

    invoke-virtual {p1}, Ljava/io/File;->exists()Z

    move-result v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "/"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    if-nez v0, :n

    array-length v1, v0

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void

    :n
    const-string v1, "null"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void
.end method

.method public mvProbe()Ljava/lang/String;
    .locals 8

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "D["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v2, Ljava/io/File;

    const-string v3, "/storage/emulated/0/Download"

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v0, v2}, Lcom/qw/workshop/Bridge;->st(Ljava/lang/StringBuilder;Ljava/io/File;)V

    const-string v1, "] S["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v2, Ljava/io/File;

    const-string v3, "/storage/emulated/0/QW-Workshop"

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v0, v2}, Lcom/qw/workshop/Bridge;->st(Ljava/lang/StringBuilder;Ljava/io/File;)V

    const-string v1, "] mkd="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    move-result v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " dst="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    const/4 v7, 0x0

    const-string v6, "weworkshop"

    invoke-virtual {v5, v6, v7}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v5

    const-string v6, "download_abs"

    const-string v7, "/storage/emulated/0/Download"

    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v0, v2}, Lcom/qw/workshop/Bridge;->st(Ljava/lang/StringBuilder;Ljava/io/File;)V

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    new-instance v3, Ljava/io/File;

    const-string v4, "mv.txt"

    invoke-direct {v3, v2, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    :try_start
    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-virtual {v1}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :done

    :done
    return-object v1
.end method
.method private static copyOne(Landroid/content/ContentResolver;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;)Z
    .locals 6

    const/4 v0, 0x0

    const/4 v1, 0x0

    const/4 v2, 0x0

    :try_start_c1
    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    if-nez v1, :c1_trash

    const-string v3, "application/octet-stream"

    invoke-static {p0, p2, v3, p3}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    if-nez v4, :c1_trash

    invoke-virtual {p0, v4}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;)Ljava/io/OutputStream;

    move-result-object v2

    if-nez v2, :c1_trash

    invoke-static {v1, v2}, Landroid/os/FileUtils;->copy(Ljava/io/InputStream;Ljava/io/OutputStream;)J

    const/4 v0, 0x1

    :c1_trash
    if-eqz v1, :c1_trash2

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    :c1_trash2
    if-eqz v2, :c1_trash3

    invoke-virtual {v2}, Ljava/io/OutputStream;->close()V

    :c1_trash3
    :try_end_c1
    .catch Ljava/lang/Throwable; {:try_start_c1 .. :try_end_c1} :c1_catch

    goto :c1_end

    :c1_catch
    move-exception v5

    const/4 v0, 0x0

    :c1_end
    return v0
.end method

.method public safCopy(Ljava/lang/String;)Ljava/lang/String;
    .locals 13

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    const-string v0, ""

    :try_start_sc
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->prefs()Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "dir_uri"

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :try_start_tp
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v1

    iget-object v2, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const/4 v4, 0x3

    invoke-virtual {v2, v1, v4}, Landroid/content/ContentResolver;->takePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_tp
    .catch Ljava/lang/Throwable; {:try_start_tp .. :try_end_tp} :tp_catch

    goto :tp_done

    :tp_catch
    move-exception v1

    const-string v5, "QWJS"

    invoke-virtual {v1}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :tp_done
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :sc_nouri

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-static {v0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    iget-object v3, p0, Lcom/qw/workshop/Bridge;->act:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    const-string v4, "vnd.android.document/directory"

    const-string v5, "QW-Workshop"

    invoke-static {v3, v2, v4, v5}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "/QW-Workshop"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v0, v6}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    const-string v4, "vnd.android.document/directory"

    invoke-static {v3, v5, v4, p1}, Landroid/provider/DocumentsContract;->createDocument(Landroid/content/ContentResolver;Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "/"

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v6

    sget-object v8, Landroid/provider/MediaStore$Downloads;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    const/4 v9, 0x2

    new-array v9, v9, [Ljava/lang/String;

    const/4 v10, 0x0

    const-string v11, "_id"

    aput-object v11, v9, v10

    const/4 v10, 0x1

    const-string v11, "_display_name"

    aput-object v11, v9, v10

    const-string v10, "relative_path=?"

    const/4 v11, 0x1

    new-array v11, v11, [Ljava/lang/String;

    const/4 v12, 0x0

    const-string v4, "QW-Workshop/"

    aput-object v4, v11, v12

    const/4 v12, 0x0

    move-object v7, v3

    invoke-virtual/range {v7 .. v12}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v9

    if-nez v9, :sc_none

    const/4 v10, 0x0

    :sc_loop
    invoke-virtual {v9}, Landroid/database/Cursor;->moveToNext()Z

    move-result v11

    if-eqz v11, :sc_finish

    const/4 v11, 0x0

    invoke-virtual {v9, v11}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v11

    invoke-static {v8, v11, v12}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object v11

    const/4 v12, 0x1

    invoke-virtual {v9, v12}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v12

    invoke-static {v7, v11, v6, v12}, Lcom/qw/workshop/Bridge;->copyOne(Landroid/content/ContentResolver;Landroid/net/Uri;Landroid/net/Uri;Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :sc_loop

    add-int/lit8 v10, v10, 0x1

    goto :sc_loop

    :sc_finish
    invoke-virtual {v9}, Landroid/database/Cursor;->close()V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ok:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :sc_ret

    :sc_nouri
    const-string v0, "no_uri"

    goto :sc_ret

    :sc_none
    const-string v0, "no_media"
    :try_end_sc
    .catch Ljava/lang/Throwable; {:try_start_sc .. :try_end_sc} :sc_catch

    goto :sc_ret

    :sc_catch
    move-exception v0

    const-string v1, "QWJS"

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "err"

    :sc_ret
    return-object v0
.end method

.method public deletePath(Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_dp
    invoke-direct {p0}, Lcom/qw/workshop/Bridge;->dirBase()Ljava/io/File;
    move-result-object v0
    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v1
    if-nez p1, :dp_chk
    const-string v0, "err:null"
    return-object v0

    :dp_chk
    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-nez v2, :dp_go
    const-string v0, "err:denied"
    return-object v0

    :dp_go
    new-instance v0, Ljava/io/File;
    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/File;->exists()Z
    move-result v2
    if-nez v2, :dp_del
    const-string v0, "noexist"
    return-object v0

    :dp_del
    invoke-direct {p0, v0}, Lcom/qw/workshop/Bridge;->delTree(Ljava/io/File;)I
    move-result v1
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "ok:"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    :try_end_dp
    .catch Ljava/lang/Throwable; {:try_start_dp .. :try_end_dp} :catch_dp
    return-object v0

    :catch_dp
    move-exception v0
    new-instance v1, Ljava/lang/StringBuilder;
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V
    const-string v2, "err:"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/Throwable;->getClass()Ljava/lang/Class;
    move-result-object v2
    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;
    move-result-object v2
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
.end method

.method private delTree(Ljava/io/File;)I
    .locals 5
    const/4 v0, 0x0
    :try_start_t
    invoke-virtual {p1}, Ljava/io/File;->isDirectory()Z
    move-result v4
    if-eqz v4, :t_del
    invoke-virtual {p1}, Ljava/io/File;->listFiles()[Ljava/io/File;
    move-result-object v1
    if-eqz v1, :t_del
    const/4 v2, 0x0
    :t_loop
    array-length v4, v1
    if-ge v2, v4, :t_del
    aget-object v3, v1, v2
    invoke-direct {p0, v3}, Lcom/qw/workshop/Bridge;->delTree(Ljava/io/File;)I
    move-result v4
    add-int/2addr v0, v4
    add-int/lit8 v2, v2, 0x1
    goto :t_loop

    :t_del
    invoke-virtual {p1}, Ljava/io/File;->delete()Z
    move-result v4
    if-eqz v4, :t_ret
    add-int/lit8 v0, v0, 0x1

    :t_ret
    :try_end_t
    .catch Ljava/lang/Throwable; {:try_start_t .. :try_end_t} :catch_t
    return v0

    :catch_t
    return v0
.end method

.method public cvtStart(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    invoke-static {p1, p2, p3}, Lcom/qw/workshop/media/CvtJob;->start(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public wpExtract(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {p1, p1}, Lcom/qw/workshop/media/Wallpaper;->extract(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public wpStart(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {p1}, Lcom/qw/workshop/media/WpJob;->start(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public wpPoll()Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {}, Lcom/qw/workshop/media/WpJob;->poll()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public wpPct()I
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {}, Lcom/qw/workshop/media/WpJob;->pct()I

    move-result v0

    return v0
.end method

.method public wpBusy()Z
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {}, Lcom/qw/workshop/media/WpJob;->busy()Z

    move-result v0

    return v0
.end method

.method public wpHas(Ljava/lang/String;)Z
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {p1}, Lcom/qw/workshop/media/WpJob;->hasImages(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method

.method public cvtPoll()Ljava/lang/String;
    .locals 1

    invoke-static {}, Lcom/qw/workshop/media/CvtJob;->poll()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public cvtBusy()Z
    .locals 1

    invoke-static {}, Lcom/qw/workshop/media/CvtJob;->busy()Z

    move-result v0

    return v0
.end method