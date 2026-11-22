.class public final Lcom/qw/workshop/Bridge$Task;
.super Ljava/lang/Object;
.source "Bridge.java"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field private final b:Lcom/qw/workshop/Bridge;

.field private final s:Ljava/lang/String;

.field private final what:I


# direct methods
.method public constructor <init>(Lcom/qw/workshop/Bridge;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/qw/workshop/Bridge$Task;->b:Lcom/qw/workshop/Bridge;

    iput p2, p0, Lcom/qw/workshop/Bridge$Task;->what:I

    iput-object p3, p0, Lcom/qw/workshop/Bridge$Task;->s:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    iget v0, p0, Lcom/qw/workshop/Bridge$Task;->what:I

    iget-object v1, p0, Lcom/qw/workshop/Bridge$Task;->s:Ljava/lang/String;

    iget-object v2, p0, Lcom/qw/workshop/Bridge$Task;->b:Lcom/qw/workshop/Bridge;

    packed-switch v0, :pswitch_data_0

    return-void

    :pswitch_0
    invoke-virtual {v2}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v3

    const/4 v4, 0x0

    invoke-static {v3, v1, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    return-void

    :pswitch_1
    invoke-virtual {v2}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v3

    invoke-virtual {v3}, Landroid/app/Activity;->finish()V

    return-void

    :pswitch_2
    new-instance v3, Landroid/content/Intent;

    const-string v4, "android.intent.action.VIEW"

    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v5

    invoke-direct {v3, v4, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    const/high16 v4, 0x10000000

    invoke-virtual {v3, v4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {v2}, Lcom/qw/workshop/Bridge;->getAct()Landroid/app/Activity;
    move-result-object v4

    invoke-virtual {v4, v3}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method