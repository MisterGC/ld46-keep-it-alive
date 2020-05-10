// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick 2.0
import QtQuick.Particles 2.0
import QtMultimedia 5.12

Item {
    id: coverArea
    signal finished()
    SoundEffect {
        id: dodgeSound
        Component.onCompleted: play()
        source: theWorld.resource("sound/burst.wav")
        volume: .9
    }
    ParticleSystem {
        anchors.fill: parent
        Component.onCompleted: emitter.burst(40)
        Emitter {
            id: emitter
            enabled: false
            anchors.centerIn: parent
            lifeSpan: 300
            lifeSpanVariation: 10
            velocity: AngleDirection{magnitude: 500; magnitudeVariation: 80; angleVariation: 360}
        }
        ItemParticle {
            delegate: Rectangle {
                width: coverArea.width/15 + Math.random() * (coverArea.width/10)
                height: width
                readonly property real r: 0.3 + Math.random() * .7
                color: Qt.rgba(r, r, r, 1)
                rotation: Math.random() * 360
            }
        }
    }
    Image {
        id: smoke
        opacity: 0.75
        source: theWorld.resource("visual/explosion.png")
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        readonly property real time: 200
        SequentialAnimation {
            running: true
            ParallelAnimation {
                NumberAnimation { target: smoke; property: "width"; duration: smoke.time; to: smoke.parent.width * 2;}
                NumberAnimation { target: smoke; property: "height"; duration: smoke.time; to: smoke.parent.height * 2;}
                NumberAnimation { target: smoke; property: "opacity"; duration: smoke.time; to: 0.8; }
            }
            NumberAnimation { target: smoke; property: "opacity"; duration: smoke.time * 3; to: 0; }
            onRunningChanged: if (!running) coverArea.finished()
        }
    }
}
