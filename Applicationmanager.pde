class ApplicationManager {
	String setfontrawinput = ""; // is being used by Thread in setFontRaw()

	ApplicationManager() {
		toovmessages = new ArrayList<String>();
		if(deb) {
			toovmessages.add("Loading ApplicationManager");
		}
	}

	void initSettings() { // is being executed once before the window is created
		st = new Settings();
		usegl = st.booleans[3].value;
		manageArgs();

		if(st.booleans[2].value) { // full screen
			fullScreen(usegl ? P2D : JAVA2D);  // creates the window and chooses a renderer according to the opengl setting
		} else { // not full screen
			size(max(st.ints[0].value, 600),max(st.ints[1].value,600), usegl ? P2D : JAVA2D); // MIN: 600 x 600
		}
		if(usegl) {
			PJOGL.setIcon("data/assets/icon/0.png"); // sets the window icon on opengl renderer
		}
		smooth(st.ints[2].value);	// anti-aliasing
		recalculateColor();
	}

	void initSetup() { // is being executed once after the window is being created
		if(usegl) { // creates graphics according to the opengl setting
			pg = createGraphics(width,height, P3D);
			pg.smooth(st.ints[2].value);				// anti-aliasing
		}
		cl = new Clipper();								// initialize clipper
		lg = new LanguageManager(st.strings[1].value);	// initialize languagemanager
		dm = new DataManager();							// initialize datamanager
		rm = new RoomManager();							// initialize roommanager
		ov = new OverlayManager();						// initialize overlaymanager
		
		if(toovmessages.size() == 1) {
			ov.checkMessages();
			ov.drawconsole = false;
		}
		ov.checkMessages();

		int[] invalidids = dm.validate();
		for (int id : invalidids) {
			toovmessages.add(dm.prefabs[id].name + " is invalid!");
		}

		if(!usegl) {
			surface.setIcon(dm.icons[0]); // sets the window icon on not opengl renderer
		}
		setFont(st.strings[2].value);
		if(usegl && useshadowmap) {
			pg.beginDraw();
			initShadowPass();
			initDefaultPass();
			pg.endDraw();
		}
	}

	void setTitle(String name) { // sets the window title
	  	surface.setTitle(appname + " - "+ appversion + ": " + name);
	}

	void setFont(String newfontname) { // sets the current font
		newfontname = newfontname.toLowerCase();
		
		setfontrawinput = newfontname;
		thread("setFontRawThread");
	}

	void setFontRaw() { // uses the chosen font if available or fall back to the default font
		boolean hit = false;
		String[] fontnames = PFont.list();
		for (String fontname : fontnames) {
			if(fontname.toLowerCase().equals(setfontrawinput)) {
				hit = true;
				break;
			}
		}
		if(hit) {
			font = createFont(setfontrawinput, 32);
		} else {
			font = createFont("Arial", 32);
		}
		textFont(font);
		if(usegl) {
			pg.textFont(font);
		}
	}

	void recalculateColor() { // recalculates the easily accessible color values according to the dark mode setting
		boolean isdm = st.booleans[0].value;

		for (int i=0;i<c.length;i++) {
			c[i] = isdm ? 255-32*i : 32*i;
			c[i] = constrain(c[i], 0, 255);
		}
	}

	void manageArgs() {	// handles all arguments which have been handed over to the program
		if(args != null) {
			for (String arg : args) {
				if(arg.equals("-debug")) {
					deb = true;
					toovmessages.add("Debugmode activated");
				} else if(arg.equals("-nofilter")) {
					usefilters = false;
					toovmessages.add("Filter disabled");
				} else if(arg.equals("-noshadowmap")) {
					useshadowmap = false;
					toovmessages.add("Shadow mapping disabled");
				} else if(arg.equals("-noopengl")) {
					usegl = false;
					toovmessages.add("OpenGL mode disabled");
				} else if(arg.equals("-cgol")) {
					allowcgol = true;
					toovmessages.add("CGOL activated");
				}
			}
		}
	}

	void loop() { // set window size according to the width & height setting
		int sw = st.ints[0].value;
		int sh = st.ints[1].value;
		if(width != sw || height != sh) {
			st.ints[0].setValue(width);	
			st.ints[1].setValue(height);
			if(usegl) {
				pg.setSize(width,height);
				if(usefilters) {
					try {
		  				dm.filters[1].set("resolution", float(width), float(height));
					} catch(RuntimeException e) {
						usefilters = false;
						toovmessages.add("Shader RuntimeException: " + e);
						toovmessages.add("Disabled filters");
					}
				}
			}
			ov.build();
		}
	}

}

// this is the only way (i know) how to execute a function in a class in thread()
void setFontRawThread() { // used for in "void setfont(String newfontname)"
	am.setFontRaw();
}
