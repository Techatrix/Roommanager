abstract class CheckBox extends SizedWidget {
	String text;
	boolean value;
	int align;

	CheckBox(String text) {
		this(text, false);
	}
	CheckBox(String text, boolean value) {
		this(text, value, CENTER);
	}
	CheckBox(String text, boolean value, int align) {
		this.text = text;
		this.value = value;
		this.align = align;
	}

	boolean mousePressed() {
		if(isCheckBoxHit()) {
			value = !value;
			onchange();
			return true;
		}
		return false;
	}

	abstract void onchange();

	void draw(boolean hit) {
		push();
		textSize(16);
		noStroke();
		fill(c[0]);
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text, xpos,ypos);
		} else {
			textAlign(align, CENTER);
			text((align == LEFT ? " " : "") + text, xpos, ypos, _width, _height);
		}
		translate(xpos+_width-_height*3/4-16,ypos+_height/8);
		float s = _height*3/4;

		fill(c[6]);
		rect(0,0,s,s);
		stroke(c[0]);
		if(value) {
			line(0,0,s,s);
			line(0,s,s,0);
		}
		noFill();
		strokeWeight(2);
		rect(0,0,s,s);
		pop();
	}

	Box getBoundary() {
		textSize(16);
		return new Box(max(_width, textWidth(text)), max(_height, 16 + textDescent()));
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

	boolean isCheckBoxHit() {
		float x = xpos+_width-_height*3/4-16;
		float y = ypos+_height/8;
		float s = _height*3/4;
	  	return mouseX >= x && mouseX < x+s && mouseY >= y && mouseY < y+s;
	}
	
}
