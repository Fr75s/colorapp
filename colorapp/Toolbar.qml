import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

Item {
	width: parent.width
	height: toolbarHeight

	RowLayout {
		id: toolbarRow
		height: parent.height
		spacing: 0

		ToolbarIcon {
			ticon: "document-new-symbolic"
			col: colors["text"]

			function pushAction() {
				if (chosenColor != -1) {
					newWarning.open()
				} else {
					root.resetColors()
				}
			}
		}

		ToolbarIcon {
			ticon: "document-open-symbolic"
			col: colors["text"]

			function pushAction() {
				if (chosenColor != -1) {
					loadWarning.open()
				} else {
					console.log("Opening File")
					loadDialog.open()
				}
			}
		}

		ToolbarIcon {
			ticon: "document-save-symbolic"
			col: colors["text"]

			function pushAction() {
				if (chosenColor != -1) {
					console.log("Saving File")
					saveDialog.open()
				}
			}
		}
	}

	/*
	ToolbarIcon {
		anchors.right: parent.right

		ticon: "application-exit-symbolic"
		col: colors["text"]

		function pushAction() {
			if (chosenColor != -1) {
				saveWarning.open()
			} else {
				console.log("Quitting")
				Qt.quit()
			}
		}
	}
	*/



	CustomDialog {
		id: saveWarning

		z: 10

		title: "Are You Sure?"
		info: "Unsaved Data will be lost."

		buttons: ["yes", "no"]

		onAccepted: {
			console.log("Quitting")
			Qt.quit()
		}
	}

	CustomDialog {
		id: loadWarning

		z: 10

		title: "Are You Sure?"
		info: "Unsaved Data will be lost."

		buttons: ["yes", "no"]

		onAccepted: {
			console.log("Opening File Dialog")
			loadDialog.open()
		}
	}

	CustomDialog {
		id: newWarning

		z: 10

		title: "Are You Sure?"
		info: "Unsaved Data will be lost."

		buttons: ["yes", "no"]

		onAccepted: {
			root.resetColors()
		}
	}



	FileDialog {
		id: saveDialog

		selectExisting: false
		folder: shortcuts.home

		title: "Save Colors"
		nameFilters: [ "JSON files (*.json)" ]

		onAccepted: {
			root.saveColorsToFile(fileUrl)
		}

		onRejected: {
			console.log("Save Cancelled")
		}
	}

	FileDialog {
		id: loadDialog

		selectExisting: true
		folder: shortcuts.home

		title: "Load Colors"
		nameFilters: [ "JSON files (*.json)" ]

		onAccepted: {
			root.loadColorsFromFile(fileUrl)
		}

		onRejected: {
			console.log("Load Cancelled")
		}
	}


}
