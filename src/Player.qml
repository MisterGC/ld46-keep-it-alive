// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0

VisualizedBoxBody
{
    id: thePlayer
    bodyType: Body.Dynamic
    bullet: true
    property real maxVelo: 25
    property real desiredVeloX: 0
    property real desiredVeloY: 0
    categories: Box.Category2
    collidesWith: Box.Category1 | Box.Category3
    property bool isPlayer: true

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.endContact.connect(_onEndContact);
        }
    }

    function _onEndContact() { _updateVelocity(); }
    onDesiredVeloXChanged: _updateVelocity()
    onDesiredVeloYChanged: _updateVelocity()
    onMaxVeloChanged: _updateVelocity()
    function _updateVelocity() {
        if (Math.abs(desiredVeloX) > 1)
            desiredVeloX = desiredVeloX < 0 ? -maxVelo : maxVelo;
        if (Math.abs(desiredVeloY) > 1)
            desiredVeloY = desiredVeloY < 0 ? -maxVelo : maxVelo;
        body.linearVelocity.x = desiredVeloX;
        body.linearVelocity.y = desiredVeloY;
    }

    function moveUp() { desiredVeloY = -maxVelo; }
    function moveDown() { desiredVeloY = maxVelo; }
    function moveLeft() { desiredVeloX = -maxVelo; }
    function moveRight() { desiredVeloX = maxVelo; }

    function stopUp() { if (desiredVeloY < 0) desiredVeloY = 0; }
    function stopDown() { if (desiredVeloY > 0) desiredVeloY = 0; }
    function stopLeft() { if (desiredVeloX < 0) desiredVeloX = 0; }
    function stopRight() { if (desiredVeloX > 0) desiredVeloX = 0; }
}
