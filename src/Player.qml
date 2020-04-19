// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

GameEntity
{
    id: thePlayer
    bodyType: Body.Dynamic
    bullet: true

    property int energy: 3

    property real moveSpeed: 25
    property real dodgeSpeed: 0
    property real _desiredVeloX: 0
    property real _desiredVeloY: 0
    property bool desiresToMove: Math.abs(_desiredVeloX) > 0
                                 || Math.abs(_desiredVeloY) > 0
    property bool isDodging: dodgeSpeed > 0
    property bool isProtecting: false
    // Workaround to trigger collision checks even if player doesn't
    // move between triggering protections two time
    onIsProtectingChanged: { awake = false; awake = true; }

    debug: true
    text: energy > 0 ? "♥".repeat(energy) : "☠"

    categories: collCat.player
    collidesWith: collCat.enemy | collCat.staticGeo | collCat.garden

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.endContact.connect(_onEndContact);
        }
        let obj = protectionRange.createObject(thePlayer,{});
        body.addFixture(obj);
    }

    Rectangle {
        id: protectionRangeVisu
        opacity: .2
        color: "red"
        visible: thePlayer.isProtecting
        property int scaleFac: thePlayer.isProtecting ? 10 : 1
        x: -.5 * (width - thePlayer.width)
        y: -.5 * (width - thePlayer.width)
        width: thePlayer.width * scaleFac
        height: thePlayer.height * scaleFac
    }

    Component {
        id: protectionRange
        Box {
            x: protectionRangeVisu.x
            y: protectionRangeVisu.y
            width:  protectionRangeVisu.width
            height: protectionRangeVisu.height
            sensor: true
            categories: collCat.magicProtection
            collidesWith: collCat.garden
            property real protection: thePlayer.isProtecting ? .5 : 0
        }
    }

    onDodgeSpeedChanged: {
        _updateVelocity();
        if (dodgeSpeed > 0) dodgeT.start();
    }
    Timer { id: dodgeT; interval: 200; onTriggered: thePlayer.dodgeSpeed = 0; }

    function _onEndContact() { _updateVelocity(); }
    on_DesiredVeloXChanged: _updateVelocity()
    on_DesiredVeloYChanged: _updateVelocity()
    onMoveSpeedChanged: _updateVelocity()
    function _updateVelocity() {
        let speed = moveSpeed > dodgeSpeed ? moveSpeed : dodgeSpeed;
        if (Math.abs(_desiredVeloX) > 1)
            _desiredVeloX = _desiredVeloX < 0 ? -speed : speed;
        if (Math.abs(_desiredVeloY) > 1)
            _desiredVeloY = _desiredVeloY < 0 ? -speed : speed;
        body.linearVelocity.x = _desiredVeloX;
        body.linearVelocity.y = _desiredVeloY;
    }

    function moveUp() { _desiredVeloY = -moveSpeed; }
    function moveDown() { _desiredVeloY = moveSpeed; }
    function moveLeft() { _desiredVeloX = -moveSpeed; }
    function moveRight() { _desiredVeloX = moveSpeed; }

    function stopUp() { if (_desiredVeloY < 0) _desiredVeloY = 0; }
    function stopDown() { if (_desiredVeloY > 0) _desiredVeloY = 0; }
    function stopLeft() { if (_desiredVeloX < 0) _desiredVeloX = 0; }
    function stopRight() { if (_desiredVeloX > 0) _desiredVeloX = 0; }
}
