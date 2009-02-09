#  534  zip -r kikkanji.zip -x .svn/* contents/ metadata.desktop
#all:
 rm kikkanji.zip
 zip kikkanji.zip \
     contents/code/kikkanji.rb \
     contents/code/kanji.kexi \
     metadata.desktop
 plasmapkg -r kikkanji
 plasmapkg -i kikkanji.zip
 plasmoidviewer -c desktop kikkanji

