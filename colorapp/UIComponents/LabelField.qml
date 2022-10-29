import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

Item {
	property var label: ""
	property var textIcon: ""
	property var restrictTo: ""
	property var matchCase: ""
	property int matchInt: 0

	property var restrictRange: []

	property var content: ""
	property var triContent: ["", "", ""]

	property bool triple: false

	width: parent.width
	height: triple ? labelFieldHeight * 3 + labelFieldSpacing * 2 : labelFieldHeight

	Text {
		width: parent.width * 0.25
		height: labelFieldABG.height
		anchors.left: parent.left
		anchors.leftMargin: parent.width * 0.025

		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		text: label
		font.family: outfit.name
		font.pixelSize: 24
		color: colors["text"]
	}

	Rectangle {
		id: labelFieldABG
		width: parent.width * 0.7
		height: labelFieldHeight

		anchors.right: parent.right
		anchors.top: parent.top

		color: colors["side"]

		radius: height / 4

		Text {
			id: labelFieldAIcon
			width: (textIcon != "" ? height : 0)
			height: labelFieldABG.height

			anchors.left: parent.left
			anchors.leftMargin: parent.width * 0.1

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			text: textIcon
			font.family: outfit.name
			font.pixelSize: 24
			color: opacityColor(colors["text"], 0.2)
		}

		TextInput {
			id: labelFieldA
			width: parent.width * 0.8 - labelFieldAIcon.contentWidth - 2
			height: parent.height

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.1

			color: colors["text"]
			font.family: outfit.name
			font.pixelSize: 24

			inputMask: restrictTo
			selectByMouse: true

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			onTextEdited: {
				content = text
				triContent[0] = text

				if (matchCase == "hex") {
					if (text.match("[^A-Fa-f0-9]"))
						undo()
				}

				if (matchInt != 0 || restrictRange.length == 2) {
					if (text.match("[^0-9]")) {
						undo()
					}
				}

				if (restrictRange.length == 2) {
					if (parseInt(text) > restrictRange[1]) {
						text = restrictRange[1].toString()
						content = text
						triContent[0] = text
					}
					if (parseInt(text) < restrictRange[0]) {
						text = restrictRange[0].toString()
						content = text
						triContent[0] = text
					}
				}

				if (matchCase != "")
					checkIfMatch(text)
				if (matchInt != 0)
					checkIfMatchInt()
			}
		}
	}

	Rectangle {
		id: labelFieldBBG
		width: parent.width * 0.7
		height: labelFieldHeight

		anchors.right: parent.right
		anchors.top: labelFieldABG.bottom
		anchors.topMargin: labelFieldSpacing

		color: colors["side"]

		radius: height / 4

		Text {
			id: labelFieldBIcon
			width: (textIcon != "" ? height : 0)
			height: labelFieldBBG.height

			anchors.left: parent.left
			anchors.leftMargin: parent.width * 0.1

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			text: textIcon
			font.family: outfit.name
			font.pixelSize: 24
			color: opacityColor(colors["text"], 0.2)
		}

		TextInput {
			id: labelFieldB
			width: parent.width * 0.8 - labelFieldBIcon.contentWidth - 2
			height: parent.height

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.1

			color: colors["text"]
			font.family: outfit.name
			font.pixelSize: 24

			inputMask: restrictTo
			selectByMouse: true

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			onTextEdited: {
				triContent[1] = text

				if (matchInt != 0 || restrictRange.length == 2) {
					if (text.match("[^0-9]")) {
						labelFieldB.undo()
					}
				}

				if (restrictRange.length == 2) {
					if (parseInt(text) > restrictRange[1]) {
						text = restrictRange[1].toString()
						triContent[1] = text
					}
					if (parseInt(text) < restrictRange[0]) {
						text = restrictRange[0].toString()
						triContent[1] = text
					}
				}

				if (matchCase != "")
					checkIfMatch(text)
				if (matchInt != 0)
					checkIfMatchInt()
			}
		}
	}

	Rectangle {
		id: labelFieldCBG
		width: parent.width * 0.7
		height: labelFieldHeight

		anchors.right: parent.right
		anchors.top: labelFieldBBG.bottom
		anchors.topMargin: labelFieldSpacing

		color: colors["side"]

		radius: height / 4

		Text {
			id: labelFieldCIcon
			width: (textIcon != "" ? height : 0)
			height: labelFieldCBG.height

			anchors.left: parent.left
			anchors.leftMargin: parent.width * 0.1

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			text: textIcon
			font.family: outfit.name
			font.pixelSize: 24
			color: opacityColor(colors["text"], 0.2)
		}

		TextInput {
			id: labelFieldC
			width: parent.width * 0.8 - labelFieldCIcon.contentWidth - 2
			height: parent.height

			anchors.right: parent.right
			anchors.rightMargin: parent.width * 0.1

			color: colors["text"]
			font.family: outfit.name
			font.pixelSize: 24

			inputMask: restrictTo
			selectByMouse: true

			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter

			onTextEdited: {
				triContent[2] = text

				if (matchInt != 0 || restrictRange.length == 2) {
					if (text.match("[^0-9]")) {
						labelFieldC.undo()
					}
				}

				if (restrictRange.length == 2) {
					if (parseInt(text) > restrictRange[1]) {
						text = restrictRange[1].toString()
						triContent[2] = text
					}
					if (parseInt(text) < restrictRange[0]) {
						text = restrictRange[0].toString()
						triContent[2] = text
					}
				}

				if (matchCase != "")
					checkIfMatch(text)
				if (matchInt != 0)
					checkIfMatchInt()
			}
		}
	}

	function checkIfMatch(text) {
		if (matchCase == "hex") {
			if (text.length == 6 && !text.match("[^A-Fa-f0-9]"))
				matchAction()
		}
	}

	function checkIfMatchInt() {
		if (parseInt(labelFieldA.text) <= matchInt) {
			if (!triple) {
				matchAction()
			} else {
				if (parseInt(labelFieldB.text) <= matchInt && parseInt(labelFieldC.text) <= matchInt) {
					matchAction()
				}
			}
		}
	}

	function setContent(contentI) {
		labelFieldA.text = contentI
		content = contentI
	}

	function setTripleContent(contentA, contentB, contentC) {
		labelFieldA.text = contentA
		labelFieldB.text = contentB
		labelFieldC.text = contentC
		triContent = [contentA, contentB, contentC]
	}
}
