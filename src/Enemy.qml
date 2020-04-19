// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: theEnemy

    source: gameWorld.resource("visual/enemy.png");
    bodyType: Body.Dynamic
    bullet: true
    sensor: true
    categories: collCat.enemy
    collidesWith: collCat.player | collCat.waypoint | collCat.garden
    property var wpPath: []
    property int _wpIndex: -1
    property real maxVelo: 10

    debug: true
    text: theMunchTimer.running ? "Munch Time" : "Hunnngry"
    signal attack(var damage)

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onCollision);
            f.endContact.connect(_onEndContact);
        }
        _goForNextWp();
    }

    function _goForNextWp() {
        if (_wpIndex + 1 < wpPath.length)  {
            _wpIndex ++;
            let dest = wpPath[_wpIndex];
            let dX = dest.x + dest.width * .5 - (x + width * .5);
            let dY = dest.y + dest.height * .5 - (y + height * .5);
            let v = Qt.vector2d(dX, dY);
            let l = v.length();
            if (l > 1) {
                v = v.times(maxVelo/l);
                linearVelocity.x = v.x;
                linearVelocity.y = v.y;
            }
        }
        else {
            linearVelocity.x = 0;
            linearVelocity.y = 0;
        }
    }

    function _onCollision(fixture) {
        var e = fixture.getBody().target;
        if (gameWorld.isInstanceOf(e, "Player")) {
            if (e.isDodging) theEnemy.destroy();
            else e.energy -= 1;
        }
        else if (gameWorld.isInstanceOf(e, "Waypoint")) {
            _goForNextWp();
        }
        else if (gameWorld.isInstanceOf(e, "Garden")) {
            theMunchTimer.start();
        }
    }

    function _onEndContact() {
        var e = fixture.getBody().target;
        if (gameWorld.isInstanceOf(e, "Garden")) {
            theMunchTimer.stop();
        }
    }

    Timer {
        id: theMunchTimer
        interval: 1000
        onTriggered: attack(2);
        repeat: true
    }
}
