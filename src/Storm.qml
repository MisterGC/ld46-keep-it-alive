// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: theStorm
    bodyType: Body.Dynamic
    categories: collCat.naturalForce
    collidesWith: collCat.garden
    debug: true
    color: "grey"
    opacity: .5
    sensor: true
    property int durationSeconds: 10

    signal attack(var damage)

    Timer {
        interval: durationSeconds * 1000
        onTriggered: theStorm.destroy();
        Component.onCompleted: start()
        repeat: true
    }

    Timer {
        interval: 1000
        onTriggered: attack(2);
        Component.onCompleted: start()
        repeat: true
    }

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onCollision);
        }
    }

    function _onCollision(fixture) {
    }
}

