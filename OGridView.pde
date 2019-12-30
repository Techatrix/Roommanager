class GridView extends PWH implements IOverlay {
	Object[] items;
	int itemheight;
	int gridlength;
	//Enum dir = Dir.DOWN;
	// TODO: include direction

	GridView(Object[] items, int _width, int _height) {
		this(items, _width, _height, 1);
	}
	GridView(Object[] items, int _width, int _height, int gridlength) {
		this(items, _width, _height, gridlength, _width/gridlength);
	}
	GridView(Object[] items, int _width, int _height, int gridlength, int itemheight) {
		this.items = items;
		this._width = _width;
		this._height = _height;
		this.itemheight = itemheight;
		this.gridlength = gridlength;
		setWH(_width, _height);
	}

	void mouseWheel(MouseEvent e) {
	}
	boolean mousePressed() {
		if(isHit()) {
			for (Object item : items) {
				mousePresseditem(item);
			}
		}
		return isHit();
	}
	boolean mouseDragged() {
		return false;
	}
	void keyPressed() {
		if(isHit()) {
			for (Object item : items) {
				keyPresseditem(item);
			}
		}
	}

	int getindex() {
		for (int i=0;i<items.length;i++) {
			Object item = items[i];
			if(mousePresseditem(item)) {
				return i;
			}
		}
		return -1;
	}

	void draw(boolean hit) {
		fill(c[6]);
		clip(xpos, ypos, _width, _height);
		rect(xpos, ypos, _width, _height);

		for (Object item : items) {
			drawitem(item, isHit());
		}
    	noClip();
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
		recalculateitems();
	}
	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateitems();
	}
	void recalculateitems() {
		for (int i=0;i<items.length;i++) {
			Object item = items[i];
			int ih = floor(i / gridlength);
			int iw = i % gridlength;


			setitemxy(item, xpos+iw*(_width/gridlength), ypos+itemheight*ih);
			setitemwh(item, _width/gridlength, itemheight);
		}
	}
}
