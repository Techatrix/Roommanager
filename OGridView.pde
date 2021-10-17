class GridView extends SizedWidget {
	Widget[] children;
	int itemheight;
	int gridlength;
	int off = 0;
	//Enum dir = Dir.DOWN;
	// TODO: include direction

	GridView(Widget[] children, int _width, int _height) {
		this(children, _width, _height, 1);
	}
	GridView(Widget[] children, int _width, int _height, int gridlength) {
		this(children, _width, _height, gridlength, _width/gridlength);
	}
	GridView(Widget[] children, int _width, int _height, int gridlength, int itemheight) {
		this.children = children;
		this._width = _width;
		this._height = _height;
		this.itemheight = itemheight;
		this.gridlength = gridlength;
		setWH(_width, _height);
	}

	boolean mousePressed() {
		if(isHit()) {
			for (Widget child : children) {
				child.mousePressed();
			}
		}
		return isHit();
	}
	boolean mouseDragged() {
		boolean hit = false;
		if(isHit()) {
			for (Widget child : children) {
				if(child.mouseDragged()) {
					hit = true;
				}
			}
		}
		return hit;
	}
	boolean mouseWheel(MouseEvent e) {
		if(isHit()) {
			int length = itemheight * ceil(children.length / (float)gridlength);
			if(length > _height) {
				off -= e.getCount()*15;
				off = constrain(off, _height - length, 0);
			}
			recalculateChildren();
			return true;
		}
		return false;
	}
	void keyPressed() {
		if(isHit()) {
			for (Widget child : children) {
				child.keyPressed();
			}
		}
	}

	int getIndex() {
		for (int i=0;i<children.length;i++) {
			if(children[i].mousePressed()) {
				return i;
			}
		}
		return -1;
	}

	void draw(boolean hit) {
		fill(c[6]);

		boolean c = false;
		if(cl.get() == null) {
			cl.pushClip(xpos, ypos, _width, _height);
			c = true;
		}

		rect(xpos, ypos, _width, _height);
		boolean h = hit && isHit();
		for (Widget child : children) {
			child.draw(h);
		}

		if(c) {
			cl.popClip();
		}
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
		recalculateChildren();
	}

	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateChildren();
	}

	void recalculateChildren() {
		for (int i=0;i<children.length;i++) {
			Widget child = children[i];
			int ih = floor(i / gridlength);
			int iw = i % gridlength;

			child.setXY(xpos+iw*(_width/gridlength), ypos+itemheight*ih+off);
			child.setWH(_width/gridlength, itemheight);
		}
	}
	
}
