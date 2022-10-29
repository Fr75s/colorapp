import QtQuick 2.8
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Rectangle {
	property var iname: ""
	property var col: ""

	property bool wideBG: false
	property bool toggled: false

	Layout.fillWidth: true
	height: parent.height

	color: "transparent"

	Rectangle {

		width: wideBG ? parent.width - 8 : height
		height: parent.height - 8

		anchors.centerIn: parent
		radius: height / 4

		color: (mouseDetect.containsMouse || toggled ? opacityColor(colors["text"], 0.15) : "#00000000")
	}

	Icon {
		width: height
		height: parent.height * 2 / 3
		anchors.centerIn: parent

		name: iname
		icol: col
	}

	MouseArea {
		id: mouseDetect
		width: wideBG ? parent.width : height
		height: parent.height

		hoverEnabled: true

		anchors.centerIn: parent

		cursorShape: Qt.PointingHandCursor

		onClicked: {
			pushAction()
		}
	}
}
