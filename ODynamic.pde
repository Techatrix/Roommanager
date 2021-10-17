abstract class Dynamic extends SizedWidgetAdapter {
	Widget child;
	boolean hasSetXY = false;
	boolean hasSetWH = false;

	Dynamic() {
		child = getWidget();
	}

	Widget getAdapter() { return child; }

	abstract Widget getWidget();

	@Override void draw(boolean hit) {
		child = getWidget();
		if(hasSetXY) child.setXY(xpos, ypos);
		if(hasSetWH) child.setXY(_width, _height);
		child.draw(hit);
	}

	@Override void setXY(int xpos, int ypos) {
		hasSetXY = true;
		this.xpos = xpos;
		this.ypos = ypos;
		super.setXY(xpos, ypos);
	}

	@Override void setWH(int _width, int _height) {
		hasSetWH = true;
		this._width = _width;
		this._height = _height;
		super.setWH(_width, _height);
	}
	
}
