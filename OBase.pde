class Box {
	int w;
	int h;
	Box(int w, int h) {
		this.w = w;
		this.h = h;
	}
	Box(float w, float h) {
		this.w = round(w);
		this.h = round(h);
	}
}

class TabData {
	String name;
	int id;
	boolean type;
	
	TabData(String name, int id, boolean type) {
		this.name = name;
		this.id = id;
		this.type = type;
	}
}

abstract class Builder{
	Widget[] build(int length) {
		Widget[] children = new Widget[length];
		for (int i=0;i<length;i++) {
			children[i] = i(i);
		}
		return children;
	}

	abstract Widget i(int i);
}

abstract class ListViewBuilder{
	ListView build(int length, int _width, int _height) {
		return build(length, _width, _height, 30, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight) {
		return build(length, _width, _height, itemheight, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight, Dir dir) {
		Widget[] children = new Widget[length];
		for (int i=0;i<length;i++) {
			children[i] = i(i);
		}
		return new ListView(children, _width, _height, itemheight, dir);
	}

	abstract Widget i(int i);
}

enum Dir { // used by ListView
    UP, RIGHT, DOWN, LEFT;
}
enum Align { // used by Transform
    TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTERCENTER;
}
enum Fit { // used by Image
	EXPAND, RATIO
}

abstract class Widget
{
	abstract void draw(boolean hit);
	abstract Box getBoundary();
	abstract boolean isHit();

	abstract void setXY(int xpos, int ypos);
	abstract void setWH(int _width, int _height);

	boolean mousePressed() { return false; }
	void mouseReleased() { }
	boolean mouseDragged() { return false; }
	boolean mouseWheel(MouseEvent e) { return false; }

	void keyPressed() {}
	void keyReleased() {}
}

abstract class SizedWidget extends Widget
{
	int xpos = 0;
	int ypos = 0;
	int _width = 0;
	int _height = 0;
}

abstract class WidgetAdapter extends Widget
{
	abstract Widget getAdapter();

	void draw(boolean hit) { getAdapter().draw(hit); }
	Box getBoundary() { return getAdapter().getBoundary(); }
	boolean isHit() { return getAdapter().isHit(); }

	void setXY(int xpos, int ypos) { getAdapter().setXY(xpos, ypos); }
	void setWH(int _width, int _height) { getAdapter().setWH(_width, _height); }

	boolean mousePressed() { return getAdapter().mousePressed(); }
	void mouseReleased() { getAdapter().mouseReleased(); }
	boolean mouseDragged() { return getAdapter().mouseDragged(); }
	boolean mouseWheel(MouseEvent e) { return getAdapter().mouseWheel(e); }

	void keyPressed() { getAdapter().keyPressed(); }
	void keyReleased() { getAdapter().keyReleased(); }
}

abstract class SizedWidgetAdapter extends WidgetAdapter
{
	int xpos = 0;
	int ypos = 0;
	int _width = 0;
	int _height = 0;
}

// WARNING!!!
// DO NOT LOOK AT THE HISTORY OF THIS FILE

int getListIndex(Widget item) {
	if (item instanceof ListView) {
		return ((ListView)item).getIndex();
	} else if(item instanceof GridView) {
		return ((GridView)item).getIndex();
	}
	return -1;
}
