import Qt 4.7
Rectangle {
    //Описание сигнала
    signal wantquit

    property int qwX: 0;  property int qwY: 0
    property int owX: 0;    property int owY: 0
    property bool first: true
    width: 300
    height: 200

/*Функция передающая текст для вывода текстовым виджетом*/
    function updateMessage(text) {
        messageText.text = text
    }
    anchors.fill: parent; color: "#4d4646"

//Текстовый виджет

 //Обработка событий вызванных мышью
    MouseArea {
        anchors.fill: parent

        onClicked:
        {

        //Взятие текста методом класса файла python
        messageText.text = someone.some_id

        first = true
        }

        onPositionChanged:
        {
        owX = first? mouseX : owX
        owY = first? mouseY : owY
        first = false
        qwX+=mouseX-owX
        qwY+=mouseY-owY

        //Перемещение окна
        main.form_move(qwX, qwY)
        }

                  onDoubleClicked:
        {
        //Отправка сигнала
        wantquit()
        }
    }

    Rectangle {
        id: rectangle1
        x: 6
        y: 20
        width: parent.width-20
        height: 28
        color: "#ffffff"
        radius: 25
        opacity: 0.8
        border.width: 2
        border.color: "#bb0e0e"

        Text {
            id: text1
            x: 21
            y: 7
            width: 25
            height: 15
            text: qsTr("URL")
            font.pixelSize: 12
        }

        TextInput {
            id: text_input1
            x: 51
            y: 6
            width: 224
            height: 22
            color: "#6fa869"
            text: qsTr("Text")
            font.pointSize: 15
            font.bold: true
            echoMode: TextInput.Normal
            horizontalAlignment: TextInput.AlignLeft
            transformOrigin: Item.Center
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            anchors.top: parent.top
            anchors.topMargin: 6
            font.pixelSize: 12
        }
    }
}
