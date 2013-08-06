# -*- coding: utf-8 -*-
'''
Created on 05.08.2013

@author: roman
'''
from PyQt4 import QtCore, QtGui, Qt, QtDeclarative
import sys
import urllib2

import lxml.html

app = QtGui.QApplication(sys.argv)




class QMLXPath(QtDeclarative.QDeclarativeView):    
    variants = QtCore.pyqtSignal(list) 
    results_edit = QtCore.pyqtSignal(str) 
    def __init__(self, parent=None):
        QtDeclarative.QDeclarativeView.__init__(self, parent)
        
        self.setSource(QtCore.QUrl.fromLocalFile('qmlxpath.qml'))
        self.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
        self.setGeometry(100, 100, 600, 360)        
        self.setStyleSheet("background:transparent;");
        self.setAttribute(Qt.Qt.WA_TranslucentBackground) 
        self.setWindowFlags(Qt.Qt.FramelessWindowHint)

         

        
        self.initbinds()
        #self.signal_func_Qml()
        #self.signalThis()
        #self.slot()
        #self.prop()
   
    def initbinds(self): 
        root = self.rootObject() 
        root.loadpage.connect(self.loadpage)
        root.xpathchanged.connect(self.xpathchanged)
        root.copyclipboard.connect(self.copy2clipboard)
        root.form_move.connect(self.form_move)
        root.waitexit.connect(app.quit)
        
        #signals
        self.variants.connect(root.updateVariants) #(2)
        self.variants.emit([])  
        self.results_edit.connect(root.updateResult)
        
    def loadpage(self, url, method):
        try:
            page = urllib2.urlopen(str(url)) if method == 'get' else urllib2.urlopen(str(url), {})
        except IOError:
            pass
        else: self.doc = lxml.html.fromstring( page.read() )
        
    def xpathchanged(self, qxpath):
        xpath = str(qxpath)
        print xpath
        split_xpath = xpath.split('/')
        last = split_xpath[-1]
        parent_xpath = '/'.join(split_xpath[:-1])
        variants = []
        for el in self.doc.xpath(parent_xpath + '/*'):
            if el.tag.title().lower().startswith(last):
                tag = el.tag.title().lower()
                if tag not in variants: variants.append( tag ) 
        self.variants.emit(variants)  
        try:
            ob = self.doc.xpath(str(xpath))
            body = '\n'.join([ str(i) for i in ob ])
            self.results_edit.emit(body) 
        except: 
            pass
        
    def copy2clipboard(self, xpath):
        app.clipboard().setText(xpath)
        
    def form_move(self, x, y):
        self.move(self.x() + x, self.y() +y) 
        
        
        

Iwbf = QMLXPath()
Iwbf.show() 
sys.exit(app.exec_())     

