// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0
import QtGraphicalEffects 1.12

GameEntity
{
    id: theGarden

    readonly property string _baseimg: energyPercentage > 0.75 ? "garden"
            : (energyPercentage > 0.33 ? "gardend1" : "gardend2")
    source:  gameWorld.resource("visual/" + _baseimg + "low.png")
    bodyType: Body.Static
    categories: collCat.garden
    collidesWith: collCat.player |
                  collCat.enemy |
                  collCat.naturalForce |
                  collCat.magicProtection
    debug: true
    color: protection > 0 ? "lightgreen" : "green"
    property int maxEnergy: widthWu * heightWu
    // Energy of the garden, if it is 0, the garden dead
    property int energy: maxEnergy
    property real energyPercentage: (energy * 1.0)/maxEnergy
    // Protection decreases dealt damage
    property real protection: 0

    text: energy + "/" + protection
    GlowEffect {
        visible:  theGarden.protection > 0
        image: theGarden.image
    }

    Image {
        source:  gameWorld.resource("visual/" + _baseimg + "up.png")
        parent: theGarden.parent
        x: theGarden.x
        y: theGarden.y - height
        width: theGarden.width
        height: theGarden.height * 1.21
        z: 99
    }

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.beginContact.connect(_onBeginContact);
            f.endContact.connect(_onEndContact);
        }
    }

    function _onBeginContact(fixture) {
        var e = fixture.getBody().target;
        if (e instanceof Storm)
            e.attack.connect(_onAttack)
        else if (e instanceof Player) {
            if (fixture.hasOwnProperty("protection")) {
                protection = fixture.protection;
            }
        }
        else if (e instanceof Enemy) {
            e.attack.connect(_onAttack);
        }
    }

    function _onEndContact(fixture) {
        var e = fixture.getBody().target;
        if (e instanceof Player) {
            if (fixture.hasOwnProperty("protection")) protection = 0;
        }
        else if (e instanceof Enemy) {
            e.attack.disconnect(_onAttack);
        }
    }

    function _onAttack(damage) {
        let d = damage * ((protection > 0) ? protection : 1)
        if (energy > 0) energy -= d;
        if (energy < 0) energy = 0;

    }
}
