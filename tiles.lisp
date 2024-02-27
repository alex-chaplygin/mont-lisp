(defvar *tiles* (make-array (* 120 16) :element-type '(unsigned-byte 8)
				       :initial-contents '(
		   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;0
		  #xAA #xFA #xAA #xFA #xAA #xFA #xFF #xFF #xFA #xAA #xFA #xAA #xFA #xAA #xFF #xFF
		  #xAA #xFA #xAA #xFA #xFF #xFF #xFA #xAA #xFA #xAA #xFF #xFF 0 0 0 0 ;2
		  #x55 #x55 #xFF #xFF #xAA #xAA #x55 #x55 0 0 0 0 0 0 0 0
		  0 0 0 0 0 0 0 0 #x55 #x55 #xAA #xAA #xFF #xFF #x55 #x55
		  #x5A #xF5 #x5A #xF5 #x5A #xF5 #x5A #xF5 #x5A #xF5 #x5A #xF5 #x5A #xF5 #x5A #xF5
		  #xFF #xFF #xFF #xFF #x0F 0 #x0F 0 0 #xF0 0 #xF0 0 #xF0 0 #xF0
		  #xF0 #xFF #x0F #x0F #xF0 #xF0 #x0F 0 #x0F 0 #xF0 0 #xF0 0 #xF0 0
		  #xFF #x0F #xF0 #xF0 #x0F #x0F 0 #xF0 0 #xF0 0 #x0F 0 #x0F 0 #x0F
		  0 0 0 0 0 0 0 0 0 0 0 #xAA 5 #x55 #x0A #xAA
		  0 0 0 0 0 0 0 0 0 0 #xAA 0 #x55 #x50 #xAA #xA0
		  5 #x55 7 #x77 #x0D #xDD 5 #x55 #x0A #xAA 5 #x55 0 #xAA 0 0
		  #x55 #x50 #x77 #x70 #xDD #xD0 #x55 #x50 #xAA #xA0 #x55 #x50 #xAA 0 0 0
		  #x0F 0 #x0F 0 #x0F 0 #x0F 0 0 #xF0 0 #xF0 0 #xF0 0 #xF0
		  #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC
		  #x15 #x54 #x15 #x54 #x15 #x54 #x15 #x54 #x15 #x54 #x15 #x54 #x15 #x54 #x15 #x54
		  0 #x54 5 #x54 #x15 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54
		  #x55 #x55 #x55 #x55 #x41 #x41 #x41 #x41 #x55 #x55 #x55 #x55 #x41 #x41 #x41 #x41
		  #x15 0 #x15 #x50 #x15 #x54 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55
		  #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54 #x55 #x54
		  #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55 #x55
		  #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55 #x15 #x55
		  #x2A #xA8 #x2A #xA8 #x2A #xA8 #x2A #xA8 #x2A #xA8 #x2A #xA8 #x2A #xA8 #x2A #xA8
		  0 #xA8 #x0A #xA8 #x2A #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8
		  #xAA #xAA #xAA #xAA #x82 #x82 #x82 #x82 #xAA #xAA #xAA #xAA #x82 #x82 #x82 #x82
		  #x2A 0 #x2A #xA0 #x2A #xA8 #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA
		  #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8 #xAA #xA8
		  #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA
		  #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA #x2A #xAA
		  #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC #x3F #xFC
		  0 #xFC #x0F #xFC #x3F #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC
		  #xFF #xFF #xFF #xFF #xC3 #xC3 #xC3 #xC3 #xFF #xFF #xFF #xFF #xC3 #xC3 #xC3 #xC3
		  #x3F 0 #x3F #xF0 #x3F #xFC #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF
		  #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC #xFF #xFC
		  #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF
		  #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF #x3F #xFF
		  0 #x0C 0 #x0F 0 #x0F 0 #x0F 0 #x0F 0 #x0F 0 #x0F 0 #x0F
		  0 0 #xC0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0
		  0 #x0F 0 #x0F 0 #x0A #x0A #xAA #x0A #xAA 0 #x0A 0 #x0A 0 #x0A
		  #xF0 0 #xF0 0 #xA0 0 #xAA #xA0 #xAA #xA0 #xA0 0 #xA0 0 #xA0 0
		  #x5A #xFA #x5A #xFA #x5A #xFA #x5F #xFF #x5A #xAA #x55 #x55 #x50 0 #x50 0
		  #xAA #xF5 #xAA #xF5 #xAA #xF5 #xFF #xF5 #xFA #xA5 #x55 #x55 0 5 0 5
		  #x50 0 #x50 0 #x50 0 #x50 0 #x55 #x55 #x50 0 #x50 0 #x50 0
		  0 5 0 5 0 5 0 5 #x55 #x55 0 5 0 5 0 5
		  0 0 0 #x0F 0 #x55 0 #xFF 0 #x55 0 #x0F 0 #x0F 0 #x0F
		  0 0 #xF0 0 #x55 0 #xFF 0 #x55 0 #xF0 0 #xF0 0 #xF0 0
		  0 #x0F 0 #x0F 0 #x0F 0 #x0F 0 5 0 #x0F 0 #x0F 0 0
		  #xF0 0 #xF0 0 #xF0 0 #xF0 0 #x50 0 #xF0 0 #xF0 0 0 0
		  0 0 0 0 3 #xFF #x0C #x3F #x0F #xC0 #x0F #x3F #x0F #x3F #x0F #x3F
		  0 0 0 0 #xFF #xC0 #xFC #x30 3 #xF0 #xFC #xF0 #xFC #xF0 #xFC #xF0
		  #x0F #x3F #x0F #x3F #x0F #x3F #x0F #xC0 #x0C #x3F 3 #xFF 0 0 0 0
		  #xFC #xF0 #xFC #xF0 #xFC #xF0 3 #xF0 #xFC #x30 #xFF #xC0 0 0 0 0 ;52
		  #xAA #xAF #xAA #xAF #xAA #xAA #xAA #xAA #xFF #xAA #xAF #xAA #xAA #xAA #xAA #xAA
		  #xFA #xAA #xFF #xAA #xAA #xAA #xAA #xAA #xAF #xAA #xAA #xAA #xAA #xAF #xAA #xAA
		  #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA
		  #xAA #xAA #xAA #xFA #xAF #xFA #xAA #xAA #xAA #xAA #xAF #xAA #xAA #xAA #xAA #xAA
		  0 0 0 0 0 #x0F 0 #x0F 0 #x0A 0 #xFF #x0F #xAA #x0A 0
		  0 0 0 0 #xFF 0 #xFF 0 #xAA 0 #xFF #xFF #xAA #xAA 0 0
		  0 0 0 #x15 1 #x55 #x15 #x40 #x15 #x40 1 #x55 0 #x15 0 5
		  0 0 #x54 0 #x55 #x40 1 #x54 1 #x54 #x55 #x40 #x54 0 #x50 0
		  0 1 0 1 0 1 0 #x15 0 1 0 #x15 0 1 0 0
		  #x40 0 #x40 0 #x40 0 #x40 0 #x40 0 #x40 0 #x40 0 #x40 0
		  0 0 0 #x2A 2 #xAA #x2A #x80 #x2A #x80 2 #xAA 0 #x2A 0 #x0A
		  0 0 #xA8 0 #xAA #x80 2 #xA8 2 #xA8 #xAA #x80 #xA8 0 #xA0 0
		  0 2 0 2 0 2 0 #x2A 0 2 0 #x2A 0 2 0 0
		  #x80 0 #x80 0 #x80 0 #x80 0 #x80 0 #x80 0 #x80 0 #x80 0
		  0 0 0 #x3F 3 #xFF #x3F #xC0 #x3F #xC0 3 #xFF 0 #x3F 0 #x0F
		  0 0 #xFC 0 #xFF #xC0 3 #xFC 3 #xFC #xFF #xC0 #xFC 0 #xF0 0
		  0 3 0 3 0 3 0 #x3F 0 3 0 #x3F 0 3 0 0
		  #xC0 0 #xC0 0 #xC0 0 #xC0 0 #xC0 0 #xC0 0 #xC0 0 #xC0 0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 #xFF 0 #xFF 0
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 #x0F #xF0 #x0F #xF0
		  #xAA #xA0 #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF 0 #xFF 0 #xFF
		  #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0 #xF0 0
		  0 #xAA 0 #xAA 0 #xAA 0 #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA
		  #xA0 0 #xA0 0 #xA0 0 #xA0 0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 #xFF 0 0 0
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 #x0F #xF0 #xFF #xF0
		  0 #x0A 0 #xAA #x0A #xAA #x0A #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA
		  #xAA #xA0 #xAA 0 #xA0 0 0 0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 0 0 0 #x0F
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 #x0F #xF0 #xFF 0
		  0 #x0A 0 0 #xAA 0 #xAA #xA0 #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA 0 #x0A #xA0 #x0A #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  0 #x0F 0 #xFF 0 #xFF #x0F #xFF #x0F #xFF #xFF #xF0 #xFF #xF0 #xFF 0
		  #xFF 0 #xFF 0 #xFF 0 #xFF 0 #xFF 0 #xFF 0 #xFF 0 #xFF 0
		  #xAA 0 #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA 0 #x0A 0 #x0A
		  #xAA 0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xA0 0 #xA0 0
		  #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF 0 #xFF #xF0 #xFF #xFF 0 #xFF
		  #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 0 0 #xF0 0 #xFF 0
		  0 0 #xAA 0 #xAA 0 #xAA #xA0 #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA 0 #x0A #xA0 #x0A #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 #xFF #xFF #xFF #xFF
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 0 0 #xF0 0 #xFF 0
		  #xAA #xA0 #xAA 0 #xAA #xA0 #xAA #xAA #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA #xA0 #x0A #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF #xFF 0 0 0 0 0 #x0F
		  #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #xFF #xF0
		  0 #x0A 0 #x0A 0 #xAA 0 #xAA #x0A #xAA #x0A #xAA #x0A #xAA #x0A #xAA
		  #xAA #xA0 #xAA 0 #xAA 0 #xA0 0 #xA0 0 #xA0 0 0 0 0 0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 #xFF #xF0 #x0F #xFF
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 #xFF #xF0 #xFF 0
		  #xAA #xA0 #xAA 0 #xAA #xA0 #xAA #xAA #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA #xA0 #x0A #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  0 #xFF #x0F #xFF #xFF #xFF #xFF #xFF #xFF #xF0 #xFF 0 #xFF #xF0 #x0F #xFF
		  #xF0 0 #xFF 0 #xFF #xF0 #xFF #xF0 #xFF #xF0 #x0F #xF0 #xFF #xF0 #xFF #xF0
		  0 #xAA 0 0 #xAA 0 #xAA #xA0 #xAA #xAA #xAA #xAA #x0A #xAA 0 #xAA
		  #xAA #xA0 #x0A #xA0 #x0A #xA0 #xAA #xA0 #xAA #xA0 #xAA #xA0 #xAA 0 #xA0 0
		  5 #x55 1 #x55 0 #x15 0 5 0 5 0 5 0 5 0 0
		  #x55 #x50 #x55 #x40 #x54 0 #x50 0 #x50 0 #x50 0 #x50 0 0 0
		  #x55 #x55 #x15 #x15 #x51 #x51 #x55 #x55 0 0 0 0 0 0 0 0
		  #x3C #x3C #x3C #x3C #x3C #x3C #x3F #xFC 3 #xC0 3 #xC0 3 #xC0 #x3F #xFC ; 114

		  #xF0 0 #xF0 0 #x0A #xAA #xAA #xAA #xAA #xAA #x0A #xAA 0 #x0F 0 #x0F
		  #xF0 0 #xF0 0 #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA 0 #x0F 0 #x0F
		  #xF0 0 #xF0 0 #xAA #xA0 #xAA #xAA #xAA #xAA #xAA #xA0 0 #x0F 0 #x0F
		  #xF0 0 #xF0 0 #x0A #xAA #xAA #xAA #xAA #xAA #x0A #xAA 0 #x0F 0 #x0F
		  #xF0 0 #xF0 0 #xAA #xAA #xAA #xAA #xAA #xAA #xAA #xAA 0 #x0F 0 #x0F
		  #xF0 0 #xF0 0 #xAA #xA0 0 #x80 0 #x28 0 #x2A 0 #x2A 0 #xAA))) ;120
