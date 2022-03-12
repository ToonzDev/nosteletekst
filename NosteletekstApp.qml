import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: nosteletekstApp

	property url fullScreenUrl : "NosteletekstScreen.qml"
	property url trayUrl : "NosteletekstTray.qml";
	property NosteletekstScreen nosteletekstScreen

		// Nos Teletekst data in strings of 1000 charaters (40 characters at 25 rows)
	property string teletekstPage		//character to display
	property string teletekstColor		//character color array
	property string teletekstBgColor	//background color array

		//default colors	
	property variant color : ["#111111", "#00FF00", "#FF0000", "#FFFF00", "#00FFFF", "#FFFFFF", "#000000", "#0000FF"]

		//current page dispayed
	property int actualPage : 101
	property int actualSubPage : 1

		//links to others pages (4 coloured buttons at the bottom of the page)
	property string pageGreen
	property string pageYellow
	property string pageRed
	property string pageCyan

		//favorite pages (need a config screen to allow the user to set the defaults, for now hardcoded)
	property string favourite1 : "101"
	property string favourite2 : "401"
	property string favourite3 : "601"
	property string favourite4 : "818"
	property string favourite5 : "704"
	property string favourite6 : "819"
	property string favourite7 : "730"
	property string favourite8 : "555"

		// signal to NosteletekstScreen.qml to update the display
    	signal pageUpdated()

	FileIO {
		id: nosteletekstSettingsFile
		source: "file:///mnt/data/tsc/nosteletekst.userSettings.json"
 	}

		// Init the nosteletekst app by registering the widgets
	function init() {
		registry.registerWidget("screen", fullScreenUrl, this, "nosteletekstScreen");
		registry.registerWidget("systrayIcon", trayUrl, this, "nosteletekstTray");
	}

	function saveSettings() {

		// save user settings
		
 		var tmpUserSettingsJson = {
			"pagina": actualPage,
			"subpagina": actualSubPage
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/nosteletekst.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJson ));
	}

	function addColors(colorCode, number) {  //return a string with the requested length with the actual color code)
		var outputStr = ""
		for (var z=0;z<number;z++) outputStr = outputStr + colorCode
		return outputStr
	}

	// decode html colorcodes to internal colorcodes, bg-.... are background color codes
	function colorCode(colortxt) {
		switch (colortxt) {
			case "green": return "1";
			case "red": return "2";
			case "yellow": return "3";
			case "cyan": return "4";
			case "white": return "5";
			case "black": return "6";
			case "blue": return "7";
			case "bg-green": return "1";
			case "bg-red": return "2";
			case "bg-yellow": return "3";
			case "bg-cyan": return "4";
			case "bg-white": return "5";
			case "bg-black": return "6";
			case "bg-blue": return "7";
			default: break;
		}
		return "0"
	}

	// main logic to decode the html teletekst page into the three strings of 1000 characters

	function readTeletekstPage() {

		teletekstPage = ""; 	// clear buffer for tekst
		teletekstColor = ""; 	// clear buffer for tekst color
		teletekstBgColor = ""; 	// clear buffer for tekst background color
	
		var xmlhttp = new XMLHttpRequest()
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					var htmlText = xmlhttp.responseText;
					htmlText = htmlText.replace(/\r?\n|\r/g, "~~");  // replace end of line character with items which can be easily searched

						// clear single lines	
					var line = "";
					var colorline = "";
					var colorBgline = "";
					var colorCommands = [];  // array used to get all colors in a single html tag

						//default colors
					var currentColor = "5";
					var currentBgColor = "6";
					var newColor = "5";
					var newBgColor = "6";

						// find start and end of page contents
					var i = htmlText.indexOf('<pre id="content">') + 17;  //start of page data
					var z = htmlText.indexOf('</pre');  		//end of page data location
						// counters to scroll through the lines
					var l = i;
					var m = i;

						// determine end of current line input, j is the current end-of-line position in the html source
					var j = htmlText.indexOf('~~', i);

						//bunch of meaningless short lived counters
					var k = 0;
					var n = 0;
					var o = 0;
					var p = 0;
					var q = 0;

					while (j> 0 && j < z) {	// while not reached end of page

							//init line
						line = "";
						colorline = "";
						colorBgline = "";
						currentColor = "5";
						currentBgColor = "6";

						k = htmlText.indexOf('<', l)	//search first html tag

						if (k>j) {	// if first html tag is on the next line, copy rest of data to current line strings
							line = line + htmlText.substring(l+1,j)
							colorline = colorline + addColors(currentColor, j - l - 1)
							colorBgline = colorBgline + addColors(currentBgColor, j - l - 1)
						} else {

							while (k < j) { // get all tekst till end of line

                                            			//htl tag was found, determine type of tag
								if (htmlText.substring(k+2, k+5) == "spa") { // "</span", reset colors to defaults>
									newColor = "5";
									newBgColor = "6";
								}
                                            			
								if (htmlText.substring(k+1, k+2) == "a") { // hyperlink to other pages
									p = htmlText.indexOf('href', k); 
									q = htmlText.indexOf('"', p+6); // linked page number of hyperlink
									switch (currentColor) { // fill the 4 colored buttons references (last 4 colored links on the page will remain)
										case "1" : {pageGreen = htmlText.substring(q-3, q); break;}
										case "2" : {pageRed = htmlText.substring(q-3, q); break;}
										case "3" : {pageYellow = htmlText.substring(q-3, q); break;}
										case "4" : {pageCyan = htmlText.substring(q-3, q); break;}
										default: break;
									}
								}
					
								if (htmlText.substring(k+1, k+11) == "span class") {  //next string color data

									p = htmlText.indexOf('"', k+13);
									colorCommands = htmlText.substring(k+13, p).split(" ");  //split color and background color if combined
									for (i=0; i < colorCommands.length; i++) {
										if (colorCommands[i].substring(0,2) === "bg") {
											newBgColor = colorCode(colorCommands[i]);
										} else {
											newColor = colorCode(colorCommands[i]);
										}
									}
								}
									// copy page tekst substring with the actual colors
								line = line + htmlText.substring(l+1,k);
								colorline = colorline + addColors(currentColor, k - l - 1)
								colorBgline = colorBgline + addColors(currentBgColor, k - l - 1)
								l = htmlText.indexOf('>', k);  //find end of html tag

									// set colors for next substring
								currentColor = newColor;
								currentBgColor = newBgColor;

									// find next html tag

								k = htmlText.indexOf('<', l);  //when next tag is after the current line, saved remainder of the text and move to next line
								if (k > j) {
									line = line + htmlText.substring(l+1,j);
									colorline = colorline + addColors(currentColor, j - l - 1)
									colorBgline = colorBgline + addColors(currentBgColor, j - l - 1)
									currentColor = "5";
									currentBgColor = "6";
								}
							}
						}

							// line processed, now remove all special characters from the three strings
						n = line.indexOf('&');
						while (n>0) {
							o = line.indexOf(';', n)
							line = line.substring(0, n) + line.substring(o+1, line.length);
							colorline = colorline.substring(0, n) + colorline.substring(o+1, colorline.length);
							colorBgline = colorBgline.substring(0, n) + colorBgline.substring(o+1, colorBgline.length);
							n = line.indexOf('&', o-6);
						}
							//add lines to the page data, lines length is always 40 characters
						teletekstPage = teletekstPage + line;
						teletekstColor = teletekstColor + colorline;
						teletekstBgColor = teletekstBgColor + colorBgline;

							// find next end of line and restart loop
						l = j + 1;
						j = htmlText.indexOf('~~', j + 2);

					}

						//signal screen that data has been loaded and display it
					pageUpdated();
				}
			}
		}

		xmlhttp.open("GET", "https://teletekst-data.nos.nl/webtekst?p=" + actualPage + "-" + actualSubPage, true);
		xmlhttp.send();

	}

	Component.onCompleted: {

			// read saved filter and start timer

		try {
			var nosteletekstSettingsJson = JSON.parse(nosteletekstSettingsFile.read());
			if (nosteletekstSettingsJson['pagina']) actualPage = nosteletekstSettingsJson['pagina'];
			if (nosteletekstSettingsJson['subpagina']) actualSubPage = nosteletekstSettingsJson['subpagina'];
		} catch(e) {
		}
		readTeletekstPage(actualPage, actualSubPage);
	}
}
