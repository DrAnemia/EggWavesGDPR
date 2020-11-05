#!/usr/bin/env python
# coding: utf-8

# Genera 3 figures con las matrices de correlación de todos los sujetos.

import pandas as pd
import matplotlib.pyplot as plt

import os

f=plt.figure()
f.set_figheight(15)
f.set_figwidth(15)

path='data/initial_data/'

directory = os.listdir(path)
directory = [file for file in directory if '.csv' in file ]

for file in directory:	
	if 'AV3' in str(file):
	    df=pd.read_csv(path+file)
	    co=df.corr()
	    plt.subplot(6,3,(directory.index(file)+3)/3)
	    plt.title(str(file.split('_P300')[0]), x=1.7)
	    plt.matshow(co,fignum=False)

plt.show(f)
input()

plt.figure()
for file in directory:
	if 'AV4' in str(file):
	    df=pd.read_csv(path+file)
	    co=df.corr()
	    plt.subplot(6,3,(directory.index(file)+2)/3)
	    plt.title(str(file.split('_P300')[0]), x=1.7)
	    plt.matshow(co,fignum=False)

plt.show()
input()

plt.figure()
for file in directory:
	if 'AV5' in str(file):
	    df=pd.read_csv(path+file)
	    co=df.corr()
	    plt.subplot(6,3,(directory.index(file)+1)/3)
	    plt.title(str(file.split('_P300')[0]), x=1.7)
	    plt.matshow(co,fignum=False)    

plt.show()

