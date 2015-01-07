#/usr/bin/env ruby -w

if RUBY_VERSION.match(/^1.8/)
  $KCODE = 'u'
  require 'jcode'
  require 'rubygems'
end
require 'sqlite3'
require 'activerecord'
require 'plasma_applet'

class Kanji < ActiveRecord::Base
end

def info(anything)
	puts [anything, anything.methods.grep(/imer/).sort].inspect
end

module Kikkanji
class Kikkanji < PlasmaScripting::Applet
	attr_accessor :kanjis, :reordered_ids, :current, :text_codec

	def initialize parent
		super parent
	end

	def init
		ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => package.path + 'contents/code/kanji.kexi')
		self.has_configuration_interface = false
		resize 270, 270
		@kanjis = Kanji.find(:all, :conditions => "grade <= 3")
		array_of_id = (0..(kanjis.size-1))
		@reordered_ids = array_of_id.sort_by { rand }
		@current = 0
		@cur_text = "haha"
		display_new_kanji
		self.startTimer(1000)
	end

	def timerEvent(e)
		t = Time.now
		if (t.sec%60) == 0 and (t.min%5) == 0
			display_new_kanji
		end
	end

	def constraintsEvent(e)
		@font = Qt::Font.new('Helvetica', applet_script.applet.size.width/2.5)
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
	end
	def mouseMoveEvent(e); end
	def mousePressEvent(e); end

	def paintInterface(painter, option, rect)
		painter.save
		painter.font = @font
		painter.pen = Qt::Color.new Qt::white
		painter.draw_text rect, Qt::AlignVCenter | Qt::AlignHCenter, @cur_text
		painter.restore
	end

	def display_new_kanji
		#puts "new kanji please ..."
		@current = 0 if @current.to_i == @kanjis.size
		k = @kanjis[@reordered_ids[@current]]
		ji = k[:kanji]
		@cur_text = ji
		content_attr = k.attributes.collect{|k,v| "<b>#{k}</b>:#{['on', 'kun'].include?(k) ? "<font size=20>#{v}</font>": v}" unless v.to_s.empty? }.join('</li><li>')
		content_attr = "<ul><li>#{content_attr}</li></ul>" unless content_attr.to_s.empty?
		@tooltip_content = "<p><h1>#{ji}</h1>#{content_attr}</p>"

		data = Plasma::ToolTipContent.new
		data.mainText = @cur_text
		data.subText = @tooltip_content
		data.setAutohide(false);
		#Plasma::ToolTipManager::self.set_font(applet_script.applet, @font)
		#data.image = KIcon("some-icon").pixmap(IconSize(KIconLoader::Desktop))
		Plasma::ToolTipManager::self.set_content(applet_script.applet, data)

		@current = @current.nil? ? 1 : @current + 1
		update
	end

end
end
