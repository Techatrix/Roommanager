class Settings {
	//final SettingColorValue[] colors;		// setting values of type string ( not used)
	final SettingStringValue[] strings;		// setting values of type string
	final SettingBooleanValue[] booleans;	// setting values of type boolean
	final SettingIntValue[] ints;			// setting values of type integer
	final SettingFloatValue[] floats;		// setting values of type float

	Settings() {
		if(deb) {
			toovmessages.add("Loading Settings Class");
		}
		strings = new SettingStringValue[3];
		booleans = new SettingBooleanValue[4];
		ints = new SettingIntValue[3];
		floats = new SettingFloatValue[1];
		/*
		colors = new SettingColorValue[0];
		colors[0] = new SettingColorValue("backgroundcolor", color(0, 0, 0));
		colors[1] = new SettingColorValue("overlaybackgroundcolor", color(200, 200, 200));
		colors[2] = new SettingColorValue("overlaycolor", color(100, 100, 100));
		colors[3] = new SettingColorValue("gridlinecolor", color(255, 255, 255));
		*/
		// these settings should explain themselves
		strings[0] = new SettingStringValue("defaultroomname", "new room");
		strings[1] = new SettingStringValue("language", "english");
		strings[2] = new SettingStringValue("font", "Arial");

		booleans[0] = new SettingBooleanValue("darkmode", true);
		booleans[1] = new SettingBooleanValue("hideoverlay", false);
		booleans[2] = new SettingBooleanValue("fullscreen", false);
		booleans[3] = new SettingBooleanValue("useglrenderer", false);	// should be disabled on 32-bit and older devices

		ints[0] = new SettingIntValue("width", 1200, 600, displayWidth);
		ints[1] = new SettingIntValue("height", 800, 600, displayHeight);
		ints[2] = new SettingIntValue("antialiasing", 2, 0, 8);

		floats[0] = new SettingFloatValue("gridlineweight", 1);

		load();
	}
	
	int getSize() {	// get length of all settings
		return /*colors.length +*/ strings.length + booleans.length + ints.length + floats.length;
	}

	String set(int id, String value) { // sets the chosen settings value to the given value (automatic data type conversion)
		String result = null;
		int index = 0;
		for (int i=0;i<strings.length;i++) {
			if(index == id) {
				result = strings[i].setValue(value);
			}
			index++;
		}
		for (int i=0;i<booleans.length;i++) {
			if(index == id) {
				result = booleans[i].setValue(value);
			}
			index++;
		}
		for (int i=0;i<ints.length;i++) {
			if(index == id) {
				result = ints[i].setValue(value);
			}
			index++;
		}
		for (int i=0;i<floats.length;i++) {
			if(index == id) {
				result = floats[i].setValue(value);
			}
			index++;
		}
		save();
		return result;
	}

	SettingValue get(int id) { // return the setting value with the given id
		int index = 0;
		for (int i=0;i<strings.length;i++) {
			if(index == id) {
				return strings[i].get();
			}
			index++;
		}
		for (int i=0;i<booleans.length;i++) {
			if(index == id) {
				return booleans[i].get();
			}
			index++;
		}
		for (int i=0;i<ints.length;i++) {
			if(index == id) {
				return ints[i].get();
			}
			index++;
		}
		for (int i=0;i<floats.length;i++) {
			if(index == id) {
				return floats[i].get();
			}
			index++;
		}
		toovmessages.add("Setting not found: " + id);
		return null;
	}

	void load() { // loads the settings from data/settings.json if possible
		if(deb) {
			toovmessages.add("Loading Settings");
		}
		File f1 = new File(sketchPath("data/settings.json"));

		if (f1.exists())
		{
			JSONObject j = loadJSONObject("data/settings.json");
			/*
			for (int i=0;i<colors.length;i++) {
				SettingColorValue c = colors[i];
				c.setValue(color(j.getFloat(c.name + "red"), j.getFloat(c.name + "green"), j.getFloat(c.name + "blue")));
				colors[i] = c;
			}
			*/
			for (int i=0;i<strings.length;i++) {
				SettingStringValue s = strings[i];
				s.setValue(j.getString(s.name, s.defaultvalue));
				strings[i] = s;
			}
			for (int i=0;i<booleans.length;i++) {
				SettingBooleanValue b = booleans[i];
				b.setValue(j.getBoolean(b.name, b.defaultvalue));
				booleans[i] = b;
			}
			for (int k=0;k<ints.length;k++) {
				SettingIntValue i = ints[k];
				i.setValue(j.getInt(i.name, i.defaultvalue));
				ints[k] = i;
			}
			for (int i=0;i<floats.length;i++) {
				SettingFloatValue f = floats[i];
				f.setValue(j.getFloat(f.name, f.defaultvalue));
				floats[i] = f;
			}
		}
	}

	void save() { // saves the settings to data/settings.json
		if(deb) {
			toovmessages.add("Saved Settings");
		}

		File f1 = new File(sketchPath("data/settings.json"));
		JSONObject j = new JSONObject();
		if (f1.exists())
		{
			j = loadJSONObject("data/settings.json");
		}
		/*
		for (int i=0;i<colors.length;i++) {
			SettingColorValue c = colors[i];
			j.setInt(c.name + "red", red(c.getValue()));
			j.setInt(c.name + "green", green(c.getValue()));
			j.setInt(c.name + "blue", blue(c.getValue()));
		}
		*/
		for (int i=0;i<strings.length;i++) {
			SettingStringValue s = strings[i];
			j.setString(s.name, s.value);
		}
		for (int i=0;i<booleans.length;i++) {
			SettingBooleanValue b = booleans[i];
			j.setBoolean(b.name, b.value);
		}
		for (int k=0;k<ints.length;k++) {
			SettingIntValue i = ints[k];
			j.setInt(i.name, i.value);
		}
		for (int i=0;i<floats.length;i++) {
			SettingFloatValue f = floats[i];
			j.setFloat(f.name, f.value);
		}

		saveJSONObject(j, "data/settings.json");
	}
}
/* --------------- setting value --------------- */
/*
class SettingColorValue {
	String name;
	color value;
	SettingColorValue(String newname) {
		name = newname;
	}
	SettingColorValue(String newname, color newdefaultvalue) {
		name = newname;
		value = newdefaultvalue;
	}
	void setValue(color newvalue) {
		value = newvalue;
	}
}
*/
class SettingStringValue {
	final String name;
	final String defaultvalue;
	String value;

	SettingStringValue(String newname, String newdefaultvalue) {
		name = newname;
		value = newdefaultvalue;
		defaultvalue = newdefaultvalue;
	}
	String setValue(String newvalue) {
		value = newvalue;
		return value;
	}
	SettingValue get() {
		return new SettingValue(name, value, 0);
	}
}
class SettingBooleanValue {
	final String name;
	final boolean defaultvalue;
	boolean value;

	SettingBooleanValue(String newname, boolean newdefaultvalue) {
		name = newname;
		value = newdefaultvalue;
		defaultvalue = newdefaultvalue;
	}
	void setValue(boolean newvalue) {
		value = newvalue;
	}
	String setValue(String newvalue) {
		if(newvalue.equals("true") || newvalue.equals("1")) {
			value = true;
			return "true";
		}
		if(newvalue.equals("false") || newvalue.equals("1")) {
			value = false;
			return "false";
		}
		return null;
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 1);
	}
}
class SettingIntValue {
	final String name;
	final int defaultvalue;
	int value;
	final int min;
	final int max;

	SettingIntValue(String newname, int newdefaultvalue) {
		this(newname, newdefaultvalue, Integer.MIN_VALUE, Integer.MAX_VALUE);
	}
	SettingIntValue(String newname, int newdefaultvalue, int minvalue, int maxvalue) {
		name = newname;
		value = newdefaultvalue;
		defaultvalue = newdefaultvalue;
		min = minvalue;
		max = maxvalue;
	}
	void setValue(int newvalue) {
		value = constrain(newvalue, min, max);
	}
	String setValue(String newvalue) {
		setValue(int(newvalue));
		return str(value);
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 2);
	}
}
class SettingFloatValue {
	final String name;
	final float defaultvalue;
	float value;
	final float min;
	final float max;
	
	SettingFloatValue(String newname, float newdefaultvalue) {
		this(newname, newdefaultvalue, Float.MIN_VALUE, Float.MAX_VALUE);
	}
	SettingFloatValue(String newname, float newdefaultvalue, float minvalue, float maxvalue) {
		name = newname;
		value = newdefaultvalue;
		defaultvalue = newdefaultvalue;
		min = minvalue;
		max = maxvalue;
	}
	void setValue(float newvalue) {
		value = constrain(newvalue, min, max);
		if(Float.isNaN(this.value)) {
			value = 0;
		}
	}
	String setValue(String newvalue) {
		setValue(float(newvalue));
		return str(value);
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 3);
	}
}

class SettingValue {
	String name;	// name of the setting
	String value;	// value of the setting
	int type; 		// data type of the setting

	SettingValue(String name, String value, int type) {
		this.name = name;
		this.value = value;
		this.type = type;
	}
}
