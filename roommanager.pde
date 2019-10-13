class Roommanager {
	ArrayList<Furniture> furnitures;
	Grid roomgrid;
	int selectionid;
	String name;

	float xoff, yoff, scale, angle1, angle2;

	int xgridsize, ygridsize, gridtilesize;

	int tool = 0;

	boolean viewmode = false; // true = 3D , false = 2D
	boolean setup = false;

	ArrayList<int[]> dragtiles = new ArrayList<int[]>();
	boolean dragstate;

	int newfurniturewidth = 1;
	int newfurnitureheight = 1;

	int newroomtilegroup = 0;

	Roommanager() {
		load(st.strings[0].getvalue());
	}
	Roommanager(String loadname) {
		load(loadname);
	}

	void mouseWheel(MouseEvent e) {
		float delta = e.getCount() > 0 ? 0.9 : e.getCount() < 0 ? 1.1 : 1.0;
		if(!viewmode) {
			if(scale*delta > 5) {
				delta = 5/scale;
			} else if(scale*delta < 0.25) {
				delta = 0.25/scale;
			}
			xoff = (xoff-mouseX) * delta + mouseX;
			yoff = (yoff-mouseY) * delta + mouseY;
			scale *= delta;
			scale = constrain(scale, 0.25,5);
		} else {
			scale += (delta-1)/2;
			scale = constrain(scale, 0.01,2.5);
		}
	}
	void mouseDragged() {
		if(!viewmode) {
			// Only dont drag if the mouseclick was a hit
			if(!ov.ishit()) {
				if(mouseButton == CENTER || tool == 0) {
					xoff += mouseX - pmouseX;
					yoff += mouseY - pmouseY;
				}
				if(mouseButton == LEFT && tool == 1) {
					int x = floor(getxpos());
					int y = floor(getypos());
					if(!isfurniture(x,y)){
						if(dragtiles.size() == 0) {
							dragstate = roomgrid.gettilestate(x,y);
						}
						int[] newgridtile = {x,y};
						if(!dragtiles.contains(newgridtile)) {
							dragtiles.add(newgridtile);
							roomgrid.settilestate(dragstate, x,y);
							roomgrid.gettile(x,y).roomgroup = newroomtilegroup;
						}
					}
				}
			}
		} else {
			if(mouseButton == CENTER || mouseButton == RIGHT) {
				angle2 -= map(mouseY - pmouseY, 0, height, 0, PI);
				angle1 += map(mouseX - pmouseX, 0, width, 0, TWO_PI);
			}
		}
	}
	void mouseReleased() {
		if(mouseButton == LEFT) {
			dragtiles = new ArrayList<int[]>();
		}
	}
	void mousePressed() {
		if(mouseButton == LEFT && !viewmode) {
			selectionid = -1;
			if(tool == 1) {
				int x = floor(getxpos());
				int y = floor(getypos());
				if(!isfurniture(x,y)){
					roomgrid.settilestate(!roomgrid.gettilestate(x,y), x,y);
					roomgrid.gettile(x,y).roomgroup = newroomtilegroup;
				}
			}
			if(tool == 2) {
				int xpos = floor(getxpos());
				int ypos = floor(getypos());

				boolean hit = false;
				for (int x=0;x<newfurniturewidth;x++) {
					for (int y=0;y<newfurnitureheight;y++) {
						if(!roomgrid.gettilestate(xpos+x,ypos+y) || isfurniture(xpos+x,ypos+y) || !roomgrid.isingrid(xpos+x,ypos+y)) {
							hit = true;
							break;
						}
					}
				}
				if(!hit) {
					furnitures.add(new Furniture(newfurniturewidth, newfurnitureheight, xpos, ypos));
				}
			}
			if(tool == 3) {
				boolean found = false;
				for (int i=0; i<furnitures.size(); i++) {
					if(!found) {
						if(furnitures.get(i).checkover()) {
							selectionid = i;
							found = true;
						}
					}
				}
			}
			if(tool == 4) {
				int x = floor(getxpos());
				int y = floor(getypos());
				roomgrid.filltool(!roomgrid.gettilestate(x,y), x,y);
			}
			if(tool == 5) {
				float fx = getxpos();
				float fy = getypos();
				int ix = floor(fx);
				int iy = floor(fy);
				if(roomgrid.gettilestate(ix,iy)) {
					stroke(0, 200, 255);
					fill(0, 200, 255, 150);
					GridTile gt = roomgrid.gettile(ix,iy);
					// Right
					if(fx % 1 > 0.8 && !roomgrid.gettilestate(ix+1,iy)) {
						gt.window[0] = !gt.window[0];
					}
					// Left
					if(fx % 1 < 0.2 && !roomgrid.gettilestate(ix-1,iy)) {
						gt.window[1] = !gt.window[1];
					}
					// Bottom
					if(fy % 1 > 0.8 && !roomgrid.gettilestate(ix,iy+1)) {
						gt.window[2] = !gt.window[2];
					}
					// Top
					if(fy % 1 < 0.2 && !roomgrid.gettilestate(ix,iy-1)) {
						gt.window[3] = !gt.window[3];
					}
				}
			}
			if(tool == 6) {
				for (int i=0; i<furnitures.size(); i++) {
					if(furnitures.get(i).checkover()) {
						furnitures.get(i).rot += PI/2;
					}
				}
			}
		}
	}
	void keyPressed() {
	  setKey(keyCode, true);
		if(!viewmode) {
			if(key == 127) {
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						furnitures.remove(i);
						selectionid = -1;
						break;
					}
				}
			}
			if(keyCode < 54 && keyCode > 48) {
				newroomtilegroup = keyCode - 49;
			}
			if(keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
				Furniture f = new Furniture(0,0);
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						f = furnitures.get(i);
						break;
					}
				}
				int dx = 0;
				int dy = 0;
				switch(keyCode) {
					case UP:
						dy = -1;
					break;
					case DOWN:
						dy = 1;
					break;
					case LEFT:
						dx = -1;
					break;
					case RIGHT:
						dx = 1;
					break;
				}
				if(dx != 0 || dy != 0) {
					boolean a = true;

					int b = (dx != 0) ? f._height : f._width;
					for (int v=0;v<b;v++ ) {
						int x = f.xpos;
						int y = f.ypos;

						if(dx != 0) {
							y += v;
							x += dx > 0 ? f._width : dx;
						} else {
							x += v;
							y += dy > 0 ? f._height : dy;
						}
						if(!roomgrid.gettilestate(x,y) || isfurniture(x,y) || !roomgrid.isingrid(x,y)) {
							a = false;
							break;
						}
					}
					if(a) {
						f.move(dx,dy);
					}
				}
			}
		}
	}
	 
	void keyReleased() {
	  setKey(keyCode, false);
	}


	int getxplanesize() {
		return xgridsize * gridtilesize;
	}
	int getyplanesize() {
		return ygridsize * gridtilesize;
	}

	float getxpos() {
		return (mouseX-xoff-ov._width)/gridtilesize/scale;
	}
	float getypos() {
		return (mouseY-yoff-ov._height)/gridtilesize/scale;
	}
	boolean isfurniture(int xpos, int ypos) {
		for (int i=0; i<furnitures.size(); i++) {
			Furniture f = furnitures.get(i);
			for (int x=0;x<f._width;x++) {
				for (int y=0;y<f._height;y++) {
					if(f.xpos+x == xpos && f.ypos+y == ypos) {
						return true;
					}
				}
			}
		}
		return false;
	}

	String[] loadrooms() {
		File f1 = new File(sketchPath("data/rooms.json"));

		String[] rooms = null;
		if (f1.exists())
		{
  			JSONArray json = loadJSONArray("data/rooms.json");
			rooms = new String[json.size()];
			for (int i=0;i<json.size();i++ ) {
				rooms[i] = json.getString(i);
			}
		}
		return rooms;
	}
	void save(String name) {
		println("Save: " + name);
		JSONObject json = new JSONObject();

  		json.setFloat("xoff", xoff);
  		json.setFloat("yoff", yoff);
  		json.setFloat("scale", scale);
  		json.setInt("xgridsize", xgridsize);
  		json.setInt("ygridsize", ygridsize);
  		json.setInt("gridtilesize", gridtilesize);
  		for (int i=0;i<5;i++ ) {
  			color c = roomgrid.roomgroups[i];
	  		json.setFloat("roomgroupcolor" + str(i) + "red", red(c));
	  		json.setFloat("roomgroupcolor" + str(i) + "green", green(c));
	  		json.setFloat("roomgroupcolor" + str(i) + "blue", blue(c));
  		}

		saveJSONObject(json, "data/" + name + "/data.json");
		//-------------------------------------------------------------------------------
		JSONArray furnituresarray = new JSONArray();

		for (int j = 0; j < furnitures.size(); j++) {

		  JSONObject f = new JSONObject();

		  f.setInt("id", j);
		  f.setInt("xpos", furnitures.get(j).xpos);
		  f.setInt("ypos", furnitures.get(j).ypos);
		  f.setInt("width", furnitures.get(j)._width);
		  f.setInt("height", furnitures.get(j)._height);

		  furnituresarray.setJSONObject(j, f);
		}

		saveJSONArray(furnituresarray, "data/" + name + "/furnitures.json");
		//-------------------------------------------------------------------------------
		JSONArray roomarray = new JSONArray();

		for (int x = 0; x < xgridsize; x++) {
			JSONArray row = new JSONArray();
			for (int y = 0; y < ygridsize; y++) {
				JSONObject tile = new JSONObject();
				tile.setBoolean("g", roomgrid.tiles[x][y].state);
				tile.setInt("r", roomgrid.tiles[x][y].roomgroup);

				JSONArray windows = new JSONArray();
				windows.setBoolean(0, roomgrid.tiles[x][y].window[0]);
				windows.setBoolean(1, roomgrid.tiles[x][y].window[1]);
				windows.setBoolean(2, roomgrid.tiles[x][y].window[2]);
				windows.setBoolean(3, roomgrid.tiles[x][y].window[3]);

  				tile.setJSONArray("w", windows);

				row.setJSONObject(y, tile);
			}
			roomarray.setJSONArray(x, row);
		}
  		surface.setTitle(appname + ": " + name);
  		this.name = name;

		saveJSONArray(roomarray, "data/" + name + "/room.json");
	}
	void load(String name) {
		println("Load: " + name);
		File f1 = new File(sketchPath("data/" + name + "/data.json"));
		File f2 = new File(sketchPath("data/" + name + "/furnitures.json"));
		File f3 = new File(sketchPath("data/" + name + "/room.json"));

		if (f1.exists())
		{
  			JSONObject json = loadJSONObject("data/" + name + "/data.json");
  			xoff = json.getFloat("xoff");
  			yoff = json.getFloat("yoff");
  			scale = json.getFloat("scale");
  			xgridsize = json.getInt("xgridsize");
  			ygridsize = json.getInt("ygridsize");
  			gridtilesize = json.getInt("gridtilesize");

			roomgrid = new Grid(xgridsize, ygridsize);
  			for (int i=0;i<5;i++ ) {
  				roomgrid.roomgroups[i] = color(json.getFloat("roomgroupcolor" + str(i) + "red"), json.getFloat("roomgroupcolor" + str(i) + "green"), json.getFloat("roomgroupcolor" + str(i) + "blue"));
  			}
		} else {
  			xgridsize = 24;
  			ygridsize = 12;
  			gridtilesize = 50;
			roomgrid = new Grid(xgridsize, ygridsize);
		}
		//-------------------------------------------------------------------------------

		furnitures = new ArrayList<Furniture>();
		if (f2.exists() && f1.exists())
		{
  			JSONArray json = loadJSONArray("data/" + name + "/furnitures.json");
			for (int j = 0; j < json.size(); j++) {
    			JSONObject f = json.getJSONObject(j); 

    			Furniture newf = new Furniture(0,0);
				newf.xpos = f.getInt("xpos");
				newf.ypos = f.getInt("ypos");
				newf._width = f.getInt("width");
				newf._height = f.getInt("height");
    			furnitures.add(newf);
			}
		}
		//-------------------------------------------------------------------------------

		if (f3.exists() && f1.exists())
		{
  			JSONArray json = loadJSONArray("data/" + name + "/room.json");

			for (int x = 0; x < xgridsize; x++) {
				JSONArray row = json.getJSONArray(x);
				for (int y = 0; y < ygridsize; y++) {
					JSONObject tile = row.getJSONObject(y);
					roomgrid.tiles[x][y].state = tile.getBoolean("g");
					roomgrid.tiles[x][y].roomgroup = tile.getInt("r");

					JSONArray window = tile.getJSONArray("w");
					roomgrid.tiles[x][y].window[0] = window.getBoolean(0);
					roomgrid.tiles[x][y].window[1] = window.getBoolean(1);
					roomgrid.tiles[x][y].window[2] = window.getBoolean(2);
					roomgrid.tiles[x][y].window[3] = window.getBoolean(3);
				}
			}
		}
		//-------------------------------------------------------------------------------
		settitle(name);
  		this.name = name;
		if(ov != null) {
			ov.sidebars[1].listitems[0].bv.value = name;
			ov.sidebars[1].listitems[0].bv.newvalue = name;
			ov.refresh();
		}
	}

	void reset() {
		reset3dcam();
		viewmode = false;
		xoff = 0;
		yoff = 0;
		scale = 1;
		tool = 0;
		roomgrid = new Grid(xgridsize, ygridsize);
		furnitures = new ArrayList<Furniture>();
		name = st.strings[0].getvalue();
		st.load();
  		surface.setTitle(appname + ": " + name);
	}
	void switchviewmode() {
		xoff = 0;
		yoff = 0;
		scale = 1;
		tool = 0;
		viewmode = !viewmode;
		if(viewmode && !setup) {
			reset3dcam();
			setup = true;
		}
	}
	void reset3dcam() {
		scale = 0.4;
		angle1 = PI*5/4;
		angle2 = -2;
		xoff = 0;
		yoff = 0;
	}


	void draw() {
		background(c[8]);
		push();
		if(!viewmode) {
			xoff = constrain(xoff, Integer.MIN_VALUE, 0);
			yoff = constrain(yoff, Integer.MIN_VALUE, 0);
			// 2D View
			float ovscale = st.booleans[1].getvalue() ? 0 : st.floats[1].getvalue();

			translate(xoff+ov._width*ovscale, yoff+ov._height*ovscale);
			scale(scale);
			if(!ov.ishit()) {
				if(tool == 1 || tool == 2) {
					int x = floor(getxpos());
					int y = floor(getypos());
					if(roomgrid.isingrid(x,y)) {
						noStroke();
						fill(c[0], 50);
						rect(x*gridtilesize,y*gridtilesize,gridtilesize,gridtilesize);
					}
				}
				if(tool == 3) {
					int x = floor(getxpos());
					int y = floor(getypos());

					boolean hit = false;
					for (Furniture f: furnitures) {
						if(f.checkover()) {
							noStroke();
							fill(c[8], 100);
							rect(f.xpos*gridtilesize,f.ypos*gridtilesize,gridtilesize*f._width,gridtilesize*f._height);
						}
					}
				}
				if(tool == 5) {
					float fx = getxpos();
					float fy = getypos();
					int ix = floor(fx);
					int iy = floor(fy);
					if(roomgrid.gettilestate(ix,iy)) {
						stroke(0, 200, 255);
						// Right
						if(fx % 1 > 0.8 && !roomgrid.gettilestate(ix+1,iy)) {
							line((ix+1)*rm.gridtilesize,iy*rm.gridtilesize,(ix+1)*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Left
						if(fx % 1 < 0.2 && !roomgrid.gettilestate(ix-1,iy)) {
							line(ix*rm.gridtilesize,iy*rm.gridtilesize,ix*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Bottom
						if(fy % 1 > 0.8 && !roomgrid.gettilestate(ix,iy+1)) {
							line(ix*rm.gridtilesize,(iy+1)*rm.gridtilesize,(ix+1)*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Top
						if(fy % 1 < 0.2 && !roomgrid.gettilestate(ix,iy-1)) {
							line(ix*rm.gridtilesize,iy*rm.gridtilesize,(ix+1)*rm.gridtilesize,iy*rm.gridtilesize);
						}
					}
				}
			}
		} else {
			if(isKeyUp) {
				xoff -= sin(-angle1+PI/2)*4;
				yoff -= cos(-angle1+PI/2)*4;
			}
			if(isKeyDown) {
				xoff += sin(-angle1+PI/2)*4;
				yoff += cos(-angle1+PI/2)*4;
			}
			if(isKeyLeft) {
				xoff += sin(-angle1)*4;
				yoff += cos(-angle1)*4;
			}
			if(isKeyRight) {
				xoff -= sin(-angle1)*4;
				yoff -= cos(-angle1)*4;
			}
			// 3D View
			xoff = constrain(xoff, 0, Integer.MAX_VALUE);
			yoff = constrain(yoff, 0, Integer.MAX_VALUE);
			angle2 = constrain(angle2, -PI+0.1, 0);
		  	pg.beginDraw();
			pg.background(st.booleans[0].getvalue() ? 0 : 240);
			pg.directionalLight(200, 200, 200, 0.3, 1, 0.3);
			pg.ambientLight(140,140,140);

			pg.perspective(60*PI/180, width/height, 1, 10000);

			// Camera
			float centerx = sin(angle2) * cos(angle1);
			float centery = cos(angle2);
			float centerz = sin(angle2) * sin(angle1);

			pg.camera(xoff,-height/2*scale,yoff, xoff+centerx,-height/2*scale-centery,yoff+centerz, 0, 1, 0);


			// Debug
			if(ov.sidebarid == 3) {
				pg.pushStyle();
				// Axis
				pg.strokeWeight(5);
				pg.stroke(150,0,0);
				pg.line(0,0,0,1000,0,0); // X
				pg.stroke(0,150,0);
				pg.line(0,0,0,0,0,1000); // Z
				pg.stroke(0,0,150);
				pg.line(0,0,0,0,1000,0); // Y
				pg.popStyle();
			}
		}
		// Roomgrid
		roomgrid.draw(viewmode);

		// Furnitures
		for (int i=0; i<furnitures.size(); i++) {
			Furniture f = furnitures.get(i);
			f.draw(viewmode, selectionid == i);
		}
		// Draw 3D Graphics
		if(viewmode) {
			pg.endDraw();
			image(pg,0,0);
		}
		pop();
	}
}