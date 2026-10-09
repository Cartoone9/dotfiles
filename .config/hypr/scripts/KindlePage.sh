#!/usr/bin/env bash
# Turn a page on the Kindle (PW12) through KOReader's HTTP inspector plugin.
# Usage: KindlePage.sh next|prev      (override the address with KINDLE_HOST=...)
KINDLE="${KINDLE_HOST:-192.168.1.149}"
case "$1" in
  next) n=1 ;;
  prev) n=-1 ;;
  *) echo "usage: $0 next|prev" >&2; exit 2 ;;
esac
# GotoViewRel/<n> is the dispatcher event behind "next/previous page".
if ! curl -s -m 2 -o /dev/null --fail "http://$KINDLE:8080/koreader/event/GotoViewRel/$n"; then
  notify-send -t 2000 "Kindle" "unreachable on $KINDLE:8080 (asleep, or HTTP inspector off?)"
fi
