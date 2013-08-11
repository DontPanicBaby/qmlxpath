# -*- coding: utf-8 -*-
'''
Created on 05.08.2013

@author: roman
'''
from PyQt4 import QtCore, QtGui, Qt, QtDeclarative
import sys, re
import urllib2

import lxml.html

app = QtGui.QApplication(sys.argv)




class QMLXPath(QtDeclarative.QDeclarativeView):    
    variants = QtCore.pyqtSignal(list) 
    results_edit = QtCore.pyqtSignal(str) 
    alert = QtCore.pyqtSignal(str)
    def __init__(self, parent=None):
        QtDeclarative.QDeclarativeView.__init__(self, parent)
        
        self.setSource(QtCore.QUrl.fromLocalFile('qmlxpath.qml'))
        self.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)
        self.setGeometry(100, 100, 600, 360)        
        self.setStyleSheet("background:transparent;");
        self.setAttribute(Qt.Qt.WA_TranslucentBackground) 
        self.setWindowFlags(Qt.Qt.FramelessWindowHint)

        self.doc = None

        
        self.initbinds()

   
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
        self.alert.connect(root.alert_msg)
        
    def loadpage(self, url, method, params=""):
        try:
            page = urllib2.urlopen(str(url)) if method == 'get' else urllib2.urlopen(str(url), params)
        except IOError:
            pass
        else: self.doc = lxml.html.fromstring( page.read().decode('utf-8') )
        self.alert.emit('Page was loaded')
        
    def xpathchanged(self, qxpath):
        if not self.doc: 
            self.alert.emit('Page not load')
            return
        xpath = str(qxpath)
        split_xpath = xpath.split('/')
        last = split_xpath[-1]
        last_word = re.split('\s|\[|\]', last)[-1]
        parent_xpath = '/'.join(split_xpath[:-1])
        variants = []
        for el in self.doc.xpath(parent_xpath + '/*'):
            if el.tag.title().lower().startswith(last):
                tag = el.tag.title().lower()
                if tag not in variants: variants.append( tag ) 
            if last_word.startswith('@') and hasattr( el, 'items'):
                for attr, _ in  el.items():
                    
                    if not attr.startswith(last_word[1:]): continue
                    xattr = '@' + attr
                    if xattr not in variants: variants.append( xattr ) 
        self.variants.emit(variants)  
        try:
            ob = self.doc.xpath(str(xpath))
            body = '\n'.join([ str( i ).strip() for i in ob ])
            self.results_edit.emit(body.decode('utf-8')) 
        except Exception, e: 
            pass
        
    def copy2clipboard(self, xpath):
        app.clipboard().setText(xpath)
        
    def form_move(self, x, y):
        self.move(self.x() + x, self.y() +y) 
        
        
        

Iwbf = QMLXPath()
Iwbf.show() 
sys.exit(app.exec_())     

