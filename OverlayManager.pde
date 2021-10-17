class OverlayManager extends Overlay {
	final int xoff = 50;						// used for aligning the room grid with the overlay
	final int yoff = 30;						// used for aligning the room grid with the overlay

	boolean drawpopup = false;					// visibility state of current popup
	int tabid = -1;								// used by Tab bar (see OTabbar.pde)
	String newroomname;							// the name of a new room 
	int newroomxsize = 15, newroomysize = 15;	// the size of a new room
	Object tempdata;							// temporary variable with different uses(mostly for transferring data to popups)

	// Message Box
	ArrayList<String> messages = new ArrayList<String>(); // messages on the console
	int consoleoff = 0;							// offset of the console messages (scrolling)
	boolean drawconsole = false;				// visibility state of console
	final int messageboxheight = 180;			// constant height of the message box

	final TabData[] tabs;

	OverlayManager() {
		if(deb) {
			tabs = new TabData[] {new TabData("newroom",1,true),new TabData("viewmode",-1,false),new TabData("loadroom",0,false),
			new TabData("saveroom",1,false),new TabData("debug",3,false),new TabData("roomgroups",4,false), new TabData("price",5,false),
			new TabData("settings",2,false),new TabData("reset", 3,true),new TabData("about",2,true)};
		} else {
			tabs = new TabData[] {new TabData("newroom",1,true),new TabData("viewmode",-1,false),new TabData("loadroom",0,false),
			new TabData("saveroom",1,false),new TabData("roomgroups",4,false), new TabData("price",5,false),
			new TabData("settings",2,false),new TabData("reset", 3,true),new TabData("about",2,true)};
		}
		newroomname = st.strings[0].value;
		visible = !st.booleans[1].value;
		build();
	}

	void build() {
		Widget[] items = {
			null,
			createTabBar(),
			createToolBar(),
			createMessageBox()
		};
		setItems(items);
	}

	Widget createTabBar() {
		return new Tabbar(
			// Tab selection bar 
			new ListViewBuilder() {
				Widget i(int i) {
					TabData td = tabs[i];
					if(td.id == -1) {
						return new Container(new GetValueText(lg.get(td.name)) {
							String getvalue() {return rm.viewmode ? "3D" : "2D";}
						});
					} else {
						return new Container(new Text(lg.get(td.name)));
					}
				}
			}.build(tabs.length, width, yoff, 120, Dir.RIGHT),
			// Tabs
			new Widget[] {
				// load room
				new Transform(
					new ListView(
						new Builder() {
							Widget i(int i) {
								return new EventDetector(new Container(new Text(lg.get("room") + ": " + rm.loadRooms()[i]))) {
									void onEvent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											rm.load(rm.loadRooms()[i]);
										}
									}
								};
							}
						}.build(rm.loadRooms().length), 300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// save room
				new Transform(
					new ListView(
						new Widget[] {
							new Container(new SetValueText(lg.get("name"), newroomname) {
								void onchange() {ov.newroomname = newvalue;value = newvalue;}
							}),
							new SizedBox(),
							new EventDetector(new Container(new Text(lg.get("save")))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										if(st.strings[0].value == ov.newroomname) {
											drawPopup(8);
										} else {
											rm.save(ov.newroomname);
											ov.build();
										}
									}
								}
							},
						}, 300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// settings
				new Transform(
					new ListViewBuilder() {
						Widget i(int i) {
							final String sliderName = lg.get(st.get(i).name);

							switch(st.get(i).type) {
								case 1: // boolean
								boolean val = st.get(i).value.equals("true") ? true : false;
								return new Container(new CheckBox(sliderName, val, LEFT) {
									void onchange() {
										st.set(i, str(value));
										switch(i) {
											case 3:
											am.recalculateColor();
											break;
											case 4: // Hide Overlay
											if(visible != !st.booleans[1].value) {
												visible = !st.booleans[1].value;
												ov.build();
											}
											break;
											case 5: // Fullscreen
											drawPopup(0);
											break;
											case 6: // OPENGL Renderer
											drawPopup(0);
											break;
										}
									}
								});
								case 3: // float
								return new Container(new Slider(sliderName, float(st.get(i).value)/5, LEFT) {
									void onchange(float newvalue) {
										st.set(i, str(constrain((float)round(value*50)/10, 0, 5)));
										value = constrain(newvalue, 0, 1);
									}
									String gettext() {
										return str(constrain((float)round(value*50)/10, 0, 5));
									}
								});
							}
							return new Container(new SetValueText(lg.get(st.get(i).name), st.get(i).value, new SetValueStyle(st.get(i).type), LEFT) {
								void onchange() {
									String result = st.set(i, newvalue);
									if(result != null && value != newvalue) {
										value = result;
										switch(i) {
											case 1:
											lg.setLang(st.strings[1].value);
											ov.build();
											break;
											case 2:
											am.setFont(st.strings[2].value);
											break;
											case 7: // Width
											surface.setSize(st.ints[0].value,st.ints[1].value);
											if(usegl) {
												pg.setSize(width,height);
											}
											ov.build();
											break;
											case 8: // Height
											surface.setSize(st.ints[0].value,st.ints[1].value);
											if(usegl) {
												pg.setSize(width,height);
											}
											ov.build();
											break;
											case 9: // AA
											drawPopup(0);
											break;
										}
									}
								}
							});
						}
					}.build(st.getSize(), 300, height-yoff),0,yoff, Align.TOPRIGHT
				),
				// debug
				new Transform(
					new Dynamic() {
						Widget getWidget() {
							final String[] names = new String[] {"name","xoff","yoff","scale","dxoff","dyoff","dzoff","angle1","angle2",
								"dspeed","gridtilesize","tool","viewmode","newfurnitureid","isprefab","newroomgroup","selectionid"};
							final String[] values = new String[] {rm.name,str(rm.xoff),str(rm.yoff),str(rm.scale),str(rm.dxoff),
								str(rm.dyoff),str(rm.dzoff),str(rm.angle1),str(rm.angle2),str(rm.dspeed),str(rm.gridtilesize),
								str(rm.tool),str(rm.viewmode),str(rm.newfurnitureid),str(rm.isprefab),str(rm.newroomgroup),str(rm.selectionid)};

							return new ListViewBuilder() {
								Widget i(int i) {
									return new Container(new Text(lg.get(names[i]) + ": " + values[i]));
								}
							}.build(values.length, 300, height-yoff);
						}
					},0,yoff, Align.TOPRIGHT
				),
				// roomgroups
				new Transform(
					new ListViewBuilder() {
						Widget i(int i) {
							if(i==0) {
								return new EventDetector(new Container(new Text(lg.get("addrg")))) {
									void onEvent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											drawPopup(5);
										}
									}
								};
							} else {
								color rgc = rm.roomgrid.roomgroups.get(i-1).c;
								String cstring = int(red(rgc)) + " " + int(green(rgc)) + " " + int(blue(rgc));

								return new ListView(
									new Widget[] {
										new Container(new SetValueText(rm.roomgrid.roomgroups.get(i-1).name, cstring) {
											void onchange() {
												String[] strings = split(newvalue, " ");
												int[] ints = new int[strings.length];
												boolean a = true;
												for (int i=0; i<strings.length;i++) {
													if(strings[i].length() == 0) {
														a = false;
													}
													int newint = int(strings[i]);
													if(newint > 255 || newint < 0) {
														a = false;
													}
													ints[i] = newint;
												}
												if(a && ints.length == 3) {
													color col = color(ints[0], ints[1], ints[2]);
													value = ints[0]+" "+ints[1]+" "+ints[2];
													rm.roomgrid.roomgroups.get(i-1).c = col;
												}
											}
										},200,30),
										// select roomgroup
										new EventDetector(new Container(new Text("S"),70,30, (rm.newroomgroup == (i-1)) ? color(c[3]) : color(c[5]))) {
											void onEvent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													rm.newroomgroup = i-1;
													ov.build();
												}
											}
										},
										// delete roomgroup
										new EventDetector(new Container(new Image(dm.icons[8]),30,30)) {
											void onEvent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													if(rm.roomgrid.roomgroups.size() > 1) {
														if(rm.roomgrid.isRoomGroupinuse(i-1)) {
															tempdata = i-1;
															drawPopup(4);
														} else {
															rm.roomgrid.removeRoomGroup(i-1);
															rm.newroomgroup = constrain(rm.newroomgroup, 0, rm.roomgrid.roomgroups.size()-1);
															ov.build();
														}
													} else {
														toovmessages.add(lg.get("crlrg"));
													}
												}
											}
										},
									},300,30,Dir.RIGHT
								);
							}
						}
					}.build(rm.roomgrid.roomgroups.size()+1, 300, height-yoff),0,yoff, Align.TOPRIGHT
				),
				// price
				new Transform(
					new Dynamic() {
						Widget getWidget() {
							PriceReport pr = rm.getPriceReport();
							int total = 0;
							Widget[] o = new Widget[pr.furnitureids.length+1];
							for (int i=0;i<o.length;i++) {
								if(i != o.length-1) {
									FurnitureData fd = dm.getFurnitureData(pr.furnitureids[i]);
									total += fd.price * pr.furniturecounts[i];
									o[i] = new Text(pr.furniturecounts[i]+" * "+fd.name+"("+fd.price+")"+": "+fd.price*pr.furniturecounts[i], LEFT);
								} else {
									o[i] = new Text(lg.get("total") + ": " + total, LEFT);
								}
							}

							return new ListView(
								o,300, height-yoff
							);
						}
					},0,yoff, Align.TOPRIGHT
				),
				// furniture list
				new Transform(
					new ListView(
						new Widget[] {
							new GridView(
								new Builder() {
									Widget i(int i) {
										return new EventDetector(
											new Container(
												new ListView(
													new Widget[] {
														new Image(dm.furnitures[i].image, 175, round(175*0.75), Fit.RATIO, rm.furnituretint),
														new Text(dm.furnitures[i].name),
													}
												)
											)
										) {
											void onEvent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													rm.newfurnitureid = i;
													rm.isprefab = false;
													rm.tool = 2;
												}
											}
										};
									}
								}.build(dm.furnitures.length),350, height-yoff-60,2
							),
							new EventDetector(new Container(new Text(lg.get("selectcolor")), 350, 30)) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										drawPopup(6);
									}
								}
							},
							new EventDetector(new Container(new Text(lg.get("prefablist")), 350, 30)) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										tabid = 7;
									}
								}
							},
						},350, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// prefab list
				new Transform(
					new ListView(
						new Widget[] {
							new GridView(
								new Builder() {
									Widget i(int i) {
										return new EventDetector(new Container(
												new ListView(
													new Widget[] {
														new Image(dm.prefabs[i].getImage(), 175, round(175*0.75), Fit.RATIO, rm.furnituretint),
														new Text(dm.prefabs[i].name),
													}
												)
											)
										) {
											void onEvent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													rm.newfurnitureid = i;
													rm.isprefab = true;
													rm.tool = 2;
												}
											}
										};
									}
								}.build(dm.prefabs.length),350, height-yoff-30,2
							),
							new EventDetector(new Container(new Text(lg.get("furnlist")), 350, 30)) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										tabid = 6;
									}
								}
							},
						},350, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
			}
			) {
			void onTab(int i) {
				if(-1 < i && i < ov.tabs.length) {
					TabData td = ov.tabs[i];
					if(td.type) {
						drawPopup(td.id);
					} else {
						if(td.id == -1) {
							rm.switchViewmode();
							if(rm.viewmode) {
								tabid = -1;
							}
						} else {
							if(tabid == td.id) {
								tabid = -1;
							} else {
								tabid = td.id;
							}
						}
					}
				}
			}
			int getIndex() {
				return tabid;
			}
		};
	}

	Widget createToolBar() {
		return new Visible(
			new Transform(
				new ListViewBuilder() {
					Widget i(int i) {
						if (i < 6) {
							return new EventDetector(new Container(new Image(dm.icons[i+1]))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										rm.tool = i;
										if(rm.tool == 2) {
											tabid = (tabid == 6) ? -1 : 6;
										}
									}
								}
							};
						} else {
							if(i == 6) {
								return new SizedBox(true);
							} else {
								return new EventDetector(new Container(new Image(dm.icons[7]))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										drawconsole = !drawconsole;
									}
								}
							};
							}
						}
					}
				}.build(8, xoff, height-yoff, xoff, Dir.DOWN), 0,yoff
			)
		) {boolean isVisible() {return !rm.viewmode;}};
	}

	Widget createMessageBox() {
		return new Visible(
			new Transform(
				new Dynamic() {
					Widget getWidget() {
						Widget o = new EventDetector(
							new ListViewBuilder() {
								Widget i(int i) {
									return new Text(messages.get(i), LEFT);
								}
							}.build(messages.size(),width-xoff,messageboxheight, 30, Dir.DOWN)
						) {
							void onEvent(EventType et, MouseEvent e) {
								if(et == EventType.MOUSEWHEEL) {
									int length = messages.size()*30;
									if(length > messageboxheight) {
										consoleoff -= e.getCount()*15;
										consoleoff = constrain(consoleoff, messageboxheight - length, 0);
									}
								}
							}
						};
						((ListView)(((EventDetector)o).child)).off = consoleoff;
						return o;
					}
				},xoff, height-messageboxheight
			)
		) {boolean isVisible() {return drawconsole && !rm.viewmode;}};
	}

	void checkMessages() { // print out all messages in the to overlay messages variable
		if(toovmessages.size() > 0) {
			for (int i=0;i<toovmessages.size();i++) {
				printMessage(toovmessages.get(i));
				println(toovmessages.get(i));
			}
			toovmessages.clear();
		}
	}
	void printMessage(String text) { // add a message to the console
		messages.add(fixLength(str(hour()), 2, '0') + ":" + fixLength(str(minute()), 2, '0') + ":" + fixLength(str(second()), 2, '0') + ": " + text);
		if(messages.size() > messageboxheight/30) {
			consoleoff -= 30;
		}
		drawconsole = true;
	}

	void drawPopup(int id) { // opens a Popup
		switch(id) {
			case 0: // requires restart
				items[0] =
				new Popup(
					new ListView(
						new Widget[] {
							new SizedBox(true),
							new Text(lg.get("ratste"), CENTER, 3),
							new SizedBox(true),
							new EventDetector(new Container(new Text(lg.get("ok")))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
								}
							},
						}, width/4, height/4
					)) {
					void ontrue() {drawpopup = false;}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 1: // new Room
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("newroom")),
						new SizedBox(true),
						new Container(
							new Slider(lg.get("newwidth"), (float)newroomxsize/100)
							{
								void onchange(float newvalue) {
									value = constrain(newvalue, 0.01, 1);
									int v = constrain(int(value*100), 1,100);
									newroomxsize = v;
								}
								String gettext() {
									return str(constrain(round(value*100), 1, 100));
								}
							}
						),
						new Container(
							new Slider(lg.get("newheight"), (float)newroomysize/100)
							{
							void onchange(float newvalue) {
								value = constrain(newvalue, 0.01, 1);
								int v = constrain(int(value*100), 1,100);
								newroomysize = v;
							}
							String gettext() { return str(constrain(round(value*100), 1, 100)); }
							}
						),
					},
					lg.get("ok"),
					lg.get("cancel"))
				{
					void ontrue() {drawpopup = false;rm.newRoom(newroomxsize, newroomysize);}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 2: // about
				items[0] =
				new Popup(
					new ListView(
						new Widget[] {
							new Text(getAbout(), CENTER, 4),
							new SizedBox(true),
							new EventDetector(new Container(new Text("Github"))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {link(githublink);}
								}
							},
							new EventDetector(new Container(new Text(lg.get("ok")))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
								}
							},
						}, width/4, height/4
					)) {
					void ontrue() {drawpopup = false;}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 3: // reset
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("areyousure")),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					void ontrue() {drawpopup = false;rm.reset();}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 4: // remove room group
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("areyousure")),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					void ontrue() {
						drawpopup = false;
						rm.roomgrid.removeRoomGroup((int)tempdata);
						rm.newroomgroup = constrain(rm.newroomgroup, 0, rm.roomgrid.roomgroups.size()-1);
						ov.build();
					}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 5: // new room group
				tempdata = "";
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("name") + "?"),
						new SizedBox(true),
						new Container(
							new SetValueText(lg.get("name"))
							{
								void onchange() {
									value = newvalue;
									tempdata = value;
								}
							}
							),
					},lg.get("ok"), lg.get("cancel"))
				{
					void ontrue() {
						if(tempdata != "") {
							rm.roomgrid.addRoomGroup((String)tempdata, color(50,50,50));
							ov.build();
							drawpopup = false;
						}
					}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 6: // select color
				items[0] =
				new Popup(
					new Widget[] {
					new SizedBox(true),
					new Text(lg.get("selectcolor")),
					new SizedBox(true),

					new Container(new Slider(lg.get("red"), red(rm.furnituretint)/255) {
									void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(v, green(rm.furnituretint), blue(rm.furnituretint));
									}
									String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					new Container(new Slider(lg.get("green"), green(rm.furnituretint)/255) {
									void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), v, blue(rm.furnituretint));
									}
									String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					new Container(new Slider(lg.get("blue"), blue(rm.furnituretint)/255) {
									void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), green(rm.furnituretint), v);
									}
									String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					},lg.get("ok"), lg.get("cancel")) {
					void ontrue() {drawpopup = false;build();}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 7: // activate cgol
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("activatecgol")),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					void ontrue() {drawpopup = false;allowcgol = true;rm.furnitures = new ArrayList<Furniture>();}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break; 
			case 8: // overwrite default room?
				items[0] =
				new Popup(
					new Widget[] {
						new SizedBox(true),
						new Text(lg.get("overwritedefaultroom")),
						new SizedBox(true),
					},lg.get("yes"), lg.get("no")) {
					void ontrue() {drawpopup = false;rm.save(rm.name);ov.build();}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
			case 9: // requires opengl render
				items[0] =
				new Popup(
					new ListView(
						new Widget[] {
							new SizedBox(true),
							new Text(lg.get("roglr"),CENTER,3),
							new SizedBox(true),
							new EventDetector(new Container(new Text(lg.get("ok")))) {
								void onEvent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
								}
							},
						}, width/4, height/4
					)) {
					void ontrue() {drawpopup = false;}
					void onfalse() {drawpopup = false;}
					boolean isVisible() {return drawpopup;}
				};
			break;
		}
		drawpopup = true;
	}

	int getXOff() {
		if(visible) {
			return xoff;
		}
		return 0;
	}

	int getYOff() {
		if(visible) {
			return yoff;
		}
		return 0;
	}
}
