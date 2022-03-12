import QtQuick 2.1
import BasicUIControls 1.0;
import qb.components 1.0

Screen {
	id: fileinfoFilterScreen

	screenTitle: (app.actualSubPage > "1") ? qsTr("NOS Teletekst - pagina " + app.actualPage + "-" + app.actualSubPage) : qsTr("NOS Teletekst - pagina " + app.actualPage) 

	property bool loading : false

	Component.onCompleted: {   //get signal when page is loaded
		app.pageUpdated.connect(updateScreen);
	}

	function updateScreen() { //triggered by app signal
		teletekstModel.clear()
		for (var i = 0; i < 1000; i++) {
			teletekstModel.append({ch: app.teletekstPage.substring(i, i+1), co: app.color[parseInt(app.teletekstColor.substring(i, i+1))], bg: app.color[parseInt(app.teletekstBgColor.substring(i, i+1))]});
		}
		loading = false;
	}
			
	Text {
		id:pageLabel
		anchors {
			left: isNxt ? 20 : 16
			top: parent.top
			topMargin: isNxt ? 30 : 24
		}
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		text: "   Pagina: "
	}
			
	Text {
		id:pageLabelInput
		anchors {
			left: pageLabel.right
			leftMargin: isNxt ? 20 : 16
			top: pageLabel.top
		}
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		text: "100"
	}

	StandardButton {
		id: getPage
		width: isNxt ? 60 : 48
		text: "GO"
		anchors {
			top: pageLabel.top
			topMargin: isNxt ? -10 : -8
			left: pageLabel.right
			leftMargin: isNxt ? 100 : 80
		}
		onClicked: {
			loading = true;
               		app.actualPage = parseInt(pageLabelInput.text)
			app.actualSubPage = "1";
			app.readTeletekstPage();
       		 }
		visible: !loading
	}

	StandardButton {
		id: pagL
		width: isNxt ? 45 : 36
		text: "<<"
		anchors {
			top: pageLabel.bottom
			left: pageLabel.left
			topMargin: isNxt ? 35 : 28
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
			loading = true;
               		app.actualPage = parseInt(app.actualPage) - 1
			app.actualSubPage = "1";
			app.readTeletekstPage();
       		 }
		visible: !loading
	}

	StandardButton {
		id: subpagL
		width: isNxt ? 45 : 36
		text: "<"
		anchors {
			top: pageLabel.bottom
			left: pagL.right
			topMargin: isNxt ? 35 : 28
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
			loading = true;
               		if (app.actualSubPage > "1") {
				app.actualSubPage = parseInt(app.actualSubPage) - 1
			}
			app.actualSubPage = "1";
			app.readTeletekstPage();
       		 }
		visible: !loading && (app.actualSubPage > "1")
	}

	StandardButton {
		id: subpagR
		width: isNxt ? 45 : 36
		text: ">"
		anchors {
			top: pageLabel.bottom
			left: subpagL.right
			topMargin: isNxt ? 35 : 28
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
			loading = true;
			app.actualSubPage = parseInt(app.actualSubPage) + 1
			app.readTeletekstPage();
       		 }
		visible: !loading
	}

	StandardButton {
		id: pagR
		width: isNxt ? 45 : 36
		text: ">>"
		anchors {
			top: pageLabel.bottom
			left: subpagR.right
			topMargin: isNxt ? 35 : 28
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
			loading = true;
               		app.actualPage = parseInt(app.actualPage) + 1
			app.actualSubPage = "1";
			app.readTeletekstPage();

       		 }
		visible: !loading
	}

	Throbber {
		id: throbber
		width: Math.round(80 * horizontalScaling)
		height: Math.round(80 * verticalScaling)

		smallRadius: 3
		mediumRadius: 4
		largeRadius: 5
		bigRadius: 6

		anchors {
			horizontalCenter: pageLabel.horizontalCenter
			top: pageLabel. bottom
		}
		visible: loading
	}

	StandardButton {
		id: key1
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "1"
		anchors {
			top: pagL.bottom
			left: pagL.left
			topMargin: isNxt ? 25 : 20
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "1";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key4
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "4"
		anchors {
			top: key1.bottom
			left: key1.left
			topMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "4";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key7
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "7"
		anchors {
			top: key4.bottom
			left: key1.left
			topMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "7";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key2
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "2"
		anchors {
			top: key1.top
			left: key1.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "2";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key5
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "5"
		anchors {
			top: key4.top
			left: key4.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "5";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key8
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "8"
		anchors {
			top: key7.top
			left: key7.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "8";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key3
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "3"
		anchors {
			top: key1.top
			left: key2.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "3";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key6
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "6"
		anchors {
			top: key4.top
			left: key5.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "6";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}

	StandardButton {
		id: key9
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "9"
		anchors {
			top: key7.top
			left: key8.right
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "9";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
		}
	}
       	
	StandardButton {
		id: key0
		width: isNxt ? 75 : 60
		height: isNxt ? 75 : 60
		text: "0"
		anchors {
			top: key7.bottom
			left: key7.right
			topMargin: isNxt ? 10 : 8
			leftMargin: isNxt ? 10 : 8
		}
		onClicked: {
			pageLabelInput.text = pageLabelInput.text + "0";
			if (pageLabelInput.text.length > 3) pageLabelInput.text = pageLabelInput.text.substring(1,4);
       		 }
	}
			
	Text {
		id:favText
		anchors {
			top:  textData.top
			left:  textData.right
			leftMargin: isNxt ? 25 : 20
		}
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		text: "Favorieten:"
	}

	StandardButton {
		id: fav1
		width: isNxt ? 75 : 60
		text: app.favourite1
		anchors {
			top: favText.bottom
			left: favText.left
			topMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite1;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav2
		width: isNxt ? 75 : 60
		text: app.favourite2
		anchors {
			top: fav1.bottom
			left: favText.left
			topMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite2;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav3
		width: isNxt ? 75 : 60
		text: app.favourite3
		anchors {
			top: fav2.bottom
			left: favText.left
			topMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite3;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav4
		width: isNxt ? 75 : 60
		text: app.favourite4
		anchors {
			top: fav3.bottom
			left: favText.left
			topMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite4;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav5
		width: isNxt ? 75 : 60
		text: app.favourite5
		anchors {
			top: fav1.top
			left: fav1.right
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite5;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav6
		width: isNxt ? 75 : 60
		text: app.favourite6
		anchors {
			top: fav2.top
			left: fav2.right
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite6;
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav7
		width: isNxt ? 75 : 60
		text: app.favourite7
		anchors {
			top: fav3.top
			left: fav3.right
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite7
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	StandardButton {
		id: fav8
		width: isNxt ? 75 : 60
		text: app.favourite8
		anchors {
			top: fav4.top
			left: fav4.right
			leftMargin: isNxt ? 15 : 12
		}
		onClicked: {
               		app.actualPage = app.favourite8
			app.actualSubPage = "1";
			loading = true;
			app.readTeletekstPage();
       		 }
		visible: (!loading)
	}

	Rectangle {
		id: textData
		height: isNxt ? 500 : 400  // 25 (rows) x charater height 
		width: isNxt ? 400 : 320   // 40 (charaters per row) x charater width
		anchors { horizontalCenter: parent.horizontalCenter }

		GridView {
			anchors.fill: parent
			cellWidth: isNxt ? 10 : 8
			cellHeight: isNxt ? 20 : 16

			model: teletekstModel
			delegate: pageDelegate
		}
	}


	ListModel {  				// contains teletekst page contents 40 columns x 25 rows
		id: teletekstModel
	}

	Component {
		id: pageDelegate		// a single character on the page, plus text color and background color

		Item {
			width: isNxt ? 10 : 8
			height: isNxt ? 20 : 16
            
			Rectangle {
   	            		width: isNxt ? 10 : 8 
		               	height: isNxt ? 20 : 16
				color: bg
	           	 }

			Text {
				anchors { horizontalCenter: parent.horizontalCenter }
				font.family: qfont.semiBold.name
				font.pixelSize: isNxt ? 16 : 12
				text: ch
				color: co
			}
		}
	}

	Rectangle {				// the four colored buttons at the bottom
		id: buttonRed
		height: isNxt ? 75 : 60
		width: isNxt ? 100 : 80
		anchors {
			top: textData.bottom
			topMargin: isNxt ? 5 : 4
			left: textData.left
		}
		color: "#FF0000" // red
		Text {
			text:  app.pageRed
			anchors { horizontalCenter: parent.horizontalCenter }
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: "#FFFFFF"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: { 
				loading = true;
				app.actualPage = app.pageRed;
				app.actualSubPage = "1"
				app.readTeletekstPage();
			}
		}
		visible: !loading
	}

	Rectangle {
		id: buttonGreen
		height: isNxt ? 75 : 60
		width: isNxt ? 100 : 80
		anchors {
			top: textData.bottom
			topMargin: isNxt ? 5 : 4
			left: buttonRed.right
		}
		color: "#00FF00" // green
		Text {
			text:  app.pageGreen
			anchors { horizontalCenter: parent.horizontalCenter }
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
		}
		MouseArea {
			anchors.fill: parent
			onClicked: { 
				loading = true;
				app.actualPage = app.pageGreen;
				app.actualSubPage = "1"
				app.readTeletekstPage();
			}
		}
		visible: !loading
	}

	Rectangle {
		id: buttonYellow
		height: isNxt ? 75 : 60
		width: isNxt ? 100 : 80
		anchors {
			top: textData.bottom
			topMargin: isNxt ? 5 : 4
			left: buttonGreen.right
		}
		color: "#FFFF00" // red
		Text {
			text:  app.pageYellow
			anchors { horizontalCenter: parent.horizontalCenter }
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
		}
		MouseArea {
			anchors.fill: parent
			onClicked: { 
				loading = true;
				app.actualPage = app.pageYellow;
				app.actualSubPage = "1"
				app.readTeletekstPage();
			}
		}
		visible: !loading
	}

	Rectangle {
		id: buttonCyan
		height: isNxt ? 75 : 60
		width: isNxt ? 100 : 80
		anchors {
			top: textData.bottom
			topMargin: isNxt ? 5 : 4
			left: buttonYellow.right
		}
		color: "#0000FF" // blue
		Text {
			text:  app.pageCyan
			anchors { horizontalCenter: parent.horizontalCenter }
			font {
				family: qfont.bold.name
				pixelSize: isNxt ? 18 : 15
			}
			color: "#FFFFFF"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: { 
				loading = true;
				app.actualPage = app.pageCyan;
				app.actualSubPage = "1"
				app.readTeletekstPage();
			}
		}
		visible: !loading
	}
}
