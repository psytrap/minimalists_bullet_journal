#!/bin/sh


rm ../pdf/A6/*
rm ../pdf/4x6inch/*

loffice --convert-to pdf --outdir ../pdf/A6/ ./*.odt
loffice --convert-to pdf --outdir ../pdf/A6/ ./*.ods
loffice --convert-to pdf --outdir ../pdf/A6/ ./calendars/*.ods
for pdf in ../pdf/A6/calendar* ; do
  pdf=$(basename $pdf)
  echo "PDF: $pdf"
  mv -v ../pdf/A6/$pdf ../pdf/A6/tmp_$pdf
  gs -o ../pdf/A6/$pdf -sDEVICE=pdfwrite -dFirstPage=1 -dLastPage=2 ../pdf/A6/tmp_$pdf
  rm -v ../pdf/A6/tmp_$pdf
done

rm -v bullet_sheet*svg
for grid in "5" "7.5" ; do
  echo "Grid: $grid"
  for i in 70 80 90 ; do
    echo "Intensity: $i"
    python3 ./generate_bullet_sheet.py --grid $grid --intensity $i --output bullet_sheet_g${grid}mm_i$i.svg
    python3 ./generate_bullet_sheet.py --grid $grid --intensity $i --date --output bullet_sheet_with_date_g${grid}mm_i$i.svg
    inkscape ./bullet_sheet.svg --export-pdf="../pdf/A6/bullet_sheet_g${grid}mm_i$i.pdf"
    inkscape ./bullet_sheet_with_date.svg --export-pdf="../pdf/A6/bullet_sheet_with_date_g${grid}mm_i$i.pdf"
  done
done



for pdf in ../pdf/A6/* ; do
  pdf=$(basename $pdf)
  echo $pdf
  # 4in x 6in ## 101.6x152.4 mm vs 105x148 mm ## 72 points/inch
  gs -o ../pdf/4x6inch/$pdf -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=288 -dDEVICEHEIGHTPOINTS=432 -dPDFFitPage -dFIXEDMEDIA ../pdf/A6/$pdf
done

rm *svg






