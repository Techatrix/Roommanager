class Container extends SizedWidget {
	Widget child;
	boolean autocolor = true;
	color _color;
	boolean selectable = true;

	Container(Widget child) {
		this.child = child;
	}
	Container(Widget child, int _width, int _height) {
		this.child = child;
		Box b = child.getBoundary();
		setWH(max(round(b.w), _width), max(round(b.h), _height));
	}
	Container(Widget child, int _width, int _height, color _color) {
		this(child, _width, _height);
		this._color = _color;
		this.autocolor = false;
	}
	Container(Widget child, int _width, int _height, color _color, boolean selectable) {
		this(child, _width, _height, _color);
		this.selectable = selectable;
	}

	@Override boolean mousePressed() {
		child.mousePressed();
		return isHit();
	}
	@Override boolean mouseDragged() {
		return child.mouseDragged();
	}
	@Override boolean mouseWheel(MouseEvent e) {
		return child.mouseWheel(e);
	}
	@Override void keyPressed() {
		child.keyPressed();
	}

	void draw(boolean hit) {
		fill(autocolor ? c[5] : _color);
		noStroke();
		rect(xpos, ypos, _width, _height);
		boolean h = hit && isHit();
		child.draw(h);
		if(h && selectable) {
			fill(c[8], 50);
			noStroke();
			rect(xpos, ypos, _width, _height);
		}
	}

	Box getBoundary() {
		return new Box(_width, _height);
	}

	void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
		recalculateWidgets();
	}

	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateWidgets();
	}

	void recalculateWidgets() {
		child.setXY(xpos, ypos);
		child.setWH(_width, _height);
	}

	boolean isHit() {
		return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
	}
	
}
