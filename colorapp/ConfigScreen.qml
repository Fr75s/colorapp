import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

Item {
	id: config

	width: parent.width - sidebarWidth
	height: parent.height - toolbarHeight
	anchors.right: parent.right
	anchors.bottom: parent.bottom

	Flickable {
		id: pageFlickable
		width: parent.width * 0.8
		height: parent.height

		anchors.horizontalCenter: parent.horizontalCenter
		clip: true

		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar { id: fieldsBar }

		contentWidth: width
		contentHeight: page.height

		Column {
			id: page
			anchors.fill: parent

			spacing: optionSpacing

			Text {
				width: parent.width
				height: font.pixelSize + colorPageTopMargin

				verticalAlignment: Text.AlignBottom

				text: "Settings"
				color: colors["text"]
				font.family: outfit.name
				font.pixelSize: 48
			}

			ToggleOption {
				label: "View Advanced Color Codes"
				option: "simpledisp"
			}

			ToggleOption {
				label: "Use Alternative Color Generation Mode"
				option: "altcolschemegen"
			}
		}


	}

	Row {
		id: infoRow

		anchors.right: parent.right
		anchors.top: parent.top

		anchors.rightMargin: colorPageTopMargin
		//anchors.topMargin: colorPageTopMargin

		height: 96

		spacing: 4

		Image {
			width: height
			height: parent.height

			source: "assets/icon.png"
			mipmap: true
		}

		Text {
			width: contentWidth
			height: parent.height

			verticalAlignment: Text.AlignVCenter

			text: info["VERSION"]
			color: colors["text"]
			font.family: outfit.name
			font.weight: Font.Bold
			font.pixelSize: parent.height * 0.25
		}
	}

}
