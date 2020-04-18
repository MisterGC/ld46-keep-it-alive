// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import QtMultimedia 5.12
import Box2D 2.0
import Clayground.GameController 1.0
import Clayground.World 1.0

ClayWorld {
    id: theWorld

    map: "map.svg"
    pixelPerUnit: height/70
    gravity: Qt.point(0,0)
    timeStep: 1/60.0

    property var player: null

    QtObject {
        id: collCat
        readonly property int staticGeo: Box.Category1
        readonly property int player: Box.Category2
        readonly property int enemy: Box.Category3
        readonly property int naturalForce: Box.Category4
        readonly property int garden: Box.Category5
        readonly property int magicProtection: Box.Category6
        readonly property int noCollision: Box.None
    }

    onWorldAboutToBeCreated: player = null;
    onWorldCreated: {
//        theGameCtrl.selectKeyboard(Qt.Key_Up,
//                                   Qt.Key_Down,
//                                   Qt.Key_Left,
//                                   Qt.Key_Right,
//                                   Qt.Key_A,
//                                   Qt.Key_S);
        theGameCtrl.selectGamepad(0, true);
        theWorld.observedItem = player;
    }

    Weather { }

    Keys.forwardTo: theGameCtrl
    GameController {
        id: theGameCtrl
        anchors.fill: parent

        onButtonAPressedChanged: {
            if (player.isProtecting) return;
            player.moveSpeed = buttonAPressed ? 35 : 18;
        }

        onButtonBPressedChanged: {
            let p = player;
            if (buttonBPressed) {
                if (p.desiresToMove) p.dodgeSpeed = 75;
                else p.isProtecting = true;
            }
            else
                p.isProtecting = false;
        }

        onAxisXChanged: {
            if (player.isProtecting) return;
            if (axisX > 0) player.moveRight();
            else if (axisX < 0) player.moveLeft();
            else { player.stopLeft(); player.stopRight();}
        }
        onAxisYChanged: {
            if (player.isProtecting) return;
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
