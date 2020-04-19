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
    collidesWith: collCat.player | collCat.waypoint
    property var wpPath: []
    property int _wpIndex: -1
    property real maxVelo: 10

    debug: true

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onCollision);
        }
        _goForNextWp();
    }

    function _goForNextWp() {
        if (_wpIndex + 1 < wpPath.length)  {
            _wpIndex ++;
            let dest = wpPath[_wpIndex];
            let v = Qt.vector2d(dest.x - x, dest.y - y);
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
    }
}
