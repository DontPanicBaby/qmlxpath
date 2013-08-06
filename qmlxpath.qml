import QtQuick 1.1

Rectangle {
    signal loadpage(string url, string method)
    signal xpathchanged(string xpath)
    signal copyclipboard(string xpath)
    signal form_move(int x, int y)
    signal waitexit

    property string method: "get"

    function updateVariants( vlist ){
        variants.model = vlist
        if(vlist.length != 0) variants.visible = true
    }

    width: 600
    height: 360
    color: "#265569"
    radius: 21
    MouseArea {
        x: 0
        y: 0
        property variant previousPosition
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        onPressed: {previousPosition = Qt.point(mouseX, mouseY)}
        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton) {
                var dx = mouseX - previousPosition.x
                var dy = mouseY - previousPosition.y
                form_move(dx, dy)
            }
         }
    }

    Text {
        id: xpath_text
        x: 7
        y: 150
        color: "#a2a0a0"
        text: qsTr("xpath")
        verticalAlignment: Text.AlignVCenter
        font.family: "Impact"
        font.pixelSize: 27
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
                id: xpath_rec
                x: 74
                y: 148
                width: 453
                height: 40
                color: "#00000000"
                radius: 12
                border.width: 2
                smooth: true
                border.color: "#a2a0a0"
                TextInput {
                    id: text_xpath
                    x: 12
                    y: 8
                    width: 430
                    height: 24
                    color: "#333232"
                    text: "//"
                    selectedTextColor: "#8b4444"
                    font.bold: true
                    smooth: false
                    font.italic: false
                    selectionColor: "#409153"
                    font.family: "Nimbus Mono L"
                    font.pixelSize: 21
                    onTextChanged: xpathchanged(text_xpath.text)
                }
    }

    Rectangle {
        id: get
        x: 74
        y: 73
        width: 87
        height: 36
        color: "#00000000"

        Text {
            id: get_label
            x: 27
            y: 2
            color: "#a2a0a0"
            text: qsTr("GET")
            verticalAlignment: Text.AlignVCenter
            font.family: "Impact"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 27
        }
        MouseArea {
            id: get_ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: { get_choice.color = "#bb403e"; post_choice.color = "#00000000"; method="get";}
        }
        Rectangle {
            id: get_choice
            x: 3
            y: 9
            width: 20
            height: 20
            color: "#bb403e"
            radius: 99
            smooth: true
            border.width: 1
            border.color: "#a2a0a0"
        }
    }

    Rectangle {
        id: post
        x: 74
        y: 106
        width: 87
        height: 36
        color: "#00000000"
        Text {
            id: post_label
            x: 27
            y: 2
            color: "#a2a0a0"
            text: qsTr("POST")
            verticalAlignment: Text.AlignVCenter
            font.family: "Impact"
            font.pixelSize: 27
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            id: post_ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: { post_choice.color = "#bb403e"; get_choice.color = "#00000000"; method="post";}
        }
        Rectangle {
            id: post_choice
            x: 3
            y: 9
            width: 20
            height: 20
            color: "#00000000"
            radius: 99
            border.width: 1
            smooth: true
            border.color: "#a2a0a0"
        }
    }

    Rectangle {
        id: result
        x: 20
        y: 206
        width: 554
        height: 130
        radius: 12
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#00ffffff"
            }

            GradientStop {
                position: 0.490
                color: "#1ed3e8d5"
            }

            GradientStop {
                position: 1
                color: "#00ffffff"
            }
        }
        border.width: 2
        smooth: true
        border.color: "#a2a0a0"

        TextEdit {
            id: result_edit
            x: 12
            y: 5
            width: 530
            height: 118
            color: "#96000000"
            text: qsTr("result")
            font.bold: true
            font.family: "Nimbus Mono L"
            cursorVisible: true
            readOnly: true
            font.pixelSize: 16
        }
    }

    Rectangle {
        id: exit_btn
        x: 571
        y: 6
        width: 20
        height: 20
        color: "#ad3e3e"
        radius: 99
        border.color: "#a2a0a0"
        scale: ex_btn_ma.containsMouse ? 1.2 : 1.0
        Text {
            id: exit_label
            x: 8
            y: 2
            width: 4
            height: 17
            color: "#a2a0a0"
            text: qsTr("X")
            font.family: "KacstPen"
            font.pixelSize: 13
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            id: ex_btn_ma
            hoverEnabled: true
            anchors.fill: parent
            onClicked: waitexit()
        }
        smooth: true
        border.width: 2
    }

    Rectangle {
        id: url_rec
        x: 72
        y: 30
        width: 420
        height: 40
        color: "#00000000"
        radius: 12
        smooth: true
        border.width: 2
        border.color: "#a2a0a0"

        TextInput {
            id: input_url
            x: 12
            y: 8
            width: 395
            height: 24
            color: "#000000"
            text: qsTr("http://")
            font.family: "Courier New"
            font.italic: true
            smooth: false
            selectionColor: "#000000"
            font.pixelSize: 21
            onActiveFocusChanged: { if(activeFocus) input_url.text=""}


        }

    }

    Image {
        id: clipboard
        x: 536
        y: 152
        width: 33
        height: 33
        source: "clipboard.png"
        scale:  clipboard_btn_ma.containsMouse ? 1.2 : 1.0
        MouseArea {
            id: clipboard_btn_ma
            hoverEnabled: true
            anchors.fill: parent
            onClicked: copyclipboard( text_xpath.text )
        }
    }

    Rectangle {
        id: go_btn
        x: 506
        y: 30
        width: 40
        height: 40
        color: "#ad3e3e"
        radius: 99
        smooth: true
        border.width: 2
        border.color: "#a2a0a0"

        Text {
            id: go_text
            x: 5
            y: 3
            color: "#a2a0a0"
            text: qsTr("GO")
            font.family: "Impact"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 27
        }
        scale:  btn_ma.containsMouse ? 1.2 : 1.0
        MouseArea {
            id: btn_ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: loadpage(input_url.text, method)
        }
    }

    Text {
        id: url_text
        x: 20
        y: 33
        text: qsTr("URL")
        font.family: "Impact"
        color: "#a2a0a0"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 27
    }

    ListView {
        id: variants
        x: 74
        y: 180
        width: 453
        height: 135
        keyNavigationWraps: true
        highlightRangeMode: ListView.StrictlyEnforceRange
        interactive: false
        boundsBehavior: Flickable.DragAndOvershootBounds
        contentHeight: 135
        clip: false
        smooth: true
        visible: false
        currentIndex: 0
        flickableDirection: Flickable.VerticalFlick
        delegate: Item {
            x: 15
            height: 20
            width: parent.width
            Rectangle{
                color: "#265569"
                anchors.fill: parent
                Text {
                    text: modelData
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var split_xpath = text_xpath.text.split('/');
                        split_xpath[split_xpath.length - 1] = modelData;
                        text_xpath.text =  split_xpath.join("/");
                        variants.visible = false;
                    }
                }
            }

        }

    }


}
