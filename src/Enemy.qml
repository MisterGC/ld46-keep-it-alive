// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: theEnemy
    bodyType: Body.Dynamic
    bullet: true
    sensor: true
    categories: collCat.enemy
    collidesWith: collCat.player | collCat.waypoint
    debug: true

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onCollision);
        }
    }

    function _onCollision(fixture) {
        var e = fixture.getBody().target;
        if (theWorld.isInstanceOf(e, "Player")) {
            if (e.isDodging) theEnemy.destroy();
            else e.energy -= 1;
        }
    }

    property int energy: 10000
}
