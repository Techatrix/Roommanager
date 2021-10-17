class Overlay {
	Widget[] items;				// array of all items in the overlay
	boolean visible = true;		// visibility state of the overlay

	Overlay() {
		if(deb) {
			toovmessages.add("Loading Overlay");
		}
	}
	
	void setItems(Widget[] items) { // sets the items of the overlay
		this.items = items;
		for (Widget item : items) {
			if(item == null) continue;
			item.setXY(0,0);		// position all items at the origin
		}
	}

	void draw() { // draw the overlay
		if(visible) {
			// get hit data for every item
			boolean hit = false;
			boolean[] h = new boolean[items.length];
			for (int i=0;i<items.length;i++) {
				if(items[i] == null) continue;
				boolean newhit = items[i].isHit();
				if(newhit) {
					if(!hit) {
						h[i] = true;
					}
					hit = true;
				} else {
					h[i] = false;
				}
			}

			for (int i=items.length-1;i>=0;i--) {
				if(items[i] == null) continue;
				items[i].draw(h[i]);	// the actual draw call
			}
		}
	}

	boolean isHit() { // return whether or not your mouse is on the overlay
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				if(item.isHit()) {
					return true;
				}
			}
		}
		return false;
	}
	/* --------------- mouse input --------------- */
	boolean mousePressed() {
		boolean hit = false;
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				if(item.mousePressed()) {
					hit = true;
					return true;
				}
			}
		}
		return hit;
	}
	void mouseReleased() {
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				item.mouseReleased();
			}
		}
	}
	boolean mouseDragged() {
		boolean hit = false;
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				if(item.mouseDragged()) {
					hit = true;
					return true;
				}
			}
		}
		return hit;
	}
	void mouseWheel(MouseEvent e) {
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				item.mouseWheel(e);
			}
		}
	}
	/* --------------- keyboard input --------------- */
	void keyPressed(KeyEvent e) {
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				item.keyPressed();
			}
		}
	}
	void keyReleased() {
		if(visible) {
			for (Widget item : items) {
				if(item == null) continue;
				item.keyReleased();
			}
		}
	}
}
