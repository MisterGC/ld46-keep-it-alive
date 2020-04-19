// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.12
import Box2D 2.0
import Clayground.Physics 1.0
import Clayground.ScalingCanvas 1.0

VisualizedBoxBody
{
    id: theEntity

    property bool debug: false
    property string text: ""
    property var gameWorld: theWorld
    Loader { sourceComponent: debug ? theDebugTxtComp : null }
    Component {
        id: theDebugTxtComp
        ScalingText {
            anchors.bottom: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            parent: theEntity
            canvas: theWorld
            fontSizeWu: 2.0
            text: theEntity.text
        }
    }
}

