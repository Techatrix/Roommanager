class DataManager {
	final PImage[] icons;				// list of all icons
	final FurnitureData[] furnitures;	// list of all furnitures that can be used
	final PrefabData[] prefabs;			// list of all prefabs that can be used

	DataManager() {
		if(deb) {
			println("Load DataManager");
		}
		/* --------------- load icon data --------------- */
		icons = new PImage[7];
		icons[0] = loadImage("data/assets/icon/0.png");
		icons[1] = loadImage("data/assets/icon/1.png");
		icons[2] = loadImage("data/assets/icon/2.png");
		icons[3] = loadImage("data/assets/icon/3.png");
		icons[4] = loadImage("data/assets/icon/4.png");
		icons[5] = loadImage("data/assets/icon/5.png");
		icons[6] = loadImage("data/assets/icon/6.png");

		/* --------------- load furniture data --------------- */
		JSONArray furnituredata;
		File f1 = new File(sketchPath("data/furnituredata.json"));
		if (f1.exists()) {
			furnituredata = loadJSONArray("data/furnituredata.json");
		} else {
			furnituredata = new JSONArray();
		}

		furnitures = new FurnitureData[furnituredata.size()];
		for (int i=0;i<furnituredata.size();i++) {
			JSONObject furn = furnituredata.getJSONObject(i);

			int _width = furn.getInt("width", 1);
			int _height = furn.getInt("height", 1);
			String src = furn.getString("src");
			int price = furn.getInt("price", 0);
			PImage image = loadImage("data/assets/furn/img/" + src +".png");
			PShape shape = null;
			if(st.booleans[3].value) {
				shape = pg.loadShape("data/assets/furn/mdl/" + src +".obj");
			}
			String name = furn.getString("name", "Name not Found");
			furnitures[i] = new FurnitureData(i, _width, _height, image, shape, name, price);
		}
		
		/* --------------- load prefab data --------------- */
		JSONArray prefabdata;
		File f2 = new File(sketchPath("data/prefabdata.json"));
		if (f2.exists()) {
			prefabdata = loadJSONArray("data/prefabdata.json");
		} else {
			prefabdata = new JSONArray();
		}
		prefabs = new PrefabData[prefabdata.size()];

		for (int i=0;i<prefabdata.size();i++) {
			JSONObject pref = prefabdata.getJSONObject(i);

			int _height = pref.getInt("height", 1);
			int _width = pref.getInt("width", 1);
			String name = pref.getString("name", "Name not Found");

			JSONArray prefabfurnsdata = pref.getJSONArray("furnitures");
			PrefabFurnitureData[] prefabfurns = new PrefabFurnitureData[prefabfurnsdata.size()];
			// Check null

			for (int j=0;j<prefabfurnsdata.size();j++) {
				JSONObject preffurn = prefabfurnsdata.getJSONObject(j);

				int furnid = preffurn.getInt("id", 0);
				int xpos = preffurn.getInt("xpos", 0);
				int ypos = preffurn.getInt("ypos", 0);
				prefabfurns[j] = new PrefabFurnitureData(furnid, xpos, ypos);
			}

			prefabs[i] = new PrefabData(_width, _height, name, prefabfurns);
		}
	}

	FurnitureData getfurnituredata(int id) {
		for (FurnitureData fdata : furnitures) {
			if(id == fdata.id) {
				return fdata;
			}
		}
		return null;
	}
	PrefabData getprefabdata(int id) {
		return prefabs[id];
	}
}


class FurnitureData {
	final int id;
	final int _width;
	final int _height;
	final PImage image;
	final PShape shape;
	final String name;
	final int price;

	FurnitureData(int id, int _width, int _height, PImage image, PShape shape, String name, int price) {
		this.id = id;
		this._width = _width;
		this._height = _height;
		this.image = image;
		this.shape = shape;
		this.name = name;
		this.price = price;
	}
}
class PrefabFurnitureData {
	final int id;
	final int xpos;
	final int ypos;

	PrefabFurnitureData(int id, int xpos, int ypos) {
		this.id = id;
		this.xpos = xpos;
		this.ypos = ypos;
	}
}
class PrefabData {
	final int _width;
	final int _height;
	final String name;
	final PrefabFurnitureData[] furnitures;

	PrefabData(int _width, int _height, String name, PrefabFurnitureData[] furnitures) {
		this._width = _width;
		this._height = _height;
		this.name = name;
		this.furnitures = furnitures;
	}

	PImage getimage() {
		PGraphics pg = createGraphics(_width*50,_height*50);
		pg.beginDraw();
		pg.scale(50);
		pg.background(0, 50);

		for (int i=0;i<furnitures.length;i++) {
			PrefabFurnitureData preffurndata = furnitures[i];
			FurnitureData furndata = dm.getfurnituredata(preffurndata.id);
			pg.image(furndata.image, preffurndata.xpos, preffurndata.ypos, furndata._width, furndata._height);
		}
		pg.endDraw();
		return pg.get();
	}

	boolean isfurniture(int xpos, int ypos) {
		if(xpos > -1 && xpos < _width && ypos > -1 && ypos < _height) {
			boolean block = false;
			for (int i=0;i<furnitures.length;i++) {
				PrefabFurnitureData preffurndata = furnitures[i];
				FurnitureData furndata = dm.getfurnituredata(preffurndata.id);
				for (int x=0;x<furndata._width;x++) {
					for (int y=0;y<furndata._height;y++) {
						if(xpos == preffurndata.xpos+x && ypos == preffurndata.ypos+y) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}
}