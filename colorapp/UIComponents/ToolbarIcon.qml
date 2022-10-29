import QtQuick 2.8
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Rectangle {
	property var ticon: ""
	property var col: ""

	width: height
	height: parent.height

	color: "transparent"

	Icon {
		id: tbIcon
		width: height
		height: parent.height * 2 / 3

		anchors.centerIn: parent

		name: ticon
		icol: col
	}

	MouseArea {
		anchors.fill: tbIcon

		cursorShape: Qt.PointingHandCursor

		onClicked: {
			pushAction()
		}
	}
}
