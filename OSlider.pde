abstract class Slider extends SizedWidget {
	String text;
	boolean selected = false;
	float value;
	int align;

	Slider(String text) {
		this(text, 0.0);
	}
	Slider(String text, float value) {
		this(text, value, CENTER);
	}
	Slider(String text, float value, int align) {
		this.text = text;
		this.value = value;
		this.align = align;
	}

	boolean mousePressed() {
		if(isHit()) {
			selected = true;
			onchange(constrain(map(mouseX, xpos, xpos+_width,0,1), 0,1));
			return true;
		}
		selected = false;
		return false;
	}
	boolean mouseDragged() {
		if(selected) {
			onchange(constrain(map(mouseX, xpos, xpos+_width,0,1), 0,1));
			return true;
		}
		return false;
	}

	abstract void onchange(float newvalue);
	abstract String gettext();

	void draw(boolean hit) {
		noStroke();
		fill(128,128,128);
		rect(xpos,ypos,_width*value,_height);
		fill(c[0]);

		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + gettext(), xpos,ypos);
		} else {
			textAlign(align, CENTER);
			text((align == LEFT ? " " : "") + text + ": " + gettext(), xpos,ypos, _width, _height);
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
	}

	void setWH(int _width, int _height) {
		this._width = _width;
		this._height = _height;
	}
	
}
