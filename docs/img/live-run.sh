#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# Builds live-run.gif from live-run.session (outputs captured from real runs). Needs ImageMagick and DejaVu fonts.
export LC_ALL=C.UTF-8
set -e
W=1000; H=540; FS=15; CW=9.03; LH=24; X0=22; Y0=66
MONO=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf
MONOB=/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf
SANS=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
BG='#0d1117'; GREEN='#3fb950'; OUT='#7ee787'; AMBER='#e3b341'; TXT='#e6edf3'; DIM='#8b949e'
mapfile -t KIND < <(cut -f1 live-run.session)
mapfile -t TEXT < <(cut -f2- live-run.session)
N=${#KIND[@]}
rm -rf frames; mkdir frames
FRAMES=(); n=0

esc() { local s=$1; s=${s//\\/\\\\}; s=${s//\'/\\\'}; printf '%s' "$s"; }

# text segment at column, splitting out 𝕩 (not in the mono font)
seg() { # col y color text
  local col=$1 y=$2 color=$3 t=$4 part x
  while :; do
    part=${t%%𝕩*}
    x=$(awk "BEGIN{printf \"%.1f\", $X0 + $col*$CW}")
    [ -n "$part" ] && printf "font '%s'\nfill '%s'\ntext %s,%s '%s'\n" "$MONO" "$color" "$x" "$y" "$(esc "$part")"
    col=$((col + ${#part}))
    [ "$part" = "$t" ] && break
    x=$(awk "BEGIN{printf \"%.1f\", $X0 + $col*$CW}")
    printf "font '%s'\nfill '%s'\ntext %s,%s '%s'\n" "$SANS" "$color" "$x" "$y" "𝕩"
    col=$((col+1)); t=${t#*𝕩}
  done
}

line() { # idx shownchars y -> prints mvg, echoes end column in LASTCOL
  local k=${KIND[$1]} t=${TEXT[$1]} c=$2 y=$3
  case $k in
    P) printf "font '%s'\nfill '%s'\ntext %s,%s '\$'\n" "$MONOB" "$GREEN" "$X0" "$y"
       seg 2 "$y" "$TXT" "${t:0:c}"; LASTCOL=$((2+c));;
    R) seg 3 "$y" "$AMBER" "${t:0:c}"; LASTCOL=$((3+c));;
    O) seg 0 "$y" "$OUT" "${t:0:c}"; LASTCOL=$c;;
    A) seg 0 "$y" "$DIM" "${t:0:c}"; LASTCOL=$c;;
  esac
}

frame() { # complete_lines partial_idx partial_chars cursor(0/1) delay
  local full=$1 pi=$2 pc=$3 cur=$4 d=$5 i y f
  f=frames/f$(printf %04d $n).png
  {
    printf "fill '#161b22'\nrectangle 0,0 %s,36\n" "$W"
    printf "fill '#ff5f56'\ncircle 22,18 28,18\nfill '#ffbd2e'\ncircle 44,18 50,18\nfill '#27c93f'\ncircle 66,18 72,18\n"
    printf "font '%s'\nfont-size 13\nfill '%s'\ntext 410,23 'consciousness-omega — bash'\nfont-size %s\n" "$MONO" "$DIM" "$FS"
    for ((i=0;i<full;i++)); do line $i ${#TEXT[$i]} $((Y0+i*LH)); done
    y=$((Y0+full*LH))
    if [ "$pi" -ge 0 ]; then line $pi $pc $y; else
      printf "font '%s'\nfill '%s'\ntext %s,%s '\$'\n" "$MONOB" "$GREEN" "$X0" "$y"; LASTCOL=2; fi
    if [ "$cur" = 1 ]; then
      x=$(awk "BEGIN{printf \"%.1f\", $X0 + $LASTCOL*$CW}")
      x2=$(awk "BEGIN{printf \"%.1f\", $x + $CW}")
      printf "fill '%s'\nrectangle %s,%s %s,%s\n" "$GREEN" "$x" $((y-14)) "$x2" $((y+4))
    fi
  } > frames/cur.mvg
  convert -size ${W}x${H} xc:"$BG" -pointsize $FS -draw "$(cat frames/cur.mvg)" "$f"
  FRAMES+=(-delay "$d" "$f"); n=$((n+1))
}

# intro: blinking prompt
frame 0 -1 0 1 50; frame 0 -1 0 0 50; frame 0 -1 0 1 50
for ((i=0;i<N;i++)); do
  k=${KIND[$i]}; L=${#TEXT[$i]}
  if [ "$k" = P ] || [ "$k" = R ]; then
    for ((c=0;c<L;c+=3)); do frame $i $i $c 1 4; done
    frame $i $i $L 1 45
  else
    # show output line, cursor at next line start
    if [ $((i+1)) -lt $N ] && [ "${KIND[$((i+1))]}" = R ]; then
      frame $((i+1)) $((i+1)) 0 1 70
    elif [ $((i+1)) -lt $N ] && [ "${KIND[$((i+1))]}" = O -o "${KIND[$((i+1))]}" = A ]; then
      frame $((i+1)) $((i+1)) 0 0 30
    else
      frame $((i+1)) -1 0 1 70
    fi
  fi
  # after typed R line, if next is R (no output), next frame naturally starts it
done
# outro: blink
for b in 1 2 3; do frame $N -1 0 0 50; frame $N -1 0 1 50; done
frame $N -1 0 1 200
echo "${#FRAMES[@]} args, $n frames"
convert "${FRAMES[@]}" -loop 0 -layers Optimize live-run.gif
ls -la live-run.gif
rm -rf frames
