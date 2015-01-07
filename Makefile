all: build install run

build:
	[ -f kikkanji.zip ] && rm kikkanji.zip || echo 'start'
	zip kikkanji.zip \
	contents/code/kikkanji.rb \
	contents/code/kanji.kexi \
	kanji.svg metadata.desktop

install:
	plasmapkg -r kikkanji
	plasmapkg -i kikkanji.zip

run:
	plasma-windowed kikkanji

overwrite:
	mkdir -p ~/.kde/share/apps/plasma/plasmoids/kikkanji/contents/code
	cp contents/code/kikkanji.rb contents/code/kanji.kexi ~/.kde/share/apps/plasma/plasmoids/kikkanji/contents/code/
	cp metadata.desktop ~/.kde/share/apps/plasma/plasmoids/kikkanji/
