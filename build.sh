reveal-md --static _static slides.md
cp *.jpg *.png *.svg _static
cp style.css _static
chmod -R a+r _static

# fix paths
sed -i '' -e 's/\.\///g' _static/index.html
sed -i '' -e 's/_assets\/style.css/style.css/g' _static/index.html
