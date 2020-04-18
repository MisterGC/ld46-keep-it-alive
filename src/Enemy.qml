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
    categories: Box.Category3
    collidesWith: Box.Category1 | Box.Category2
    debug: true

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onCollision);
        }
    }

    function _onCollision(fixture) {
        var e = fixture.getBody().target;
        if (e.isPlayer) {
            if (e.isDodging) theEnemy.destroy();
            else text = "Got ya!";
        }
    }

    property int energy: 10000
}
