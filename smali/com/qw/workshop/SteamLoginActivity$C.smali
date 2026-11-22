.class public Lcom/qw/workshop/SteamLoginActivity$C;
.super Landroid/webkit/WebViewClient;
.source "SteamLoginActivity.java"


# instance fields
.field private final a:Lcom/qw/workshop/SteamLoginActivity;


# direct methods
.method public constructor <init>(Lcom/qw/workshop/SteamLoginActivity;)V
    .locals 0

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    iput-object p1, p0, Lcom/qw/workshop/SteamLoginActivity$C;->a:Lcom/qw/workshop/SteamLoginActivity;

    return-void
.end method


# virtual methods
.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 2

    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/qw/workshop/SteamLoginActivity$C;->a:Lcom/qw/workshop/SteamLoginActivity;

    if-nez v0, :done

    invoke-virtual {v0}, Lcom/qw/workshop/SteamLoginActivity;->checkCookie()V

    :done
    return-void
.end method