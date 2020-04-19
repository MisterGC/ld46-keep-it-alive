// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import QtMultimedia 5.12
import Box2D 2.0
import Clayground.GameController 1.0
import Clayground.World 1.0

ClayWorld {
    id: theWorld

    map: ""
    pixelPerUnit: height/70
    gravity: Qt.point(0,0)
    timeStep: 1/60.0
    running: false

    property var player: null
    //physicsDebugging: true

    Rectangle {parent: coordSys; anchors.fill: parent; color: "#75ba37";}

    QtObject {
        id: collCat
        readonly property int staticGeo: Box.Category1
        readonly property int player: Box.Category2
        readonly property int enemy: Box.Category3
        readonly property int naturalForce: Box.Category4
        readonly property int garden: Box.Category5
        readonly property int magicProtection: Box.Category6
        readonly property int waypoint: Box.Category7
        readonly property int noCollision: Box.None
    }

    onWorldAboutToBeCreated: {
        running = false;
        player = null;
    }
    onWorldCreated: {
//        theGameCtrl.selectKeyboard(Qt.Key_Up,
//                                   Qt.Key_Down,
//                                   Qt.Key_Left,
//                                   Qt.Key_Right,
//                                   Qt.Key_A,
//                                   Qt.Key_S);
        theGameCtrl.selectGamepad(0, true);
        theWorld.observedItem = player;
        theWorld.running = true;
    }

    Weather {id: theWeather; enabled: theWorld.running }
    Referee {
        id: theReferee
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0.04 * parent.height
        player: theWorld.player
        Text {
            id: refereeSays
            anchors.centerIn: parent
            text: Math.round(parent.gardenPercentage)
                  + (parent.player ? ("/" + parent.player.energy) : "")
                  + "/" + parent.seasonPercentage
        }
    }

    Keys.forwardTo: theGameCtrl
    GameController {
        id: theGameCtrl
        anchors.fill: parent

        property bool inGameCtrlEnabled: theWorld.running && theWorld.player

        onButtonAPressedChanged: {
            if (!inGameCtrlEnabled) return;
            if (player.isProtecting) return;
            player.moveSpeed = buttonAPressed ? 35 : 18;
        }

        onButtonBPressedChanged: {
            if (!inGameCtrlEnabled) return;
            let p = player;
            if (buttonBPressed) {
                if (p.desiresToMove) p.dodgeSpeed = 75;
                else p.isProtecting = true;
            }
            else
                p.isProtecting = false;
        }

        onAxisXChanged: {
            if (!inGameCtrlEnabled) return;
            if (player.isProtecting) return;
            if (axisX > 0) player.moveRight();
            else if (axisX < 0) player.moveLeft();
            else { player.stopLeft(); player.stopRight();}
        }
        onAxisYChanged: {
            if (!inGameCtrlEnabled) return;
            if (player.isProtecting) return;
            if (axisY > 0) player.moveUp();
            else if (axisY < 0) player.moveDown();
            else { player.stopUp(); player.stopDown();}
        }
        //showDebugOverlay: true

    }

    onObjectCreated: {
        if (isInstanceOf(obj, "Player")) {
            player = obj;
        }
        else if (isInstanceOf(obj, "Garden")) {
           theReferee.addGarden(obj);
        }
    }

    Component {id: theEnemyMasterComp; EnemyMaster {}}
    onPolylineLoaded: {
        let ent = theEnemyMasterComp.createObject(theWorld,
                                                  {
                                                      path: points,
                                                      enabled: theWorld.running
                                                  });
        ent.enabled = Qt.binding( _ => {return theWorld.running;} );
        entities.push(ent);
    }

    SoundEffect {
        id: bgMusic
        source: theWorld.resource("sound/bgmusic.wav")
        loops: SoundEffect.Infinite
    }

    StartScreen {
        visible: true
        Component.onCompleted: {
            theGameCtrl.buttonAPressedChanged.connect(startOnDemand)
            theGameCtrl.buttonBPressedChanged.connect(startOnDemand)
        }
        function startOnDemand() {
            if (visible) {
                map = "";
                map = "map.svg";
                visible = false;
                bgMusic.play();
            }
        }
    }

    GameEnding {
        referee: theReferee
        onVisibleChanged: {
            if (visible) bgMusic.stop();
        }

        Component.onCompleted: {
            theGameCtrl.buttonAPressedChanged.connect(restartOnDemand)
            theGameCtrl.buttonBPressedChanged.connect(restartOnDemand)
        }

        function restartOnDemand() {
            if (visible) {
                map = "";
                map = "map.svg";
                visible = false;
                bgMusic.play();
            }
        }
    }

}
