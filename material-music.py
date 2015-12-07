#!/usr/bin/python3
import sys

from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine
from PyQt5.QtWidgets import QApplication

def main():
	app = QApplication([])
	
	app.setSource('main.qml')
	app.setWindowTitle("Test")
	app.show()
	app.exec_()
	
if __name__ == '__main__':
	main()
