// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: theGarden
    bodyType: Body.Static
    categories: collCat.garden
    collidesWith: collCat.player | collCat.enemy | collCat.naturalForce
    debug: true
    color: "green"
    property int energy: 100
    text: energy

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onBeginContact);
        }
    }

    function _onBeginContact(fixture) {
        var e = fixture.getBody().target;
        if (theWorld.isInstanceOf(e, "Storm"))
            e.attack.connect(_onAttack)
    }

    function _onAttack(damage) {
        energy -= damage;
    }
}
