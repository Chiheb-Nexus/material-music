import QtQuick 2.4
import Material 0.1
import Material.ListItems 0.1 as ListItem
import QtMultimedia 5.5
import Qt.labs.folderlistmodel 2.1
import "musicId.js" as Global

ApplicationWindow {
    Timer {
        id: myTimer
             interval: 100; running: false; repeat: false
             onTriggered: {
                 if(playMusic.metaData.albumArtist){
                     var artist = playMusic.metaData.albumArtist + ' - '
                 }else{
                     var artist = ''
                 }
                 if(playMusic.metaData.title){
                     var title = playMusic.metaData.title
                 }else{
                     folderModel.folder = Global.currentFolder
                     var title = folderModel.get(Global.songId, 'fileName')
                 }

                 page.title = artist + title
                 demo.title = title
         }
    }

    Timer {
        id: musicWithFolder
            interval: 100; running: false; repeat: false
            onTriggered: {
                Qt.resolvedUrl("AllMusicDemo.qml")
                selectedComponent = "All Music"
            }
    }

    Timer {
        id: nextTimer
             interval: 200; running: false; repeat: false
             onTriggered: {
                 if(playMusic.source){
                     folderModel.folder = Global.currentFolder

                     if(Global.songId + 1 == folderModel.count){

                         var folder = folderModel.folder
                         folderModel.folder = Global.currentFolder
                         var currentSong = playMusic.source
                         var nextFile = Global.currentFolder + '/' + folderModel.get(0, 'fileName')
                         playMusic.source = nextFile
                         playMusic.play()
                         Global.songId = 1;

                     }else{
                         var folder = folderModel.folder
                         folderModel.folder = Global.currentFolder
                         var currentSong = playMusic.source
                         var nextFile = Global.currentFolder + '/' + folderModel.get(Global.songId + 1, 'fileName')
                         playMusic.source = nextFile
                         playMusic.play()
                         Global.songId++;
                     }
                 }
         }
    }


    Audio {
            id: playMusic
            onStatusChanged: {
                            if (status == MediaPlayer.EndOfMedia) {
                                button.pressed = false
                                button.text = i18n.tr("Play")
                            }
                        }
            onSourceChanged: {

                //demo.title = playMusic.metaData.title
                myTimer.start()
            }


        }

    FolderListModel {
        id: folderModel
        folder: {
            console.log('current folder is: ', Global.currentFolder)
            if(Global.currentFolder){
                return Qt.resolvedUrl(Global.currentFolder)
            }else{
                return "/home/nick/Music"
            }
        }
        nameFilters: [ "*.mp3", "*.wav" ]
        showDotAndDotDot: false
        showFiles: true
    }

    FolderListModel {
        id: albumFolder
        folder: "/home/nick/Music"
    }

    id: demo
    title: "Music"
    height: Units.dp(700)
    width: Units.dp(900)

    // Necessary when loading the window from C++
    visible: true

    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["red"]["A200"]
        tabHighlightColor: "white"
    }



    property var sidebar: [
            "Albums", "Artists", "List Items"
    ]

    property var basicComponents: [
            "Button", "CheckBox", "Progress Bar", "Radio Button",
            "Slider", "Switch", "TextField"
    ]

    property var compoundComponents: [
            "Bottom Sheet", "Dialog", "Forms", "List Items", "Page Stack", "Time Picker", "Date Picker"
    ]

    property var sections: [ sidebar ]

    property var sectionTitles: [ "Collection" ]

    property string selectedComponent: sidebar[0]

    initialPage: TabbedPage {
        id: page

        title: "Music"

        Rectangle {
            height:200
            width:parent
            color: theme.primaryColor

        }

        actionBar.maxActionCount: navDrawer.enabled ? 3 : 4

        //Key Navigation
        Keys.onSpacePressed: {
            if(playMusic.source){
                if (playMusic.playbackState == 1){
                    playMusic.pause()
                    button.iconName = 'av/play_arrow'
                    button.name = "Play"
                }
                else{
                    playMusic.play()
                    button.iconName = 'av/pause'
                    button.name = "Pause"
                }
            }
        }


        Keys.onRightPressed: {
            if(playMusic.source){
                folderModel.folder = Global.currentFolder

                if(Global.songId + 1 == folderModel.count){

                    var folder = folderModel.folder
                    folderModel.folder = Global.currentFolder
                    var currentSong = playMusic.source
                    var nextFile = Global.currentFolder + '/' + folderModel.get(0, 'fileName')
                    playMusic.source = nextFile
                    playMusic.play()
                    Global.songId = 1;

                }else{
                    var folder = folderModel.folder
                    folderModel.folder = Global.currentFolder
                    var currentSong = playMusic.source
                    var nextFile = Global.currentFolder + '/' + folderModel.get(Global.songId + 1, 'fileName')
                    playMusic.source = nextFile
                    playMusic.play()
                    Global.songId++;
                }
            }
        }

        Keys.onLeftPressed: {
            if(playMusic.source && Global.songId != 0){
                var folder = folderModel.folder
                folderModel.folder = Global.currentFolder
                var currentSong = playMusic.source
                var nextFile = Global.currentFolder + '/' + folderModel.get(Global.songId - 1, 'fileName')
                playMusic.source = nextFile
                playMusic.play()
                Global.songId--;
            }
        }

        actions: [

            Action {
                id: playPrev
                iconName: "av/skip_previous"
                name: "Previous"
                onTriggered: {
                    var folder = folderModel.folder
                    folderModel.folder = Global.currentFolder
                    var currentSong = playMusic.source
                    var nextFile = Global.currentFolder + '/' + folderModel.get(Global.songId - 1, 'fileName')
                    playMusic.source = nextFile
                    playMusic.play()
                    Global.songId--;

                }

            },

            Action {

                id: button
                iconName: "av/play_circle_filled"
                name: "Play"
                onTriggered: {
                    //showError("Is paused?", "this is paused? " + playMusic.playbackState, "Close", true)

                    if (playMusic.playbackState == 1){
                                        playMusic.pause()
                                        button.iconName = 'av/play_arrow'
                                        button.name = "Play"
                                    }
                                    else{
                                        playMusic.play()
                                        button.iconName = 'av/pause'
                                        button.name = "Pause"
                                   }
                }
            },

            Action {
                id: playNext
                iconName: "av/skip_next"
                name: "Next"
                onTriggered: {
                    if(Global.songId == folderModel.count){
                        var folder = folderModel.folder
                        folderModel.folder = Global.currentFolder
                        var currentSong = playMusic.source
                        var nextFile = Global.currentFolder + '/' + folderModel.get(1, 'fileName')
                        playMusic.source = nextFile
                        playMusic.play()
                        Global.songId = 1;

                    }else{
                        var folder = folderModel.folder
                        folderModel.folder = Global.currentFolder
                        var currentSong = playMusic.source
                        var nextFile = Global.currentFolder + '/' + folderModel.get(Global.songId + 1, 'fileName')
                        playMusic.source = nextFile
                        playMusic.play()
                        Global.songId++;
                    }

                }

            },

            Action {
                iconName: "action/accessibility"
                name: "Settings"
                hoverAnimation: true
            },

            Action {
                iconName: "alert/warning"
                name: "THIS SHOULD BE HIDDEN!"
                visible: false
            },

            Action {
                iconName: "action/language"
                name: "Language"
                enabled: false
            },

            Action {
                iconName: "action/account_circle"
                name: "Accounts"
            }
        ]

        backAction: navDrawer.action

        NavigationDrawer {
            id: navDrawer

            enabled: page.width < Units.dp(600)

            Flickable {
                anchors.fill: parent

                contentHeight: Math.max(content.implicitHeight, height)

                Column {
                    id: content
                    anchors.fill: parent

                    Repeater {
                        model: sections

                        delegate: Column {
                            width: parent.width

                            ListItem.Subheader {
                                text: sectionTitles[index]
                            }

                            Repeater {
                                model: modelData
                                delegate: ListItem.Standard {
                                    text: modelData
                                    selected: modelData == demo.selectedComponent
                                    onClicked: {
                                        demo.selectedComponent = modelData
                                        navDrawer.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Repeater {
            model: !navDrawer.enabled ? sections : 0

            delegate: Tab {
                title: sectionTitles[index]

                property string selectedComponent: modelData[0]
                property var section: modelData

                sourceComponent: tabDelegate
            }
        }

        Loader {
            anchors.fill: parent
            sourceComponent: tabDelegate

            property var section: []
            visible: navDrawer.enabled
        }
    }

    Dialog {
        id: colorPicker
        title: "Pick color"

        positiveButtonText: "Done"

        MenuField {
            id: selection
            model: ["Primary color", "Accent color", "Background color"]
            width: Units.dp(160)
        }

        Grid {
            columns: 7
            spacing: Units.dp(8)

            Repeater {
                model: [
                    "red", "pink", "purple", "deepPurple", "indigo",
                    "blue", "lightBlue", "cyan", "teal", "green",
                    "lightGreen", "lime", "yellow", "amber", "orange",
                    "deepOrange", "grey", "blueGrey", "brown", "black",
                    "white"
                ]

                Rectangle {
                    width: Units.dp(30)
                    height: Units.dp(30)
                    radius: Units.dp(2)
                    color: Palette.colors[modelData]["500"]
                    border.width: modelData === "white" ? Units.dp(2) : 0
                    border.color: Theme.alpha("#000", 0.26)

                    Ink {
                        anchors.fill: parent

                        onPressed: {
                            switch(selection.selectedIndex) {
                                case 0:
                                    theme.primaryColor = parent.color
                                    break;
                                case 1:
                                    theme.accentColor = parent.color
                                    break;
                                case 2:
                                    theme.backgroundColor = parent.color
                                    break;
                            }
                        }
                    }
                }
            }
        }

        onRejected: {
            // TODO set default colors again but we currently don't know what that is
        }
    }

    Component {
        id: tabDelegate

        Item {
            Sidebar {
                id: sidebar

                expanded: !navDrawer.enabled

                Column {
                    width: parent.width

                    Repeater {
                        model: section
                        delegate: ListItem.Standard {
                            text: modelData
                            selected: modelData == selectedComponent
                            onClicked: {
                                console.log(modelData)
                                selectedComponent = modelData
                                folderModel.folder = '/home/nick/Music'
                            }

                        }
                    }
                }
            }
            Flickable {
                id: flickable
                anchors {
                    left: sidebar.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                clip: true
                contentHeight: Math.max(example.implicitHeight + 40, height)
                Loader {
                    id: example
                    anchors.fill: parent
                    asynchronous: true
                    visible: status == Loader.Ready
                    // selectedComponent will always be valid, as it defaults to the first component
                    source: {
                        if (navDrawer.enabled) {
                            return Qt.resolvedUrl("%1Demo.qml").arg(demo.selectedComponent.replace(" ", ""))
                        } else {
                            return Qt.resolvedUrl("%1Demo.qml").arg(selectedComponent.replace(" ", ""))
                        }
                    }
                }

                ProgressCircle {
                    anchors.centerIn: parent
                    visible: example.status == Loader.Loading
                }
            }
            Scrollbar {
                flickableItem: flickable
            }
        }
    }
}
