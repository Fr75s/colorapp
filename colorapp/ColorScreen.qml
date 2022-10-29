import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

Item {
	id: main

	width: parent.width - sidebarWidth
	height: parent.height - toolbarHeight
	anchors.right: parent.right
	anchors.bottom: parent.bottom

	Rectangle {
		id: colorDisplay
		width: parent.width * 0.8
		height: width / 4

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top

		anchors.topMargin: colorPageTopMargin

		color: "#000000"
		radius: 20

		Behavior on color {
			ColorAnimation {
				duration: 100
			}
		}

		MouseArea {
			id: colorDisplayPickOpener
			anchors.fill: parent

			cursorShape: Qt.PointingHandCursor

			onClicked: {
				colorDisplayPick.open()
			}
		}

		/*
		Text {
			anchors.centerIn: parent
			text: fieldsBar.visible
		}
		*/
	}



	Flickable {
		id: fields
		width: parent.width * 0.8
		height: parent.height - colorDisplay.height - (colorPageTopMargin * 2)

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: colorDisplay.bottom
		anchors.topMargin: colorPageTopMargin

		clip: true

		contentWidth: width
		contentHeight: Math.max(fieldsA.height, fieldsB.height) + colorPageTopMargin
		boundsBehavior: Flickable.StopAtBounds

		ScrollBar.vertical: ScrollBar { id: fieldsBar }

		Column {
			id: fieldsA
			width: parent.width * 0.5 - (fieldsBar.visible ? fieldsBar.width : 0)
			anchors.left: parent.left
			anchors.top: parent.top

			spacing: labelFieldSpacing

			LabelField {
				id: hexLabel
				label: "Hex"
				textIcon: "#"
				matchCase: "hex"

				function matchAction() {
					root.updateColor(chosenColor, "#" + content)
					setColorData("#" + content)
				}
			}

			LabelField {
				id: rgbLabel
				label: "RGB"
				triple: true
				matchInt: 255

				restrictRange: [0, 255]

				function matchAction() {
					let hexVal = rgbToHex(triContent[0], triContent[1], triContent[2])
					root.updateColor(chosenColor, hexVal)
					setColorData(hexVal)
				}
			}
		}

		Column {
			id: fieldsB
			width: parent.width * 0.5 - (fieldsBar.visible ? fieldsBar.width : 0)
			anchors.left: fieldsA.right
			anchors.top: parent.top

			spacing: labelFieldSpacing

			LabelField {
				id: hsvLabel
				label: "HSV"
				triple: true
				matchInt: 100

				restrictRange: [0, 100]

				function matchAction() {
					let rgb = hsvToRgb(triContent[0], triContent[1], triContent[2])
					let hex = rgbToHex(rgb[0], rgb[1], rgb[2])
					root.updateColor(chosenColor, hex)
					setColorData(hex, "hsv")
				}
			}

			LabelField {
				id: hslLabel
				label: "HSL"
				triple: true
				matchInt: 100

				visible: options["simpledisp"]

				restrictRange: [0, 100]

				function matchAction() {
					let hsv = hslToHsv(triContent[0], triContent[1], triContent[2])
					let rgb = hsvToRgb(hsv[0], hsv[1], hsv[2])
					let hex = rgbToHex(rgb[0], rgb[1], rgb[2])
					root.updateColor(chosenColor, hex)
					setColorData(hex, "hsl")
				}
			}
		}
	}



	ColorDialog {
		id: colorDisplayPick

		title: "Choose Color"
		onAccepted: {
			root.updateColor(chosenColor, colorDisplayPick.color.toString())
			setColorData(colorDisplayPick.color.toString())
		}
	}




	function setColorData(col, exclude="") {
		// Expected: Col as hex color in format #rrggbb
		colorDisplay.color = col

		if (exclude != "hex") {
			hexLabel.setContent(col.replace("#",""))
		}

		let rgbForm = hexToRgb(col)
		if (exclude != "rgb") {
			rgbLabel.setTripleContent(rgbForm[0], rgbForm[1], rgbForm[2])
		}

		let hsvForm = rgbToHsv(rgbForm[0], rgbForm[1], rgbForm[2])
		if (exclude != "hsv") {
			hsvLabel.setTripleContent(hsvForm[0], hsvForm[1], hsvForm[2])
		}

		let hslForm = hsvToHsl(hsvForm[0], hsvForm[1], hsvForm[2])
		if (exclude != "hsl") {
			hslLabel.setTripleContent(hslForm[0], hslForm[1], hslForm[2])
		}
	}
}
