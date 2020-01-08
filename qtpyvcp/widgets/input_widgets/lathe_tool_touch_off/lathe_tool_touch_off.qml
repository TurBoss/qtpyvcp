import QtQuick 2.7
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Rectangle {
    visible: true
    width: 1024
    clip: false
    transformOrigin: Item.Center
    height: 600
    color: "#919191"
    border.color: "#00000000"

    Image {
        id: holder
        x: 0
        y: 140
        width: 302
        height: 321
        fillMode: Image.PreserveAspectCrop
        z: 0
        rotation: 0
        transformOrigin: Item.Center
        source: "images/lathe_chuck_stock.png"
    }

    Row {
        id: upper_row
        x: 308
        y: -89
        width: 459
        height: 336
        spacing: 20; // a simple layout do avoid overlapping

            Repeater {
                id: upper_tools
                model: 5; // just define the number you want, can be a variable too

                delegate:
                    Image {
                        x: 380
                        y: 0
                        width: 50
                        height: 200
                        fillMode: Image.PreserveAspectFit
                        z: 0
                        rotation: 0
                        transformOrigin: Item.Center
                        state: "released"
                        source: "images/lathe_center_turning_rp_bs.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                tool_selected(upper_tools.itemAt(index), "upper", index)
                            }
                        }
                        states: [
                            State {
                                name: "hidden"
                                PropertyChanges { target: upper_tools.itemAt(index); x: 70*index ; y: -80 }
                            },
                            State {
                                name: "released"
                                PropertyChanges { target: upper_tools.itemAt(index); x: 70*index ; y: 0 }
                            },
                            State {
                                name: "selected"
                                PropertyChanges { target: upper_tools.itemAt(index); x: 0; y: 100 }
                            }
                        ]
                        transitions: Transition {
                            NumberAnimation{ properties: "x,y"; easing.type: Easing.OutExpo }
                        }
                   }
            }
        }

    Row {
        id: right_row
        x: 308
        y: 351
        width: 467
        height: 389
        spacing: 20; // a simple layout do avoid overlapping

            Repeater {
                id: lower_tools
                model: 5; // just define the number you want, can be a variable too

                delegate:
                    Image {
                        x: 380
                        y: 0
                        width: 50
                        height: 200
                        fillMode: Image.PreserveAspectFit
                        z: 0
                        rotation: 0
                        transformOrigin: Item.Center
                        state: "released"
                        source: "images/lathe_center_turning_fp_ts.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                tool_selected(lower_tools.itemAt(index), "lower", index)
                            }
                        }
                        states: [
                            State {
                                name: "hidden"
                                PropertyChanges { target: lower_tools.itemAt(index); x: 70*index ; y: +200 }
                            },
                            State {
                                name: "released"
                                PropertyChanges { target: lower_tools.itemAt(index); x: 70*index; y: 100 }
                            },
                            State {
                                name: "selected"
                                PropertyChanges { target: lower_tools.itemAt(index); x: 0; y: 0 }
                            }
                        ]
                        transitions: Transition {
                            NumberAnimation{ properties: "x,y"; easing.type: Easing.OutExpo }
                        }
                   }
            }
        }

    Column {
        id: right_column
        x: 308
        y: 166
        width: 199
        height: 269
        spacing: 20; // a simple layout do avoid overlapping

            Repeater {
                id: right_tools
                model: 5; // just define the number you want, can be a variable too

                delegate:
                    Image {
                        x: 0
                        y: 0
                        width: 200
                        height: 38
                        fillMode: Image.PreserveAspectFit
                        z: 0
                        rotation: 0
                        transformOrigin: Item.Center
                        state: "released"
                        source: "images/lathe_internal_threading_bs.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                tool_selected(right_tools.itemAt(index), "right", index)
                            }
                        }
                        states: [
                            State {
                                name: "hidden"
                                PropertyChanges { target: right_tools.itemAt(index); x: 600 ; y: 58*index }
                            },
                            State {
                                name: "released"
                                PropertyChanges { target: right_tools.itemAt(index); x: 500; y: 58*index }
                            },
                            State {
                                name: "selected"
                                PropertyChanges { target: right_tools.itemAt(index); x: 0; y: 100 }
                            }
                        ]
                        transitions: Transition {
                            NumberAnimation{ properties: "x,y"; easing.type: Easing.OutExpo }
                        }
                    }
            }
        }


    function set_images(element, pics) {
        for (var i = 0; i < 5; i++) {
            element.itemAt(i).source = pics[i];
        }
    }

    Component.onCompleted: {

        var upper_tool_pics = [
            "images/lathe_lh_turning_rp_bs.png",
            "images/lathe_center_turning_rp_bs.png",
            "images/lathe_rh_turning_rp_bs.png",
            "images/lathe_lh_threading_rp_ts.png",
            "images/lathe_rh_parting_rp_bs.png"
        ];

        var lower_tool_pics = [
            "images/lathe_lh_turning_fp_ts.png",
            "images/lathe_center_turning_fp_ts.png",
            "images/lathe_rh_turning_fp_ts.png",
            "images/lathe_rh_threading_fp_ts.png",
            "images/lathe_parting_fp_ts.png"
        ];

        var right_tool_pics = [
            "images/lathe_internal_threading_bs.png",
            "images/lathe_internal_boring_bs.png",
            "images/lathe_internal_drilling_ts.png",
            "images/lathe_internal_boring_ts.png",
            "images/lathe_internal_threading_ts.png"
        ];

        set_images(upper_tools, upper_tool_pics);
        set_images(lower_tools, lower_tool_pics);
        set_images(right_tools, right_tool_pics);
    }

    function tool_selected(tool, group, index) {

        handler.selected_tool(group, index)

        if (tool.state === "selected") {
            for (var i = 0; i < 5; i++){
                upper_tools.itemAt(i).state = "released"
                lower_tools.itemAt(i).state = "released"
                right_tools.itemAt(i).state = "released"
            }
        }
        else {
            for (var i = 0; i < 5; i++){
                upper_tools.itemAt(i).state = "hidden"
                lower_tools.itemAt(i).state = "hidden"
                right_tools.itemAt(i).state = "hidden"
            }
            tool.state  = "selected"
        }
    }

    Connections {
        target: handler

        onPocketSig: {
            var pocket = 0

            if ((pocket_number >= 0) && (pocket_number <= 4)){
                pocket = pocket_number
                tool_selected(upper_tools.itemAt(pocket))
            }
            else if ((pocket_number >= 5) && (pocket_number <= 9)){
                pocket = pocket_number - 5
                tool_selected(lower_tools.itemAt(pocket))
            }
            else if ((pocket_number >= 10) && (pocket_number <= 14)){
                pocket = pocket_number - 10
                tool_selected(right_tools.itemAt(pocket))
            }

        }
    }
}
