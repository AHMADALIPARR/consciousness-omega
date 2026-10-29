set terminal pngcairo size 800,480 font "Helvetica,12"
set output "f2_parity.png"
set title "F2 signature of the test tensor after scaling by the temperature numerator"
set xlabel "temperature numerator"
set ylabel "signature (sum mod 2)"
set xrange [0.4:5.6]
set yrange [0:1.25]
set xtics 1,1,5
set ytics (0,1)
set style fill solid 0.8 border -1
set boxwidth 0.6
set key off
set arrow from 0.4,1 to 5.6,1 nohead dt 2 lc rgb "#7a3535"
set label "initial signature = 1" at 3.5,1.1 center tc rgb "#7a3535"
plot "f2_parity.dat" using 1:2 with boxes lc rgb "#35507a"
