// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: theStorm

    source: gameWorld.resource("visual/storm.png");
    bodyType: Body.Dynamic
    categories: collCat.naturalForce
    collidesWith: collCat.garden
    debug: true
    color: "grey"
    sensor: true
    opacity: 0.9
    property int duration: 1000

    signal attack(var damage)

    Timer {
        interval: duration
        onTriggered: theStorm.destroy();
        Component.onCompleted: start()
    }

    Timer {
        interval: 1000
        onTriggered: attack(2);
        Component.onCompleted: start()
        repeat: true
    }

}

