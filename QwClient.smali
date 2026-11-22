.class public Lcom/qw/workshop/QwClient;
.super Landroid/webkit/WebViewClient;
.source "QwClient.java"


# instance fields
.field private final act:Landroid/app/Activity;


# direct methods
.method public constructor <init>(Landroid/app/Activity;)V
    .locals 0

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    iput-object p1, p0, Lcom/qw/workshop/QwClient;->act:Landroid/app/Activity;

    return-void
.end method

.method private handle(Landroid/net/Uri;)Z
    .locals 4

    if-nez p1, :cond_scheme

    const/4 v0, 0x0

    return v0

    :cond_scheme
    invoke-virtual {p1}, Landroid/net/Uri;->getScheme()Ljava/lang/String;
    move-result-object v0

    if-nez v0, :cond_has

    const/4 v0, 0x0

    return v0

    :cond_has
    const-string v1, "file"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1

    if-eqz v1, :cond_httpchk

    const/4 v0, 0x0

    return v0

    :cond_httpchk
    const-string v1, "http"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1

    if-eqz v1, :cond_outer

    const/4 v0, 0x0

    return v0

    :cond_outer
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v1, v2, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const/high16 v2, 0x10000000

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    :try_start_0
    iget-object v2, p0, Lcom/qw/workshop/QwClient;->act:Landroid/app/Activity;

    invoke-virtual {v2, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Landroid/content/ActivityNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 v0, 0x1

    return v0

    :catch_0
    move-exception v1

    const/4 v0, 0x1

    return v0
.end method


# virtual methods
.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 2

    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;
    move-result-object v0

    invoke-direct {p0, v0}, Lcom/qw/workshop/QwClient;->handle(Landroid/net/Uri;)Z
    move-result v1

    return v1
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 2

    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v0

    invoke-direct {p0, v0}, Lcom/qw/workshop/QwClient;->handle(Landroid/net/Uri;)Z
    move-result v1

    return v1
.end method