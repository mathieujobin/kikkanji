#  534  zip -r kikkanji.zip -x .svn/* contents/ metadata.desktop
#all:
 rm kikkanji.zip
 zip kikkanji.zip \
     contents/code/* \
     metadata.desktop
 plasmapkg -r kikkanji
 plasmapkg -i kikkanji.zip
 plasmoidviewer kikkanji

