abstract class Popup extends SizedWidget {
	Widget child;
	boolean blur;
	boolean pvisible;
	PImage blurcache;

	Popup(Widget child) {
		this(child, true);
	}
	Popup(Widget child, boolean blur) {
		this.blur = blur;
		this.pvisible = false;
		this.child = 
		new Container(
			new Transform(child, Align.CENTERCENTER)
			, width, height, color(0,150)
		);
	}
	Popup(Widget[] children, String truetext, String falsetext) {
		this(children, truetext, falsetext, true);
	}
	Popup(Widget[] children, String truetext, String falsetext, boolean blur) {
		this.blur = blur;
		this.pvisible = false;
		Widget[] listviewitems = new Widget[children.length+1];
		for (int i=0;i<children.length;i++) {
			listviewitems[i] = children[i];
		}
        listviewitems[children.length] =
        new ListView(
			new Widget[] {
				new EventDetector(new Container(new Text(truetext))) {
					@Override public void onEvent(EventType et, MouseEvent e) {
						if(et == EventType.MOUSEPRESSED) {ontrue();}
					}
				},
				new EventDetector(new Container(new Text(falsetext))) {
					@Override public void onEvent(EventType et, MouseEvent e) {
						if(et == EventType.MOUSEPRESSED) {onfalse();}
					}
				},
			}, width/4, 30, width/8, Dir.RIGHT
		);
		this.child = 
		new Container(
			new Transform(
				new ListView(
					listviewitems, width/4, height/4
				), Align.CENTERCENTER
			), width, height, color(0,150)
		);
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

	abstract void ontrue();
	abstract void onfalse();
	abstract boolean isVisible();

	void draw(boolean hit) {
		if(isVisible()) {
			if(blur && usegl && usefilters) {
				if(!pvisible) {
					filter(dm.filters[0]);
					blurcache = g.get();
				}
				image(blurcache,0,0);
			}
			child.draw(hit);
			pvisible = true;
		} else {
			pvisible = false;
		}
	}

	Box getBoundary() {
		return child.getBoundary();
	}

	void setXY(int xpos, int ypos) {
		child.setXY(xpos, ypos);
	}
	
	void setWH(int _width, int _height) {
		child.setWH(_width, _height);
	}

	boolean isHit() {
		return isVisible() && child.isHit();
	}
}
