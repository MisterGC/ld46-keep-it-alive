// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Rectangle {
    id: theStartScreen

    property Referee referee: null
    signal requestStart()

    visible: false
    anchors.fill: parent

    Image {
        source: theWorld.resource("visual/titlescreen.png");
        height: parent.height
        width: (sourceSize.width / sourceSize.height) * height
        anchors.centerIn: parent
    }

    color: "#c7fcff"
}


