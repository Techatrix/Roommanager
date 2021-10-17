abstract class Tabbar extends Widget {
	Widget list;
	Widget[] tabs;

	Tabbar(Widget list, Widget[] tabs) {
		this.list = list;
		this.tabs = tabs;
	}

	void draw(boolean hit) {
		list.draw(hit);
		if(isValidTab()) {
			tabs[getIndex()].draw(hit);
		}
	}

	boolean mousePressed() {
		boolean hit = false;
		if(list.mousePressed()) {
			hit = true;
			onTab(getListIndex(list));
		}
		if(isValidTab()) {
			if(tabs[getIndex()].mousePressed()) {
				hit = true;
			}
		}
		return hit;
	}
	boolean mouseDragged() {
		boolean hit = false;
		if(list.mouseDragged()) {
			hit = true;
			onTab(getListIndex(list));
		}
		if(isValidTab()) {
			if(tabs[getIndex()].mouseDragged()) {
				hit = true;
			}
		}
		return hit;
	}
	boolean mouseWheel(MouseEvent e) {
		boolean result = list.mouseWheel(e);
		if(isValidTab()) {
			if(tabs[getIndex()].mouseWheel(e)) {
				result = true;
			}
		}
		return result;
	}
	void keyPressed() {
		list.keyPressed();
		if(isValidTab()) {
			tabs[getIndex()].keyPressed();
		}
	}

	abstract void onTab(int i);
	abstract int getIndex();

	boolean isValidTab() {
		return -1 < getIndex() && getIndex() < tabs.length;
	}

	Box getBoundary() {
		return list.getBoundary();
	}
	
	boolean isHit() {
		boolean hit = false;
		if(list.isHit()) {
			hit = true;
		}
		if(isValidTab()) {
			if(tabs[getIndex()].isHit()) {
				hit = true;
			}
		}
		return hit;
	}

	void setXY(int xpos, int ypos) {
		list.setXY(xpos, ypos);
		for (Widget tab : tabs) {
			tab.setXY(xpos, ypos);
		}
	}

	void setWH(int _width, int _height) {
		list.setWH(_width, _height);
		for (Widget tab : tabs) {
			tab.setWH(_width, _height);
		}
	}
	
}
