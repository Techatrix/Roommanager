String getabout() { // return the about text
	String text = appname + "\n";
	text += lg.get("version") + ": " + appversion + "\n";
	text += lg.get("programmedwith") + ": " + "Processing" + "\n";
	text += lg.get("madeby") + ": " + appmaker + "\n";
	return text;
}

void setKey(int k, boolean bool) {	// sets the state of the arrow keys
  if      (k == UP    | k == 'W')   isKeyUp    = bool;
  else if (k == DOWN  | k == 'S')   isKeyDown  = bool;
  else if (k == LEFT  | k == 'A')   isKeyLeft  = bool;
  else if (k == RIGHT | k == 'D')   isKeyRight = bool;
  else if (             k == 'T')   isKeyT     = bool;
}

String cap(String str) { // converts the first letter of a string to upper case
	return str.substring(0, 1).toUpperCase() + str.substring(1);
}

boolean checkraw(int xpos, int ypos, int _width, int _height) { // checks if the mouse is inside a rectangle
	float scale = st.floats[1].value;
	if (mouseX >= xpos*scale && mouseX <= (xpos+_width)*scale && 
	    mouseY >= ypos*scale && mouseY <= (ypos+_height)*scale) {
	  	return true;
	}
	return false;
}