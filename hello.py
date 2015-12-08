#!/usr/bin/env python
# -*- coding: utf-8 -*-

from os.path import expanduser

def world():
    return "Hello World"

def home():
    home = expanduser("~")
    nh = str(home).replace('\\', '/').replace('C:', '')
    return str(nh + '/Music')

