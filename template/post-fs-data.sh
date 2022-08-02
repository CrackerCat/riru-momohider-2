#!/system/bin/sh

MODDIR=${0%/*}

DATA_DIR="$MODDIR/config"
mkdir -p "$DATA_DIR"

MAGISK_TMP=$(magisk --path) || MAGISK_TMP="/sbin"
echo -n "$MAGISK_TMP" > "$DATA_DIR/magisk_tmp"

for config in setns isolated app_zygote_magic initrc; do
touch "$DATA_DIR/$config"
done

[ -f $MODDIR/sepolicy.rule ] && exit 0

magiskpolicy --live "allow zygote * filesystem { unmount }" \
"allow zygote zygote capability { sys_ptrace sys_chroot }" \
"allow zygote unlabeled file { open read }"
