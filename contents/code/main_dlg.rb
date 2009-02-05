# Form implementation generated from reading ui file 'main_dlg.ui'
#
# Created: Wed May 17 11:06:28 2006
#      by: The QtRuby User Interface Compiler (rbuic)
#
# WARNING! All changes made in this file will be lost!


require 'Qt'

class KikkanjiDlg < Qt::Dialog

    slots 'languageChange()',
    'toggle_bottom()'

    attr_reader :main_frame
    attr_reader :top_frame
    attr_reader :kanji_label
    attr_reader :toggle_button
    attr_reader :bottom_frame
    attr_reader :notes_label


    def initialize(parent = nil, name = nil, modal = false, fl = 0)
        super

        if name.nil?
        	setName("main_dlg")
        end

        @main_dlgLayout = Qt::GridLayout.new(self, 1, 1, 11, 6, 'main_dlgLayout')
        @main_dlgLayout.setResizeMode( Qt::Layout::Minimum )

        @main_frame = Qt::Frame.new(self, "main_frame")
        @main_frame.setSizePolicy( Qt::SizePolicy.new(5, 3, 0, 0, @main_frame.sizePolicy().hasHeightForWidth()) )
        @main_frame.setFrameShape( Qt::Frame::StyledPanel )
        @main_frame.setFrameShadow( Qt::Frame::Raised )
        @main_frameLayout = Qt::VBoxLayout.new(@main_frame, 11, 6, 'main_frameLayout')

        @top_frame = Qt::Frame.new(@main_frame, "top_frame")
        @top_frame.setFrameShape( Qt::Frame::StyledPanel )
        @top_frame.setFrameShadow( Qt::Frame::Raised )
        @top_frameLayout = Qt::GridLayout.new(@top_frame, 1, 1, 11, 6, 'top_frameLayout')

        @kanji_label = Qt::Label.new(@top_frame, "kanji_label")

        @top_frameLayout.addWidget(@kanji_label, 0, 0)
        @main_frameLayout.addWidget(@top_frame)

        @toggle_button = Qt::PushButton.new(@main_frame, "toggle_button")
        @main_frameLayout.addWidget(@toggle_button)

        @bottom_frame = Qt::Frame.new(@main_frame, "bottom_frame")
        @bottom_frame.setFrameShape( Qt::Frame::StyledPanel )
        @bottom_frame.setFrameShadow( Qt::Frame::Raised )
        @bottom_frameLayout = Qt::GridLayout.new(@bottom_frame, 1, 1, 11, 6, 'bottom_frameLayout')

        @notes_label = Qt::Label.new(@bottom_frame, "notes_label")

        @bottom_frameLayout.addWidget(@notes_label, 0, 0)
        @main_frameLayout.addWidget(@bottom_frame)

        @main_dlgLayout.addWidget(@main_frame, 0, 0)
        languageChange()
        resize( Qt::Size.new(221, 364).expandedTo(minimumSizeHint()) )
        clearWState( WState_Polished )

        Qt::Object.connect(@toggle_button, SIGNAL("released()"), self, SLOT("toggle_bottom()") )
    end

    #
    #  Sets the strings of the subwidgets using the current
    #  language.
    #
    def languageChange()
        setCaption(trUtf8("きっかんじ"))
        @kanji_label.setText( trUtf8("textLabel1") )
        @toggle_button.setText( trUtf8("pushButton1") )
        @notes_label.setText( trUtf8("textLabel2") )
    end
    protected :languageChange


    def toggle_bottom(*k)
        print("KikkanjiDlg.toggle_bottom(): Not implemented yet.\n")
    end

end
