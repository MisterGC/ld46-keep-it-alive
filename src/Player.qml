// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

VisualizedBoxBody
{
    id: thePlayer
    bodyType: Body.Dynamic
    bullet: true
    property real moveSpeed: 25
    property real dodgeSpeed: 0
    property real _desiredVeloX: 0
    property real _desiredVeloY: 0
    property bool isDodging: dodgeSpeed > 0
    onIsDodgingChanged: theDebugTxt.text = isDodging ? "~==>" : ""
    categories: Box.Category2
    collidesWith: Box.Category1 | Box.Category3
    property bool isPlayer: true

    Component.onCompleted: {
        for (let i=0; i<fixtures.length; ++i) {
            let f = fixtures[i];
            f.endContact.connect(_onEndContact);
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

    ScalingText {
        id: theDebugTxt
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        parent: thePlayer
        canvas: theWorld
        fontSizeWu: 2.0
        text: ""
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
