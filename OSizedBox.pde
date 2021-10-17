class SizedBox extends SizedWidget {
	boolean expand;
	//TODO flex parameter

	SizedBox() {
		this(false, -1, -1);
	}
	SizedBox(boolean expand) {
		this(expand, -1, -1);
	}
	// size/length will at least be itemheight(30) in listview
	SizedBox(int _width, int _height) {
		this(false, _width, _height);
	}
	SizedBox(boolean expand, int _width, int _height) {
		setWH(_width, _height);
		this.expand = expand;
	}

	void draw(boolean hit) {
	}

	Box getBoundary() {
		return new Box(_width, _height);
	}
	
	boolean isHit() {
	  	return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
	}

	void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
	}
	
	void setWH(int _width, int _height) {
		this._width = _width;
		this._height = _height;
	}
}
