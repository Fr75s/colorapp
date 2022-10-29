import QtQuick 2.8
import QtQuick.Controls 2.15

Button {

	property var name: ""
	property var icol: ""

	flat: true

	icon.name: name
	icon.color: icol

	icon.source: "../assets/icons/" + name + ".svg"

	icon.height: height
	icon.width: width

	hoverEnabled: false
	focus: false

	focusPolicy: Qt.NoFocus
	padding: 0

	down: false
}
