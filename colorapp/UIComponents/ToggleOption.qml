import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Item {
	width: parent.width
	height: optionHeight

	property string label: ""
	property string option: ""
	property bool checked: false

	Rectangle {
		anchors.fill: parent
		radius: height / 4

		color: action.containsMouse ? opacityColor(colors["text"], 0.15) : "transparent"
	}

	Rectangle {
		id: toggler

		width: height
		height: parent.height * 0.8

		anchors.right: parent.right
		anchors.top: parent.top

		anchors.rightMargin: parent.height * 0.1
		anchors.topMargin: parent.height * 0.1

		radius: height / 4
		color: colors["tool"]

		Icon {
			id: toggleIcon
			width: height
			height: parent.height * 0.8
			anchors.centerIn: parent

			name: "checkbox"
			icol: colors["text"]
			visible: checked
		}
	}

	Text {
		width: parent.width - parent.height - (parent.height - toggler.height) / 2
		height: parent.height

		anchors.left: parent.left
		anchors.leftMargin: (parent.height - toggler.height) / 2
		anchors.top: parent.top

		verticalAlignment: Text.AlignVCenter

		text: label
		color: colors["text"]
		font.family: outfit.name
		font.pixelSize: height / 3
	}

	MouseArea {
		id: action
		anchors.fill: parent
		hoverEnabled: true

		cursorShape: Qt.PointingHandCursor

		onClicked: {
			toggleIcon.visible = !toggleIcon.visible
			root.toggleOption(option)
		}
	}
}
