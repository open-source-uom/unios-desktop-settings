import QtQuick

Rectangle {
    id: root
    color: "#202326"

    // ksplashqml sets this from 1 to 6 while Plasma starts
    property int stage

    Image {
        id: logo
        anchors.centerIn: parent
        source: "images/unios.png"
        width: 160
        height: 160
        sourceSize.width: 320
        sourceSize.height: 320
        fillMode: Image.PreserveAspectFit
        smooth: true
        opacity: 0
        Component.onCompleted: opacity = 1
        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        id: track
        anchors.top: logo.bottom
        anchors.topMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter
        width: 180
        height: 4
        radius: 2
        color: "#3a3e44"

        Rectangle {
            height: parent.height
            radius: parent.radius
            color: "#fcfcfc"
            width: parent.width * Math.min(root.stage, 6) / 6
            Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
        }
    }
}
