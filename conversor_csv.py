#!/usr/bin/env python
# coding: utf-8

import csv
import pandas as pd
import os

files = [f for f in os.listdir('datos/all') if  f.endswith(".dat")]

for file in files:

	dat_file = r"datos/all/"+file    
	with open(dat_file, 'r') as f:
	    text = f.read()

	subtext=text.split(' ')
	for x in subtext:
	    x.replace(' ','') 
	    
	subtext=[sub for sub in subtext if sub !='']

	first_index=subtext[0]
	subtext.remove(first_index)

	data={}

	index=first_index
	components=[]

	for element in subtext:
	    if '\n' in element:
	        components.append(float(element.split('\n')[0].replace(',', '.')))
	        data[index]=components
	        components=[]
	        index=element.split('\n')[1]
	    else:
	        components.append(float(element.replace(',', '.')))   

	df=pd.DataFrame.from_dict(data)
	df.to_csv('data/initial_data/'+file.replace('.dat','')+'.csv')
