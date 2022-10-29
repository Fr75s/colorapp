import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

Item {
	id: sidebar
	width: sidebarWidth
	height: parent.height - toolbarHeight
	anchors.left: parent.left
	anchors.bottom: parent.bottom

	Rectangle {
		id: sideBG
		anchors.fill: parent

		color: colors["side"]
	}

	ListModel {
		id: colorList
	}

	Component.onCompleted: {
		[
			{
				col: "ADD_COLOR",
				name: ""
			}
		].forEach(function(e) { colorList.append(e); });
	}

	ListView {
		id: colorView

		width: parent.width - (sidebarMargin * 2)
		height: parent.height - (sidebarMargin * 2) - sideToolCharmHeight

		anchors.left: parent.left
		anchors.top: parent.top

		anchors.leftMargin: sidebarMargin
		anchors.topMargin: sidebarMargin

		clip: true
		boundsBehavior: Flickable.StopAtBounds
		spacing: sidebarMargin

		currentIndex: (chosenColor < 0) ? 0 : chosenColor
		highlightFollowsCurrentItem: true

		model: colorList
		delegate: Item {
			width: ListView.view.width
			height: 60

			property var contrast: (root.luminosityContrast(root.hexToRgb(col)))

			Rectangle {
				id: colorDisp
				width: parent.width
				height: parent.height

				color: (col != "ADD_COLOR") ? col : (action.containsMouse ? colors["main"] : colors["side"])
				radius: height / 4

				Behavior on color {
					ColorAnimation {
						duration: 100
					}
				}
			}

			Rectangle {
				width: height
				height: parent.height / 4

				anchors.centerIn: parent

				color: (index == chosenColor && col) ? (contrast == 1 ? colors["text"] : colors["tool"]) : "transparent"
				radius: height / 2

				Behavior on color {
					ColorAnimation {
						duration: 100
					}
				}
			}

			MouseArea {
				id: action
				anchors.fill: parent
				hoverEnabled: true

				acceptedButtons: Qt.LeftButton | Qt.RightButton
				cursorShape: Qt.PointingHandCursor

				onClicked: {
					if (mouse.button === Qt.RightButton) {
						if (col != "ADD_COLOR") {
							sidebar.removeColor(index)
						}
					} else {
						if (col == "ADD_COLOR") {
							sidebar.addColor({ "col": "#ffffff", "name": "" })
							root.switchToColor(colorList.count - 2)
						} else {
							if (viewPage != 0)
								viewPage = 0
							root.switchToColor(index)
						}
					}
				}
			}

			// Arrows
			Rectangle {
				width: height
				height: parent.height * 0.5

				visible: (col != "ADD_COLOR") && (index < colorList.count - 2)

				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: parent.height * 0.25

				color: downActionL.containsMouse ? (contrast == 1 ? opacityColor(colors["text"], 0.15) : opacityColor(colors["tool"], 0.15)) : "transparent"
				radius: height / 4

				Icon {
					width: parent.width * 0.8
					height: parent.height * 0.8

					anchors.centerIn: parent

					name: "arrow-down"
					icol: contrast == 1 ? colors["text"] : colors["tool"]
				}

				MouseArea {
					id: downActionL

					anchors.fill: parent
					hoverEnabled: true

					onClicked: {
						if (index < colorList.count - 2) {
							colorList.move(index, index + 1, 1)
							root.switchToColor(index)
						}
					}
				}
			}

			Rectangle {
				width: height
				height: parent.height * 0.5

				visible: (col != "ADD_COLOR") && (index > 0)

				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: parent.height * 0.25

				color: downActionR.containsMouse ? (contrast == 1 ? opacityColor(colors["text"], 0.15) : opacityColor(colors["tool"], 0.15)) : "transparent"
				radius: height / 4

				Icon {
					width: parent.width * 0.8
					height: parent.height * 0.8

					anchors.centerIn: parent

					name: "arrow-up"
					icol: contrast == 1 ? colors["text"] : colors["tool"]
				}

				MouseArea {
					id: downActionR

					anchors.fill: parent
					hoverEnabled: true

					onClicked: {
						if (index > 0) {
							colorList.move(index, index - 1, 1)
							root.switchToColor(index)
						}
					}
				}
			}

			// Plus
			Rectangle {
				width: parent.height * 0.6
				height: 8

				anchors.centerIn: parent

				radius: height / 2
				color: colors["text"]

				visible: (col == "ADD_COLOR")
			}

			Rectangle {
				width: 8
				height: parent.height * 0.6

				anchors.centerIn: parent

				radius: width / 2
				color: colors["text"]

				visible: (col == "ADD_COLOR")
			}
		}
	}

	Rectangle {
		id: sideTools

		color: colors["tool"]
		width: parent.width
		height: sideToolCharmHeight

		anchors.bottom: parent.bottom

		RowLayout {
			anchors.fill: parent

			EvenIcon {
				iname: "configure"
				col: colors["text"]

				toggled: viewPage == 1

				function pushAction() {
					if (viewPage != 1) {
						viewPage = 1
					} else {
						viewPage = 0
					}
				}
			}

			EvenIcon {
				iname: requestingColorscheme ? "content-loading-symbolic" : (colorschemeRequestError ? "dialog-warning-symbolic" : "tools-wizard")
				col: colors["text"]

				function pushAction() {
					if (chosenColor >= 0)
						root.generateColors(getColorFromIndex(chosenColor), options["altcolschemegen"] ? 1 : 0)
						requestingColorscheme = true
				}
			}

			/*
			EvenIcon {
				iname: "view-preview"
				col: colors["text"]

				toggled: viewPage == 2

				function pushAction() {
					if (viewPage != 2) {
						viewPage = 2
						root.refreshPreview()
					} else {
						viewPage = 0
					}
				}
			}
			*/
		}
	}




	function addColor(properties) {
		colorList.insert(colorList.count - 1, properties)
	}

	function removeColor(idx) {
		colorList.remove(idx)

		//console.log(idx + ", " + colorList.count)
		if (root.chosenColor == colorList.count - 1) {
			root.chosenColor -= 1
		}
		if (idx == 0 && colorList.count == 1) {
			root.chosenColor = -1
		}

		root.switchToColor(chosenColor)
	}

	function resetColors() {
		colorList.clear()
		colorList.append({
			col: "ADD_COLOR",
			idx: -1
		})
	}

	function updateColor(idx, hex) {
		//console.log("Updating Color " + idx + " to " + hex)
		colorList.setProperty(idx, "col", hex)
	}

	function getColorFromIndex(idx) {
		//console.log("Getting color " + idx)
		if (idx >= 0)
			return colorList.get(idx).col
	}



	function getColorList(raw = false) {
		let l = []

		for (let i = 0; i < colorList.count - 1; i++) {
			if (raw)
				l[i] = (colorList.get(i).col)
			else
				l[i] = (colorList.get(i))
		}

		return l
	}
}
