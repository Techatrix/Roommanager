abstract class Visible extends SizedWidget {
	Widget child;
	
	Visible(Widget child) {
		this.child = child;
	}

	boolean mousePressed() {
		if(isVisible()) {
			return child.mousePressed();
		}
		return false;
	}
	boolean mouseDragged() {
		if(isVisible()) {
			return child.mouseDragged();
		}
		return false;
	}
	boolean mouseWheel(MouseEvent e) {
		if(isVisible()) {
			return child.mouseWheel(e);
		}
		return false;
	}
	void keyPressed() {
		if(isVisible()) {
			child.keyPressed();
		}
	}
	abstract boolean isVisible();

	void draw(boolean hit) {
		if(isVisible()) {
			child.draw(hit);
		}
	}

	Box getBoundary() {
		return child.getBoundary();
	}
	
	boolean isHit() {
		if(isVisible()) {
			return child.isHit();
		}
		return false;
	}

	void setXY(int xpos, int ypos) {
		child.setXY(xpos, ypos);
	}
	void setWH(int _width, int _height) {
		child.setWH(_width, _height);
	}
}
