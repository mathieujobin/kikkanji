#!/usr/bin/env ruby -w

$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'activerecord'
#require 'Qt'
#require 'KDE/korundum4'
#require 'KDE/plasma'
require 'main_dlg'

# create main application object
app = Qt::Application.new(ARGV)

DB_FILE = 'kanji.kexi'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database  => DB_FILE)
class Kanji < ActiveRecord::Base
end

class KikkanjiDlg
	attr_accessor :bottom_is_shown
	def toggle_bottom(*k)
		if @bottom_is_shown
			@toggle_button.setText('Show details')
			@bottom_frame.hide
			@bottom_is_shown=false
			self.setMinimumHeight(300)
			self.setMaximumHeight(300)
		else
			@toggle_button.setText('Hide details')
			@bottom_frame.show
			self.setMinimumHeight(500)
			self.setMaximumHeight(500)
			@bottom_is_shown=true
		end
	end
end

class Kikkanji < KikkanjiDlg # Qt::Label
	attr_accessor :kanjis, :reordered_ids, :current, :text_codec

	def initialize
		super(nil)

		#@kanjis = Kikkanji.kanjis_from_db
		#@kanjis = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
		@kanjis = Kanji.find_all
		array_of_id = (0..(kanjis.size-1))
		@reordered_ids = array_of_id.sort_by { rand }
		@current = 0


		@kanji_label.setText('')
		display_new_kanji
		@kanji_label.setFont(Qt::Font.new('Helvetica', 128))
		@kanji_label.setAlignment(Qt::AlignHCenter + Qt::AlignVCenter)
		@kanji_label.setMinimumSize(200, 200)
		@bottom_is_shown = true
		toggle_bottom(nil)
		#t = Qt::Timer.new
		#connect(t, SIGNAL('timeout()'), SLOT('display_new_kanji()'))
		#t.start(1000, false)

		#connect(self, SIGNAL('clicked()'), SLOT('display_new_kanji()'))
	end

	def mouseReleaseEvent(e)
		display_new_kanji
	end

	# get list of kanjis from Database
	def self.kanjis_from_db
		ret = []
		@text_codec = Qt::TextCodec.codecForName('eucJP')
		db = Qt::SqlDatabase.addDatabase('QSQLITE3')
		db.setDatabaseName(DB_FILE)
		db.open
		query = Qt::SqlQuery.new('select kanji from kanjis')
		if query.isActive
			while query.next
				#ret << @text_codec.toUnicode(query.value(0).toCString)
				ret << query.value(0).toString
			end
		end
		ret
	end

	def display_new_kanji
		@current = 0 if @current == @kanjis.size
		k = @kanjis[@reordered_ids[@current]]
		ji = k[:kanji]
		@kanji_label.setText(ji)
		Qt::ToolTip::remove(self)
		content_attr = k.attributes.collect{|k,v| "<b>#{k}</b>:#{v}" unless v.to_s.empty? }.join('</li><li>')
		content_attr = "<ul><li>#{content_attr}</li></ul>" unless content_attr.to_s.empty?
		content = "<p><h1>#{ji}</h1>#{content_attr}</p>"
		# content = k.to_yaml
		Qt::ToolTip::add(@kanji_label, content)
		@notes_label.setText(content)
		@current += 1
	end
	slots 'display_new_kanji()'
end

# run the program
mw = Kikkanji.new
app.mainWidget = mw
mw.show
app.exec


#class Kikkanji < KDE::PanelApplet;end
