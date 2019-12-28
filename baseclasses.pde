/* --------------- super classes --------------- */
class Point { // point
	int xpos = 0;
	int ypos = 0;
}
class PWH extends Point { // point width height
	int _width = 0;
	int _height = 0;
}
class RPoint extends Point { // rotation and point 
	float rot = 0;
}
class RPWH extends PWH { // rotation and point width height
	float rot = 0;
}
/* --------------- temporary classes --------------- */
// used for final values in an abstract class
class Temp { // holds a integer
	int i;
	Temp(int i) {
		this.i = i;
	}
}
class STemp { // holds a string
	String s;
	STemp(String s) {
		this.s = s;
	}
}
