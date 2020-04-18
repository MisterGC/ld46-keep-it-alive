// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file
import QtQuick 2.12

Item {
    property var gardens: []
    property var player: undefined
    property real gardenPercentage: 100.0
    property int maxEnergyGarden: 0
    property int timeElapsed: 0

    readonly property int seasonLength: 300
    readonly property real seasonPercentage: Math.round(timeElapsed * 100.0 / seasonLength)
    onSeasonPercentageChanged: {
        if (seasonPercentage >= 100) {
            theOneSecTimer.stop();
            seasonEnded();
        }
    }

    onPlayerChanged: {
        if (player) {
            player.energyChanged.connect(_onPlayerEnergyChanged);
            theOneSecTimer.start();
        }
        else {
            theOneSecTimer.stop();
            gardens=[];
            gardenPercentage=100.0;
            maxEnergyGarden=0;
            timeElapsed=0;
        }
    }


    signal playerDied()
    signal gardenDied()
    signal seasonEnded()

    Timer {
        id: theOneSecTimer
        interval: 1000
        Component.onCompleted: start()
        onTriggered: timeElapsed++
        repeat: true
    }

    onGardenPercentageChanged: {
        if (gardenPercentage <= 0) gardenDied()
    }

    function addGarden(garden) {
        gardens.push(garden);
        garden.energyChanged.connect(_onGardenEnergyChanged);
        maxEnergyGarden += garden.maxEnergy;
    }

    function _onGardenEnergyChanged() {
        let energy = 0;
        for (const g of gardens)
            energy += g.energy;
        gardenPercentage = Math.round((energy/maxEnergyGarden) * 100.0);
    }

    function _onPlayerEnergyChanged() {
        if (player.energy <= 0)
            playerDied();
    }

}
