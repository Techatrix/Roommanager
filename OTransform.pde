class Transform extends WidgetAdapter {
	Widget child;
	int xoff = 0;
	int yoff = 0;
	Align ali;

	Transform(Widget child, int xoff, int yoff) {
		this.child = child;
		this.xoff = xoff;
		this.yoff = yoff;
	}
	Transform(Widget child, Align ali) {
		this.child = child;
		this.ali = ali;
	}
	Transform(Widget child, int xoff, int yoff, Align ali) {
		this.child = child;
		this.xoff = xoff;
		this.yoff = yoff;
		this.ali = ali;
	}

	Widget getAdapter() { return child; }

	@Override void setXY(int xpos, int ypos) {
		recalculateAlign();
		child.setXY(xpos+xoff, ypos+yoff);
	}

	@Override void setWH(int _width, int _height) {
		child.setWH(_width, _height);
		recalculateAlign();
	}

	void recalculateAlign() {
		Box box = getBoundary();
		if(ali == Align.TOPRIGHT) {
			this.xoff = width-box.w;
		} else if(ali == Align.BOTTOMLEFT) {
			this.yoff = height-box.h;
		} else if(ali == Align.BOTTOMRIGHT) {
			this.xoff = width-box.w;
			this.yoff = height-box.h;
		} else if(ali == Align.CENTERCENTER) {
			this.xoff = (width-box.w)/2;
			this.yoff = (height-box.h)/2;
		}
	}
}
