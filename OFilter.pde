class Filter extends SizedWidgetAdapter {
	Widget child;
	int filterid;
	boolean postfilter;

	Filter(Widget child, int filterid) {
		this(child, filterid, false);
	}
	Filter(Widget child, int filterid, boolean postfilter) {
		this.child = child;
		this.filterid = filterid;
		this.postfilter = postfilter;
	}

	Widget getAdapter() { return child; }

	@Override void draw(boolean hit) {
		cl.pushClip(xpos, ypos, _width, _height);
		if(!postfilter && usegl && usefilters) {
			filter(dm.filters[filterid]);
		}
		child.draw(hit);
		if(postfilter && usegl && usefilters) {
			filter(dm.filters[filterid]);
		}
		cl.popClip();
	}

	@Override void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
		child.setXY(xpos, ypos);
	}
	@Override void setWH(int _width, int _height) {
		this._width = _width;
		this._height = _height;
		child.setWH(_width, _height);
	}
}
