// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Rectangle {
    id: theStartScreen

    property Referee referee: null
    signal requestStart()

    visible: false
    anchors.fill: parent

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * .07
        text: "Welcome to the Game"
    }
}


