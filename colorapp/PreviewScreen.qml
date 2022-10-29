import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

Item {
	id: main

	property bool displayingPreview: false
	property url currentPreview: "./PreviewsBuiltin/Window.qml"

	width: parent.width - sidebarWidth
	height: parent.height - toolbarHeight
	anchors.right: parent.right
	anchors.bottom: parent.bottom



	Loader {
		id: fullPreviewDisplay
		width: parent.width * 0.8
		height: parent.height * 0.8

		anchors.centerIn: parent
		source: currentPreview

		onLoaded: {
			item.colors = root.fetchColors()
		}
	}



	function refreshPreview() {
		let colorList = root.fetchColors()
		if (colorList.length < fullPreviewDisplay.item.requiredColors) {
			console.log("Not Enough Colors!")
		} else {
			fullPreviewDisplay.item.colors = colorList
		}
	}

}
