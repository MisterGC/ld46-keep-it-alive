// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Rectangle {
    id: theGameEnding

    property Referee referee: null
    signal requestRestart()

    visible: false
    anchors.fill: parent
    Component.onCompleted: {
        referee.playerDied.connect(onPlayerDied);
        referee.gardenDied.connect(onGardenDied);
        referee.seasonEnded.connect(onSeasonEnded);
    }

    function onGardenDied() {showEnd("Garden died!");}
    function onPlayerDied()  {showEnd("Player died!");}
    function onSeasonEnded()  {showEnd("Season ended!");}

    function showEnd(txt) {
        if (!visible) {
            theEndTxt.text = txt;
            visible = true;
        }
    }

    Text {
        id: theEndTxt
        anchors.centerIn: parent
        font.pixelSize: parent.height * .1
        text: "The Game ends ..."
    }
}

