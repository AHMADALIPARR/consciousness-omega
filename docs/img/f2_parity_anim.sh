#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# Builds f2_parity_anim.gif from f2_parity.dat (the BQN result ⟨ 1 0 1 0 1 ⟩). Needs gnuplot and ImageMagick.
set -e
mkdir -p frames_f2 && grep -v '^#' f2_parity.dat > frames_f2/d.dat && cd frames_f2
for k in 0 1 2 3 4 5; do v=$( [ $k -gt 0 ] && sed -n ${k}p d.dat | cut -d" " -f2 || true); gnuplot <<GP
set terminal pngcairo size 800,480 font "DejaVu Sans,12" background "#0d1117"
set output "k$k.png"
set border lc rgb "#8b949e"; set tics textcolor rgb "#c9d1d9"
set title "F2 signature after scaling by temperature numerator" tc rgb "#e6edf3"
set xlabel "temperature numerator" tc rgb "#c9d1d9"; set ylabel "signature (sum mod 2)" tc rgb "#c9d1d9"
set xrange [0.4:5.6]; set yrange [0:1.3]; set xtics 1,1,5; set ytics (0,1)
set style fill solid 0.9 border -1; set boxwidth 0.6; set key off
set arrow from 0.4,1 to 5.6,1 nohead dt 2 lc rgb "#e3b341"
set label "initial signature = 1" at 3,1.15 center tc rgb "#e3b341"
$( [ $k -gt 0 ] && echo "set label 'numerator $k  ->  signature $v' at 0.6,1.24 tc rgb '#7ee787'" )
$( if [ $k -gt 0 ]; then echo "plot '< head -n $k d.dat' using 1:(\$2>0?\$2:0.03):(\$2>0?0x3fb950:0xf85149) with boxes lc rgb variable, '< head -n $k d.dat' using 1:(\$2+0.06):(sprintf('%d',\$2)) with labels tc rgb '#e6edf3'"; else echo "plot NaN"; fi )
GP
done
convert -delay 90 k0.png k1.png k2.png k3.png k4.png -delay 300 k5.png -loop 0 -layers Optimize ../f2_parity_anim.gif
cd .. && rm -rf frames_f2
