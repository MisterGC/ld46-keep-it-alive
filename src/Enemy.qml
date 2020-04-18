// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

VisualizedBoxBody
{
    id: theEnemy
    bodyType: Body.Dynamic
    bullet: true
    sensor: true
    categories: Box.Category3
    collidesWith: Box.Category1 | Box.Category2

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
            else  theDebugTxt.text = "Got ya!";
        }
    }

    ScalingText {
        id: theDebugTxt
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        parent: theEnemy
        canvas: theWorld
        fontSizeWu: 1.0
        text: ""
    }

    property int energy: 10000
}
