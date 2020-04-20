// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Rectangle {
    id: theGameEnding

    property Referee referee: null

    visible: false
    anchors.fill: parent
    Component.onCompleted: {
        referee.playerDied.connect(onPlayerDied);
        referee.gardenDied.connect(onGardenDied);
        referee.seasonEnded.connect(onSeasonEnded);
    }

    function onGardenDied() {showEnd("gardendied", "#95a3a3");}
    function onPlayerDied()  {showEnd("keeperdied", "#9291a3");}
    function onSeasonEnded()  {showEnd("youhavewon", "#d8c371")}

    function showEnd(img, bgColor) {
        if (!visible) {
            theImage.source = theWorld.resource("visual/" + img + ".png");
            color = bgColor;
            visible = true;
        }
    }

    Image {
        id: theImage
        source: ""
        height: parent.height
        width: (sourceSize.width / sourceSize.height) * height
        anchors.centerIn: parent
    }
}

