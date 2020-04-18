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
    collidesWith: collCat.player |
                  collCat.enemy |
                  collCat.naturalForce |
                  collCat.magicProtection
    debug: true
    color: protection > 0 ? "lightgreen" : "green"
    // Energy of the garden, if it is 0, the garden dead
    property int energy: 100
    // Protection decreases dealt damage
    property int protection: 0

    text: energy + "/" + protection

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onBeginContact);
            f.endContact.connect(_onEndContact);
        }
    }

    function _onBeginContact(fixture) {
        var e = fixture.getBody().target;
        if (theWorld.isInstanceOf(e, "Storm"))
            e.attack.connect(_onAttack)
        else if (theWorld.isInstanceOf(e, "Player")) {
            if (fixture.hasOwnProperty("protection")) {
                protection = fixture.protection;
            }
        }
    }

    function _onEndContact(fixture) {
        var e = fixture.getBody().target;
        if (theWorld.isInstanceOf(e, "Player")) {
            if (fixture.hasOwnProperty("protection")) protection = 0;
        }
    }

    function _onAttack(damage) {
        let d = damage > protection ? damage - protection : 0;
        energy -= d;
    }
}
