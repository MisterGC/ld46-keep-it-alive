// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import QtMultimedia 5.12
import Box2D 2.0
import Clayground.GameController 1.0
import Clayground.World 1.0

ClayWorld {
    id: theWorld

    map: "map.svg"
    pixelPerUnit: width / theWorld.worldXMax
    gravity: Qt.point(0,0)
    timeStep: 1/60.0

    property var player: null
    onWorldAboutToBeCreated: player = null;
    onWorldCreated: {
        theGameCtrl.selectKeyboard(Qt.Key_Up,
                                   Qt.Key_Down,
                                   Qt.Key_Left,
                                   Qt.Key_Right,
                                   Qt.Key_A,
                                   Qt.Key_S);
        theWorld.observedItem = player;
    }

    Keys.forwardTo: theGameCtrl
    GameController {
        id: theGameCtrl
        anchors.fill: parent

        onButtonAPressedChanged: {
            player.maxVelo = buttonAPressed ? 35 : 18;
        }

        onAxisXChanged: {
            if (axisX > 0) player.moveRight();
            else if (axisX < 0) player.moveLeft();
            else { player.stopLeft(); player.stopRight();}
        }
        onAxisYChanged: {
            if (axisY > 0) player.moveUp();
            else if (axisY < 0) player.moveDown();
            else { player.stopUp(); player.stopDown();}
        }

    }

    onObjectCreated: {
        if (isInstanceOf(obj, "Player")) {
            player = obj;
            player.source = theWorld.resource("visual/player.png");
        }
        else if (isInstanceOf(obj, "Enemy")) {
            obj.source = theWorld.resource("visual/enemy.png");
        }
    }

    SoundEffect {
        id: bgMusic
        //TODO Replace music place-holder and react. play
        //Component.onCompleted: play();
        source: theWorld.resource("sound/bgmusic.wav")
        loops: SoundEffect.Infinite
    }
}
