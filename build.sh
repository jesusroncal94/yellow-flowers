#!/usr/bin/env bash
# Genera las versiones exportables a partir de index.html (la fuente del artifact):
#   docs/index.html                   -> página completa, lista para GitHub Pages / Netlify / cualquier hosting (usa CDN para Three.js y fuentes)
#   docs/flores-amarillas-offline.html -> un solo archivo con Three.js, fuentes y foto embebidos; funciona sin internet
set -euo pipefail
cd "$(dirname "$0")"

SRC=index.html
OUT=docs
TMPD=build
mkdir -p "$OUT" "$TMPD"

# ── 1. Versión online: envolver la fuente en un documento HTML completo ──────
STYLE_END=$(grep -n '^</style>' "$SRC" | head -1 | cut -d: -f1)
{
  cat <<'HEAD'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#0d0b1f">
<meta property="og:title" content="Flores amarillas para Yomara">
<meta property="og:description" content="Un jardín que florece mientras lees.">
HEAD
  sed -n "1,${STYLE_END}p" "$SRC"
  echo '</head>'
  echo '<body>'
  sed -n "$((STYLE_END + 1)),\$p" "$SRC"
  echo '</body>'
  echo '</html>'
} > "$OUT/index.html"
echo "✓ $OUT/index.html"

# ── 2. Versión offline: Three.js y fuentes embebidos ─────────────────────────
THREE_URL=$(grep -o 'https://cdnjs.cloudflare.com[^"]*three.min.js' "$SRC")
FONT_URL=$(grep -o 'https://fonts.googleapis.com/css2[^"]*' "$SRC")
UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'

[ -s "$TMPD/three.min.js" ] || curl -sSL "$THREE_URL" -o "$TMPD/three.min.js"
curl -sSL -A "$UA" "$FONT_URL" -o "$TMPD/fonts.css"

# Solo el subconjunto latin (cubre acentos y ñ)
awk '/\/\* latin \*\//{keep=1} keep{print} /^}/{keep=0}' "$TMPD/fonts.css" > "$TMPD/fonts-inline.css"

i=0
for u in $(grep -o 'https://fonts.gstatic.com[^)]*' "$TMPD/fonts-inline.css" | sort -u); do
  i=$((i + 1))
  curl -sSL "$u" -o "$TMPD/font$i.woff2"
  base64 -w0 "$TMPD/font$i.woff2" > "$TMPD/font$i.b64"
  U="$u" B="$TMPD/font$i.b64" perl -i -pe '
    BEGIN { open(F, "<", $ENV{B}) or die; $b = <F>; close F; }
    s{\Q$ENV{U}\E}{data:font/woff2;base64,$b}g' "$TMPD/fonts-inline.css"
done

awk -v fonts="$TMPD/fonts-inline.css" -v three="$TMPD/three.min.js" '
  /rel="preconnect"/ { next }
  /fonts\.googleapis\.com\/css2/ {
    print "<style>"; while ((getline l < fonts) > 0) print l; close(fonts); print "</style>"; next
  }
  /three\.min\.js"><\/script>/ {
    print "<script>"; while ((getline l < three) > 0) print l; close(three); print "</script>"; next
  }
  { print }
' "$OUT/index.html" > "$OUT/flores-amarillas-offline.html"
echo "✓ $OUT/flores-amarillas-offline.html ($(du -h "$OUT/flores-amarillas-offline.html" | cut -f1))"
