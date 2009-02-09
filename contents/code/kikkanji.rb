# Mathieu Jobin - 2009-02-04 - GPL
# 2006.05.16 : First version QtRuby 3
#              goal was to be a kicker applet but QtRuby was not ready at the time so I made a main window.
# 2008-12-28 : imported code into svn
# 2009-02-04 : Debut port to plasma
# 2009-02-06 : First working stable version (missing is the resize event, a timer, a config dialog and a plasma app icon)
#/usr/bin/env ruby -w

$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'activerecord'
require 'plasma_applet'

DB_FILE = '/home/mjobin/.kde/share/apps/plasma/plasmoids/kikkanji/contents/code/kanji.kexi'
#DB_FILE = package.path + 'contents/code/kanji.kexi'
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
		#Qt.debug_level = 2
		#GC.disable
	end

	def init
		self.has_configuration_interface = false
		resize 270, 270
		#self.aspect_ratio_mode = Plasma::Square

		@kanjis = Kanji.find(:all)
		array_of_id = (0..(kanjis.size-1))
		@reordered_ids = array_of_id.sort_by { rand }
		@current = 0
		@cur_text = "haha"
 		#info self
 		#info applet_script
 		#info applet_script.applet
 		#info applet_script.applet.window

		display_new_kanji

		##applet_script.startTimer
	end

	def constraintsEvent(e)
		#puts ["y resized ", e].inspect
		@font = Qt::Font.new('Helvetica', applet_script.applet.size.width/2.2)
		update
	end

	def mouseReleaseEvent(e)
		if Qt::ShiftModifier.to_i == (e.modifiers & Qt::ShiftModifier.to_i)
			if @current == 0
				@current = @kanjis.size 
			elsif @current == 1
				@current = @kanjis.size - 1 
			else
				@current = @current - 2
			end
			
		end
		display_new_kanji
		#puts [e.button, e.buttons, e.modifiers].inspect
		#info e
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

		data = Plasma::ToolTipContent.new
		data.mainText = @cur_text
		data.subText = @tooltip_content
		#Plasma::ToolTipManager::self.set_font(applet_script.applet, @font)
		#data.image = KIcon("some-icon").pixmap(IconSize(KIconLoader::Desktop))
		Plasma::ToolTipManager::self.set_content(applet_script.applet, data)

		@current = @current.nil? ? 1 : @current + 1
		update
	end

end
end

