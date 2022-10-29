import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3

import "UIComponents"

ApplicationWindow {
    id: root

    width: 1280
    height: 800

    minimumWidth: 640
    minimumHeight: 400

    visible: true
    title: "ColorApp"

	color: colors["tool"]

	// Backend Connections
	property QtObject backend

	signal loaded()
	signal saveColors(variant colors, string path)
	signal loadColors(string path)

	signal generateColors(string hexcode, int mode)

	signal togopt(string option)

	Connections {
		target: backend


		function onSendData(data, index) {
			// Initial Data sends
			if (index == 0) {
				colors = data
			}

			if (index == 1) {
				options = data
			}

			if (index == 2) {
				previewUrls = data
			}

			// Colorscheme Generation Sends
			if (index == 10) {
				// Success
				console.log("Success")
				requestingColorscheme = false

				// Add colors to ColorList
				for (let i = 0; i < data.length; i++) {
					sidebar.addColor(data[i])
				}
			}
			if (index == 11) {
				// Error
				console.log(data[0])
				requestingColorscheme = false
				colorschemeRequestError = true
				colorschemeRequestErrorDisplayTimer.start()
			}



			// Special Data Sends
			if (index == -1) {
				// Send Colors from file
				console.log(data)

				sidebar.resetColors()
				for (let i = 0; i < data.length; i++) {
					sidebar.addColor(data[i])
				}

				root.switchToColor(0)
			}
		}

	}

	Timer {
		interval: 10
		running: true

		onTriggered: {
			root.loaded()
		}
	}

	// Constants
	readonly property var toolbarHeight: 48
	readonly property var sidebarWidth: 200

	readonly property var sidebarMargin: 20
	readonly property var sideToolCharmHeight: 48

	readonly property var colorPageTopMargin: 32
	readonly property var labelFieldHeight: 48
	readonly property var labelFieldSpacing: 8

	readonly property var customDialogSpacing: 24

	readonly property var optionSpacing: 24
	readonly property var optionHeight: 72

	// Fonts
	FontLoader { source: "./assets/font/Outfit-Thin.ttf" }
	FontLoader { source: "./assets/font/Outfit-Light.ttf" }
	FontLoader { id: outfit; source: "./assets/font/Outfit-Regular.ttf" }
	FontLoader { source: "./assets/font/Outfit-Medium.ttf" }
	FontLoader { source: "./assets/font/Outfit-Bold.ttf" }

	// Variables

	property int viewPage: 0
	property int chosenColor: -1

	property var colors: {}
	property var info: {}

	property var previewUrls: []

	property var options: {}

	property bool requestingColorscheme: false
	property bool colorschemeRequestError: false
	Timer {
		id: colorschemeRequestErrorDisplayTimer
		interval: 2000
		onTriggered: {
			colorschemeRequestError = false
		}
	}

	// Background
	Rectangle {
		id: mainBG
		width: parent.width - sidebarWidth
		height: parent.height - toolbarHeight
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		color: colors["main"]
	}

	SidePanel { id: sidebar }
	Toolbar { id: toolbar; z: 8 }

	ColorScreen { id: main; visible: (chosenColor >= 0 && viewPage == 0)}
	ConfigScreen { id: config; visible: (viewPage == 1)}
	PreviewScreen { id: preview; visible: (viewPage == 2)}




	// Functions
	function switchToColor(index) {
		chosenColor = index
		main.setColorData(sidebar.getColorFromIndex(index))
	}

	function updateColor(index, hex) {
		sidebar.updateColor(index, hex)
	}

	function resetColors() {
		chosenColor = -1
		sidebar.resetColors()
	}



	// Hex is in form #rrggbb
	function hexToRgb(hex) {
		let newhex = hex.trim().replace("#","")

		let r = parseInt(newhex.substring(0, 2), 16)
		let g = parseInt(newhex.substring(2, 4), 16)
		let b = parseInt(newhex.substring(4, 6), 16)

		return [r, g, b]
	}

	// RGB is 3 ints from 0-255
	function rgbToHex(r, g, b) {
		let convR = ""
		// Math.round here prevents numbers between 15.5 and 16 from being displayed incorrectly (ex HSV(62,15,7))
		if (Math.round(r) < 16)
			convR = "0" + Number(Math.round(r)).toString(16)
		else
			convR = Number(Math.round(r)).toString(16)

		let convG = ""
		if (Math.round(g) < 16)
			convG = "0" + Number(Math.round(g)).toString(16)
		else
			convG = Number(Math.round(g)).toString(16)

		let convB = ""
		if (Math.round(b) < 16)
			convB = "0" + Number(Math.round(b)).toString(16)
		else
			convB = Number(Math.round(b)).toString(16)

		//console.log(r, g, b)
		return "#" + convR + convG + convB
	}

	// https://gist.github.com/mjackson/5311256
	// RGB is 3 ints from 0-255
	function rgbToHsv(r, g, b) {
		r /= 255
		g /= 255
		b /= 255

		let max = Math.max(r, g, b)
		let min = Math.min(r, g, b)

		let h, s, v = max

		let d = max - min
		s = (max == 0 ? 0 : d / max)

		if (max == min) {
			h = 0
		} else {
			switch(max) {
				case r: h = (g - b) / d + (g < b ? 6 : 0); break;
				case g: h = (b - r) / d + 2; break;
				case b: h = (r - g) / d + 4; break;
			}
			h /= 6;
		}

		h = Math.floor(h * 100)
		s = Math.floor(s * 100)
		v = Math.floor(v * 100)

		return [h, s, v]
	}

	// HSV is 3 ints from 0-100
	function hsvToRgb(h, s, v) {
		h /= 100, s /= 100, v /= 100

		let r, g, b

		let i = Math.floor(h * 6)
		let f = h * 6 - i
		let p = v * (1 - s)
		let q = v * (1 - f * s)
		let t = v * (1 - (1 - f) * s)

		switch (i % 6) {
			case 0: r = v, g = t, b = p; break;
			case 1: r = q, g = v, b = p; break;
			case 2: r = p, g = v, b = t; break;
			case 3: r = p, g = q, b = v; break;
			case 4: r = t, g = p, b = v; break;
			case 5: r = v, g = p, b = q; break;
		}

		return [r * 255, g * 255, b * 255]
	}

	// From Wikipedia: https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_HSL
	// HSV is 3 ints from 0-100
	function hsvToHsl(h, s, v) {
		h /= 100, s /= 100, v /= 100
		let ns, l

		l = v * (1 - (s / 2))
		ns = ((l == 0 || l == 1) ? 0 : (v - l) / Math.min(l, 1 - l))

		h = Math.round(h * 100)
		ns = Math.round(ns * 100)
		l = Math.round(l * 100)
		return [h, ns, l]
	}

	function hslToHsv(h, s, l) {
		h /= 100, s /= 100, l /= 100
		console.log(h, s, l)
		let ns, v

		v = l + (s * Math.min(l, 1 - l))
		ns = ((v == 0) ? 0 : (2 * (1 - (l / v))))

		h = Math.round(h * 100)
		ns = Math.round(ns * 100)
		v = Math.round(l * 100)
		return [h, ns, v]
	}




	function luminosityContrast(rgb) {
		let luminosity = (0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]) / 255

		if (luminosity <= 0.5) {
			return 1
		} else {
			return 0
		}
	}

	function opacityColor(color, opacity) {
		let strippedCol = color.trim().replace("#", "")
		let opacConv = (Math.floor(opacity * 255)).toString(16)
		return "#" + opacConv + strippedCol
	}



	function saveColorsToFile(filepath) {
		let list = sidebar.getColorList()
		root.saveColors(list, filepath.toString().replace("file://", ""))
	}

	function loadColorsFromFile(filepath) {
		root.loadColors(filepath.toString().replace("file://", ""))
	}

	function fetchColors() {
		return sidebar.getColorList(true)
	}



	function refreshPreview() {
		preview.refreshPreview()
	}



	function toggleOption(option) {
		console.log("Sending Option Change " + option)
		root.togopt(option)
	}
}
