# -*- coding: utf-8 -*-
'''
Created on 05.08.2013

@author: roman
'''
from PyQt4 import QtCore, QtGui, Qt, QtDeclarative
import sys
app = QtGui.QApplication(sys.argv)

class Someone(QtCore.QObject):
    def __init__(self):
        QtCore.QObject.__init__(self)
        self.my_id = QtCore.QString("I'm first")

    @QtCore.pyqtProperty(QtCore.QString) #(1)
    def some_id(self):
        return self.my_id
        
so = Someone()

class I_will_be_form(QtDeclarative.QDeclarativeView):    
    inited = QtCore.pyqtSignal(str) 
    def __init__(self, parent=None):
        QtDeclarative.QDeclarativeView.__init__(self, parent)
        
    
        self.setWindowFlags(Qt.Qt.FramelessWindowHint) 
         
        self.setSource(QtCore.QUrl.fromLocalFile('qmlxpath.qml'))
        self.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
        self.setGeometry(100, 100, 600, 240)
        
        self.signal_func_Qml()
        self.signalThis()
        self.slot()
        self.prop()
   
    def signal_func_Qml(self):     
        print "Qml's signal"
        root = self.rootObject() #(1)
        root.wantquit.connect(app.quit) #(2)
        root.updateMessage(QtCore.QString('From root')) #(3)
    
    def signalThis(self):   
        print "Signal of PyQt"  
        root = self.rootObject() #(1)
        self.inited.connect(root.updateMessage) #(2)
        self.inited.emit(QtCore.QString("I'm ready!"))  

    def slot(self):     
        print "Property"  
        self.engine().rootContext().setContextObject(self) #(1)
        self.engine().rootContext().setContextProperty('main', self) #(2)  
        
    @QtCore.pyqtSlot(int, int)    #(1)
    def form_move(self, x, y):
        self.move(x, y) 

    def prop(self):     
        print "Slot "
        self.engine().rootContext().setContextProperty('someone', so)
        

Iwbf = I_will_be_form()
Iwbf.show() 
sys.exit(app.exec_())     