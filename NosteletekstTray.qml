import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: teletekstSystrayIcon
	visible: true
	posIndex: 9001
	property string objectName: "teletekstSystray"

	onClicked: {
		if (app.nosteletekstScreen) app.nosteletekstScreen.show();
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "qrc:/tsc/newsreaderTray.png"
	}
}
