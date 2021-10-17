abstract class EventDetector extends WidgetAdapter {
	Widget child;

	EventDetector(Widget child) {
		this.child = child;
	}

	abstract void onEvent(EventType eventType, MouseEvent e);

	Widget getAdapter() { return child; }
	
	@Override  boolean mousePressed() {
		if(isHit()) {
			onEvent(EventType.MOUSEPRESSED, null);
		}
		return child.mousePressed();
	}
	@Override  boolean mouseDragged() {
		if(isHit()) {
			onEvent(EventType.MOUSEDRAGGED, null);
		}
		return child.mouseDragged();
	}
	@Override  boolean mouseWheel(MouseEvent e) {
		if(isHit()) {
			onEvent(EventType.MOUSEWHEEL, e);
		}
		return child.mouseWheel(e);
	}
	@Override  void keyPressed() {
		if(isHit()) {
			onEvent(EventType.KEYPRESSED, null);
		}
		child.keyPressed();
	}
	
}

enum EventType {
	MOUSEWHEEL, MOUSEPRESSED, MOUSERELEASED, MOUSEDRAGGED, KEYPRESSED, KEYRELEASED;
}
