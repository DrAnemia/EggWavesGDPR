#!/usr/bin/env python
# coding: utf-8

# A partir de los daots iniciales se generan y guardan dataframes con las derivadas

from numpy import diff
import pandas as pd
import os

initial_path = '../../data/initial_data/'
destination_path = '../../data/derivatives/'
if not os.path.exists(destination_path):
		os.makedirs(destination_path)
		
files = [f for f in os.listdir(initial_path) if  f.endswith(".csv")]

for file in files:
    df = pd.read_csv(initial_path + file)
    df = df.drop(['Unnamed: 0'], axis=1)
    df_deriv = df.apply(lambda y: diff(y))
    df_deriv.to_csv(destination_path + 'Diff_' + file, index = False)
