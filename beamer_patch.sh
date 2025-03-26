# https://tex.stackexchange.com/questions/4192/bad-positioning-of-math-accents-for-the-beamer-standard-font
# Create the patch file:
echo '17a18,61
>    (LABEL C E)
>    (LABEL C H)
>    (LABEL C M)
>    (LABEL C N)
>    (LABEL C Q)
>    (LABEL C i)
>    (LABEL C j)
>    (KRN O 177 R 0.1)
>    (STOP)
>    (LABEL C J)
>    (KRN O 177 R 0.22)
>    (STOP)
>    (LABEL C e)
>    (LABEL C m)
>    (LABEL C n)
>    (LABEL C r)
>    (LABEL C B)
>    (LABEL C R)
>    (LABEL C S)
>    (LABEL C Z)
>    (KRN O 177 R 0.08)
>    (STOP)
>    (LABEL C c)
>    (LABEL C q)
>    (LABEL C s)
>    (LABEL C z)
>    (KRN O 177 R 0.06)
>    (STOP)
>    (LABEL C v)
>    (LABEL C x)
>    (KRN O 177 R 0.04)
>    (STOP)
>    (LABEL C h)
>    (KRN O 177 R 0.02)
>    (STOP)
>    (LABEL C l)
>    (LABEL C U)
>    (KRN O 177 R 0.11)
>    (STOP)
>    (LABEL C d)
>    (LABEL C C)
>    (LABEL C G)
>    (KRN O 177 R 0.12)
>    (STOP)
25a70
>    (KRN O 177 R 0.1)
61a107
>    (KRN O 177 R 0.04)
62a109
>    (KRN O 177 R 0.03)
68a116
>    (KRN O 177 R 0.08)
70a119
>    (KRN O 177 R 0.04)
77a127
>    (KRN O 177 R 0.1)
79a130
>    (KRN O 177 R 0.07)
86a138
>    (KRN O 177 R 0.08)
87a140
>    (KRN O 177 R 0.06)
93a147
>    (KRN O 177 R 0.09)
95a150
>    (KRN O 177 R 0.06)
103a159
>    (KRN O 177 R 0.08)
104a161
>    (KRN O 177 R 0.1)
111a169
>    (KRN O 177 R 0.05)
112a171
>    (KRN O 177 R 0.06)
120a180
>    (KRN O 177 R 0.08)
122a183
>    (KRN O 177 R 0.07)
124a186
>    (KRN O 177 R 0.08)
127a190
>    (KRN O 177 R 0.14)
134a198
>    (KRN O 177 R 0.05)
140a205
>    (KRN O 177 R 0.01)
143a209
>    (KRN O 177 R 0.1)' > cmssi.patch
# Patch the font metrics of cmssi8, 9, 10, 12 and 17:
for i in 8 9 10 12 17; do
tftopl $(kpsewhich cmssi$i.tfm) > cmssmi$i.pl
patch cmssmi$i.pl cmssi.patch
pltotf cmssmi$i.pl
done
# Include the patched font in beamerbasefont.sty and define its \skewchar:
cp $(kpsewhich beamerbasefont.sty) newbeamerbasefont.sty
sed '
/{OT1}{cmss}{m}{it}/,/{}/{
s|cmssi|cmssmi|g
s|{}|{\\skewchar\\font=127}|}
' newbeamerbasefont.sty > beamerbasefont.sty
# Make the font metric available to the system:
echo 'cmssmi8 cmssmi8 <cmssi8.pfb
cmssmi9 cmssmi9 <cmssi9.pfb
cmssmi10 cmssmi10 <cmssi10.pfb
cmssmi12 cmssmi12 <cmssi12.pfb
cmssmi17 cmssmi17 <cmssi17.pfb' > cmssmi.map
updmap-sys --enable Map=cmssmi.map
# clean up:
rm cmssi.patch cmssmi{8,9,10,12,17}.pl newbeamerbasefont.sty cmssmi.map
