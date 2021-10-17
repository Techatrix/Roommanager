class Furniture {
	int xpos = 0;
	int ypos = 0;
	int _width = 0;
	int _height = 0;
	int rot = 0;

	int id;								// id of the furniture
	int price;							// price of the furniture
	color tint = color(255,255,255);	// tint color of the furniture

	Furniture() {}
	Furniture(int id) {
		this(dm.getFurnitureData(id));
	}
	Furniture(int id, int xpos, int ypos) {
		this(id);
		this.xpos = xpos;
		this.ypos = ypos;
	}
	Furniture(int id, int xpos, int ypos, color tint) {
		this(id, xpos, ypos);
		this.tint = tint;
	}
	Furniture(FurnitureData fdata) {
		this.id = fdata.id;
		this._width = fdata._width;
		this._height = fdata._height;
		this.price = fdata.price;
	}
	Furniture(FurnitureData fdata, int xpos, int ypos) {
		this(fdata);
		this.xpos = xpos;
		this.ypos = ypos;
	}
	Furniture(FurnitureData fdata, int xpos, int ypos, color tint) {
		this(fdata, xpos, ypos);
		this.tint = tint;
	}
	Furniture(FurnitureData fdata, int xpos, int ypos, color tint, int rot) {
		this(fdata, xpos, ypos, tint);
		this.rot = rot;
	}
	
	void draw(PGraphics canvas, boolean viewmode, boolean selected) { // draws the furniture
		FurnitureData fdata = dm.getFurnitureData(id);

		if(!viewmode) { // 2D
			push();
			translate(xpos, ypos);
			rotate(HALF_PI*rot);

			int dx = (rot>1) ? -fdata._width : 0;
			int dy = (rot == 1 || rot ==2) ? -fdata._height : 0;
			tint(tint);
			image(fdata.image, dx, dy, fdata._width, fdata._height); // draw furniture
			noTint();

			if (selected == true) { // draw red selection box if selected
				noStroke();
				fill(255,140);
				rect(dx, dy, fdata._width, fdata._height);
			}
			pop();
		} else { // 3D
			if(id != -1) {
				canvas.push();
				canvas.translate(xpos, 0.1, -ypos);
				canvas.rotateY(HALF_PI*rot);
				
				int dx = (rot>1) ? -fdata._width : 0;
				int dy = (rot == 1 || rot ==2) ? fdata._height : 0;
				canvas.translate(dx, 0, dy);
				
				PShape s = fdata.shape;
				s.setFill(tint);
				canvas.shape(s); // draw furniture

				canvas.pop();
			}
		}
	}

	void drawFrame(boolean selected) { // draws boundary frame on the furniture
		noStroke();
		if(selected) {
			fill(c[8], 100);
		} else {
			fill(255, 70);
		}
		Clip c = getBoundary();
		rect(c.x, c.y, c.w, c.h);
	}

	boolean checkover() { // checks if the mouse is on the furniture
		return checkover(floor(rm.getXPos()), floor(rm.getYPos()));
	}

	boolean checkover(int xpos, int ypos) { // checks if the furniture on the position
		Clip c = getBoundary();
		if(c.x <= xpos && xpos < (c.x + c.w) && c.y <= ypos && ypos < (c.y + c.h)) {
			return true;
		}
		return false;
	}

	Clip getBoundary() { // returns the boundary of the furniture
		if(rot % 2 == 0) {
			return new Clip(xpos,ypos, _width,_height);
		} else {
			return new Clip(xpos,ypos,_height, _width);
		}
	}

	boolean setXPos(int value) { // sets the X-Position to the given one
		if(value > -1 && value <= rm.roomgrid.tiles.length-_width) {
			xpos = value;
			return true;
		}
		return false;
	}

	boolean setYPos(int value) { // sets the Y-Position to the given one
		if(value > -1 && value <= rm.roomgrid.tiles[0].length-_height) {
			ypos = value;
			return true;
		}
		return false;
	}

	void move(int dx, int dy) { // moves the furniture in the given direction
		setXPos(xpos+dx);
		setYPos(ypos+dy);
	}
	
}
