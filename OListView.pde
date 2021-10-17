class ListView extends SizedWidget {
	Widget[] children;
	int itemheight;
	Enum dir;
	int off = 0;

	ListView(Widget[] children) {
		this(children, 0, 0, 30);
	}
	ListView(Widget[] children, int _width, int _height) {
		this(children, _width, _height, 30);
	}
	ListView(Widget[] children, int _width, int _height, Dir dir) {
		this(children, _width, _height, 0, dir);
	}
	ListView(Widget[] children, int _width, int _height, int itemheight) {
		this(children, _width, _height, itemheight, Dir.DOWN);
	}
	ListView(Widget[] children, int _width, int _height, int itemheight, Dir dir) {
		this.children = children;
		this.itemheight = itemheight;
		this.dir = dir;
		setWH(_width, _height);
	}

	boolean mousePressed() {
		for (Widget child : children) {
			child.mousePressed();
		}
		return isHit();
	}
	boolean mouseDragged() {
		for (Widget child : children) {
			if(child.mouseDragged()) {
				return true;
			}
		}
		return false;
	}
	boolean mouseWheel(MouseEvent e) {
		boolean isitemwheelhit = false;
		for (Widget child : children) {
			if(child.isHit()) {
				if(child.mouseWheel(e)) {
					isitemwheelhit = true;
				}
			}
		}
		if(isHit() && !isitemwheelhit) {
			int length = 0;

			for (Widget child : children) {
				boolean ee = false;
				if(child instanceof SizedBox) {
					if(((SizedBox)child).expand) {
						ee = true;
					}
				}
				if(!ee) {
					Box b = child.getBoundary();
					length += max(itemheight, (dir == Dir.DOWN || dir == Dir.UP) ? b.h : b.w);
				}
			}

			if(dir == Dir.UP || dir == Dir.DOWN) {
				if(length > _height) {
					off -= e.getCount()*15;
					if(dir == Dir.UP) {
						off = constrain(off, 0, length - _height);
					} else {
						off = constrain(off, _height - length, 0);
					}
				}
			} else {
				if(length > _width) {
					off -= e.getCount()*15;
					if(dir == Dir.DOWN) {
						off = constrain(off, 0, length - _width);
					} else {
						off = constrain(off, _width - length, 0);
					}
				}
			}
			recalculateChildren();
			return true;
		}
		return false;
	}
	void keyPressed() {
		for (Widget child : children) {
			child.keyPressed();
		}
	}

	void draw(boolean hit) {
		fill(c[6]);

		boolean c = false;
		if(cl.get() == null) {
			cl.pushClip(xpos, ypos, _width, _height);
			c = true;
		}

		rect(xpos, ypos, _width, _height);
		boolean h = hit && isHit();
		for (Widget child : children) {
			child.draw(h);
		}

		if(c) {
			cl.popClip();
		}
	}

	Box getBoundary() {
		return new Box(_width, _height);
	}
	
	boolean isHit() {
	  	return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
	}

	void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
		recalculateChildren();
	}

	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateChildren();
	}

	void recalculateChildren() {
		int sizelength = 0;
		int expands = 0;

		for (Widget child : children) {
			boolean e = false;
			if(child instanceof SizedBox) {
				if(((SizedBox)child).expand) {
					e = true;
					expands++;
				}
			}
			if(!e) {
				Box box = child.getBoundary();
				sizelength += max(itemheight, (dir == Dir.DOWN || dir == Dir.UP) ? box.h : box.w);
			}
		}
		int expandsize = 0;
		if(expands > 0) {
			expandsize = (((dir == Dir.DOWN || dir == Dir.UP) ? _height : _width) - sizelength)/expands;
			if(expandsize < 0) {
				expandsize = 0;
			}
		}

		int off2 = 0;
		for (Widget child : children) {
			boolean e = false;
			if(child instanceof SizedBox) {
				if(((SizedBox)child).expand) {
					e = true;
				}
			}
			if(dir == Dir.DOWN || dir == Dir.UP) {
				if(dir == Dir.DOWN) {
					child.setXY(xpos, ypos+off+off2);
				}
				if(e) {
					child.setWH(_width, expandsize);
					off2 += expandsize;
				} else {
					Box box = child.getBoundary();
					child.setWH(_width, max(itemheight, box.h));
					off2 += max(itemheight, box.h);
				}
				if(dir == Dir.UP) {
					child.setXY(xpos, ypos+_height-off-off2);
				}
			} else {
				if(dir == Dir.RIGHT) {
					child.setXY(xpos+off+off2, ypos);
				}
				if(e) {
					child.setWH(expandsize, _height);
					off2 += expandsize;
				} else {
					Box box = child.getBoundary();
					child.setWH(max(itemheight, box.w), _height);
					off2 += max(itemheight, box.w);
				}
				if(dir == Dir.LEFT) {
					child.setXY(xpos+_width-off-off2, ypos);
				}
			}
		}
	}

	int getIndex() {
		for (int i=0;i<children.length;i++) {
			if(children[i].mousePressed()) {
				return i;
			}
		}
		return -1;
	}
	
}
