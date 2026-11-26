.class public Lcom/qw/workshop/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# instance fields
.field private root:Landroid/widget/FrameLayout;

.field private web:Landroid/webkit/WebView;

.field private web2:Landroid/webkit/WebView;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method private makeWeb()Landroid/webkit/WebView;
    .locals 7

    new-instance v0, Landroid/webkit/WebView;
    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;
    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setAllowUniversalAccessFromFileURLs(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setLoadWithOverviewMode(Z)V

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    new-instance v4, Lcom/qw/workshop/QwClient;
    invoke-direct {v4, p0}, Lcom/qw/workshop/QwClient;-><init>(Landroid/app/Activity;)V
    invoke-virtual {v0, v4}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    new-instance v5, Lcom/qw/workshop/QwChrome;
    invoke-direct {v5}, Lcom/qw/workshop/QwChrome;-><init>()V
    invoke-virtual {v0, v5}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

    new-instance v6, Lcom/qw/workshop/Bridge;
    invoke-direct {v6, p0}, Lcom/qw/workshop/Bridge;-><init>(Landroid/app/Activity;)V
    const-string v3, "QW"
    invoke-virtual {v0, v6, v3}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    return-object v0
.end method


# virtual methods


.method public hideLogin()V
    .locals 3

    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web2:Landroid/webkit/WebView;

    if-eqz v0, :hl_no2

    iget-object v1, p0, Lcom/qw/workshop/MainActivity;->root:Landroid/widget/FrameLayout;

    if-eqz v1, :hl_skip

    invoke-virtual {v1, v0}, Landroid/widget/FrameLayout;->removeView(Landroid/view/View;)V

    :hl_skip
    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/qw/workshop/MainActivity;->web2:Landroid/webkit/WebView;

    :hl_no2
    iget-object v1, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v1, :hl_ret

    const-string v2, "window.qwOnLogin&&window.qwOnLogin()"

    const/4 v0, 0x0

    invoke-virtual {v1, v2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :hl_ret
    return-void
.end method

.method public showLogin(Ljava/lang/String;)V
    .locals 6

    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web2:Landroid/webkit/WebView;

    if-nez v0, :sl_create

    const-string v1, "https://steamcommunity.com/login/home/?goto="

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void

    :sl_create
    new-instance v0, Landroid/webkit/WebView;

    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V

    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setLoadWithOverviewMode(Z)V

    new-instance v1, Lcom/qw/workshop/LoginClient;

    invoke-direct {v1, p1}, Lcom/qw/workshop/LoginClient;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    new-instance v1, Lcom/qw/workshop/Bridge;

    invoke-direct {v1, p0}, Lcom/qw/workshop/Bridge;-><init>(Landroid/app/Activity;)V

    const-string v2, "QW"

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    iput-object v0, p0, Lcom/qw/workshop/MainActivity;->web2:Landroid/webkit/WebView;

    iget-object v1, p0, Lcom/qw/workshop/MainActivity;->root:Landroid/widget/FrameLayout;

    if-eqz v1, :sl_load

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :sl_load
    const-string v1, "https://steamcommunity.com/login/home/?goto="

    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method

.method public getWeb()Landroid/webkit/WebView;
    .locals 1

    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    return-object v0
.end method

.method public onBackPressed()V
    .locals 2
    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web2:Landroid/webkit/WebView;
    if-eqz v0, :bp_js
    invoke-virtual {p0}, Lcom/qw/workshop/MainActivity;->hideLogin()V
    return-void
    :bp_js
    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;
    if-eqz v0, :bp_finish
    const-string v1, "try{if(window.qwBack){qwBack();}}catch(e){}"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    return-void
    :bp_finish
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4

    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    invoke-direct {p0}, Lcom/qw/workshop/MainActivity;->makeWeb()Landroid/webkit/WebView;

    move-result-object v0

    iput-object v0, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    new-instance v1, Landroid/widget/FrameLayout;

    invoke-direct {v1, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/qw/workshop/MainActivity;->root:Landroid/widget/FrameLayout;

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    invoke-direct {v2, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {p0, v1}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V

    invoke-static {p0}, Lcom/qw/workshop/LogUtils;->install(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->setOverScrollMode(I)V

    const-string v2, "file:///android_asset/index.html"

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    return-void
.end method

.method protected onResume()V
    .locals 3

    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    if-nez v0, :rs_ret

    :try_start_rs
    const-string v1, "window.qwOnResume&&window.qwOnResume()"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_rs
    .catch Ljava/lang/Throwable; {:try_start_rs .. :try_end_rs} :rs_ret

    :rs_ret
    return-void
.end method

.method protected onDestroy()V
    .locals 1

    invoke-virtual {p0}, Lcom/qw/workshop/MainActivity;->hideLogin()V

    iget-object v0, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :od_0

    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V

    :od_0
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 6

    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    const/16 v0, 0x52

    if-ne p1, v0, :oar_51

    invoke-static {p0}, Lcom/qw/workshop/Bridge;->openTreeFor(Landroid/app/Activity;)V

    goto :oar_done

    :oar_51
    const/16 v0, 0x51

    if-ne p1, v0, :oar_done

    if-eqz p3, :oar_done

    const/4 v0, -0x1

    if-ne p2, v0, :oar_done

    :try_start_ck
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v1

    if-eqz v1, :oar_done

    invoke-virtual {v1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "qw_prefs"

    const/4 v4, 0x0

    invoke-virtual {p0, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "dir_uri"

    invoke-interface {v3, v4, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->commit()Z

    const-string v3, "QWJS"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "OAR uri="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v3, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v3, :oar_done

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "window.qwDirPicked&&window.qwDirPicked('"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "')"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x0

    invoke-virtual {v3, v4, v5}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_ck
    .catch Ljava/lang/Throwable; {:try_start_ck .. :try_end_ck} :ck_catch

    goto :oar_done

    :ck_catch
    move-exception v0

    :oar_done
    return-void
.end method



.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 3

    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    const/16 v0, 0x53

    if-ne p1, v0, :pr_ret

    if-eqz p3, :pr_ret

    array-length v0, p3

    if-lez v0, :pr_ret

    const/4 v1, 0x0

    aget v0, p3, v1

    if-eqz v0, :pr_deny

    invoke-static {p0}, Lcom/qw/workshop/Bridge;->openTreeFor(Landroid/app/Activity;)V

    goto :pr_ret

    :pr_deny
    const-string v0, "window.qwPermDenied&&window.qwPermDenied()"

    iget-object v1, p0, Lcom/qw/workshop/MainActivity;->web:Landroid/webkit/WebView;

    if-eqz v1, :pr_ret

    const/4 v2, 0x0

    invoke-virtual {v1, v0, v2}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :pr_ret
    return-void
.end method