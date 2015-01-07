# Kikkanji

This is a plasma applet which displays kanji. it has a timer that make the kanji change every two minute, you can also forward to the next one with a simple click or go backward with a shift-click.

config dialog is still missing. it displays kanji up to grade 3 by default. that can be change in the code. until I add a config dialog.

it requires KDE 4.2 and Plasma. it is written in Ruby, so it requries QtRuby/Korundum.

Package is not distribution specific.

# Dependencies Ubuntu 12.04
```bash
sudo apt-get install rubygems korundum4 plasma-scriptengine-ruby sqlite3 libsqlite3-ruby1.8 libsqlite3-ruby libsqlite3-dev
sudo gem install activerecord sqlite3
```
(note that korundum4 was called libkorundum4-ruby1.8 before 4.5)

# Manual Install
```bash
$ plasmapkg -i 99711-kikkanji.zip
```

# Screenshots

![Kikkanji under KDE 4.2](http://kde-apps.org/CONTENT/content-pre1/99711-1.png "Kikkanji under KDE 4.2")
![Kikkanji under KDE 4.5](http://kde-apps.org/CONTENT/content-pre1/99711-2.png "Kikkanji under KDE 4.5")

# Troubleshooting
if the plasmoid does not load, you might need to add an underscore on the
require 'activerecord'
it depends on your rubygems version.

vim $HOME/.kde/share/apps/plasma/plasmoids/kikkanji/contents/code/kikkanji.rb
change line 12 to... (simply adding the underscore)
require 'active_record'
