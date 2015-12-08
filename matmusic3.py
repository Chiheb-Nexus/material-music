import sys

from PyQt5.QtCore import pyqtProperty, QCoreApplication, QObject, QUrl, QAbstractListModel, QModelIndex, pyqtSlot
from PyQt5.QtQml import qmlRegisterType, QQmlComponent, QQmlEngine
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtQuick import QQuickView

class ThingWrapper(QObject):
	def __init__(self, thing, parent=None):
		super().__init__(parent)
		QObject.__init__(self)
		self._thing = thing

	@pyqtProperty('QString')
	def _name(self):
		return str(self._thing)

class ThingListModel(QAbstractListModel):
	COLUMNS = ('thing',)
	def __init__(self, things, parent=None):
		super().__init__(parent)
		QAbstractListModel.__init__(self)
		self._things = things
		#self.setRoleNames(dict(enumerate(ThingsListModel.COLUMNS)))

	def rowCount(self, parent=QModelIndex()):
		return len(self._things)

	def data(self, index, role):
		if index.isValid() and role == ThingListModel.COLUMNS.index('thing'):
			return self._index[index.row()]
		return None

class Controller(QObject):
	@pyqtSlot(QObject)
	def thingSelected(self, wrapper):
		print('User Clicked: ', wrapper._thing.name)
		if wrapper._thing.number > 10:
			print("Number greater than 10")

class Person(object):
	def __init__(self, name, number):
		self.name = name
		self.number = number

	def _str(self):
		return 'Person %s (d)' (self.name, self.number)

people = [
	Person('Nick', 3),
	Person('Wally', 4),
	Person('Luke Skywalker', 22)
]

app = QApplication(sys.argv)

m = QMainWindow()

things = [ThingWrapper(thing) for thing in people]
controller = Controller()
thingList = ThingListModel(things)

# Create a QML engine.
engine = QQmlEngine()

# Create a component factory and load the QML script.
component = QQmlComponent(engine)
component.loadUrl(QUrl('main.qml'))

# Create an instance of the component.
person = component.create()
app.exec_()
