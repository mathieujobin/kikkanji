# Mathieu Jobin - 2009-02-04 - GPL 
#/usr/bin/env ruby -w
 
$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'activerecord'
require 'plasma_applet'

DB_FILE = 'contents/code/kanji.kexi'
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => DB_FILE)
class Kanji < ActiveRecord::Base
end

def info(anything)
	puts [anything, anything.methods.sort].inspect
end

module Kikkanji
class Kikkanji < PlasmaScripting::Applet
	attr_accessor :kanjis, :reordered_ids, :current, :text_codec

	def initialize parent
		super parent
	end

	def init
		self.has_configuration_interface = false
		resize 270, 270
	#	self.aspect_ratio_mode = Plasma::Square

		@kanjis = Kanji.find(:all)
		array_of_id = (0..(kanjis.size-1))
		@reordered_ids = array_of_id.sort_by { rand }
		@current = 0
		@cur_text = "haha"
		#info self
		#info applet_script
		#info applet_script.applet
		#info applet_script.applet.window
		@font = Qt::Font.new('Helvetica', applet_script.applet.size.width/2)

		display_new_kanji

		data = Plasma::ToolTipContent.new
		data.mainText = @cur_text
		data.subText = @tooltip_content
		#data.image = KIcon("some-icon").pixmap(IconSize(KIconLoader::Desktop))
		Plasma::ToolTipManager::self.set_content(applet_script.applet, data)

	end

	def resizeEvent(e)
		puts ["resized ", e].inspect
		@font = Qt::Font.new('Helvetica', applet_script.applet.size.width/2)
	end
	def mouseReleaseEvent(e)
		display_new_kanji
	end
	def mouseMoveEvent(e); end
	def mousePressEvent(e); end

	def paintInterface(painter, option, rect)
		painter.save
		painter.font = @font
		painter.pen = Qt::Color.new Qt::white
		painter.draw_text rect, Qt::AlignVCenter | Qt::AlignHCenter, @cur_text
		painter.restore
		#puts "redrawing...."
	end

	def display_new_kanji
		#puts "new kanji please ..."
		@current = 0 if @current.to_i == @kanjis.size
		k = @kanjis[@reordered_ids[@current]]
		ji = k[:kanji]
		@cur_text = ji
		content_attr = k.attributes.collect{|k,v| "<b>#{k}</b>:#{v}" unless v.to_s.empty? }.join('</li><li>')
		content_attr = "<ul><li>#{content_attr}</li></ul>" unless content_attr.to_s.empty?
		@tooltip_content = "<p><h1>#{ji}</h1>#{content_attr}</p>"
		@current = @current.nil? ? 1 : @current + 1
		update
	end

end
end

