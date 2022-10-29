import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3


Rectangle {
	id: customDialog

	signal accepted()
	signal rejected()
	signal cancelled()

	width: root.width
	height: root.height
	visible: false

	color: "#44000000"

	property var title: ""
	property var info: ""

	property var buttons: []

	Rectangle {
		id: dialogBox
		width: parent.width * 0.5
		height: parent.height * 0.5

		color: colors["tool"]
		radius: 8

		anchors.centerIn: parent

		Text {
			id: titleText
			width: parent.width
			height: 36

			anchors.top: parent.top
			anchors.topMargin: customDialogSpacing

			text: title
			color: colors["text"]

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.family: outfit.name
			font.pixelSize: height
		}

		Text {
			id: infoText
			width: parent.width
			height: font.pixelSize * 3

			anchors.top: titleText.bottom
			anchors.topMargin: customDialogSpacing

			text: info
			color: colors["text"]

			wrapMode: Text.WordWrap

			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.family: outfit.name
			font.pixelSize: 18
		}
	}

	Rectangle {
		anchors.fill: buttonsRow
		color: colors["side"]

		radius: dialogBox.radius
	}

	RowLayout {
		id: buttonsRow

		width: dialogBox.width
		height: 72

		anchors.left: dialogBox.left
		anchors.bottom: dialogBox.bottom

		spacing: 0

		EvenIcon {
			id: yesButton
			wideBG: true
			visible: buttons.includes("yes")

			iname: "dialog-ok"
			col: colors["text"]

			function pushAction() { customDialog.accepted(); customDialog.close() }
		}

		EvenIcon {
			id: noButton
			wideBG: true
			visible: buttons.includes("no")

			iname: "dialog-close"
			col: colors["text"]

			function pushAction() { customDialog.rejected(); customDialog.close() }
		}

		EvenIcon {
			id: cancelButton
			wideBG: true
			visible: buttons.includes("cancel")

			iname: "dialog-cancel"
			col: colors["text"]

			function pushAction() { customDialog.cancelled(); customDialog.close() }
		}
	}

	MouseArea {
		anchors.fill: parent
		z: buttonsRow.z - 1
	}


	function open() {
		visible = true
	}

	function close() {
		visible = false
	}
}
