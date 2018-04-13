import numpy as np
import os
import csv
import pandas as pd
import math
#import matplotlib.pyplot as plt
#from pylab import rcParams
#from sklearn.model_selection import train_test_split
#from keras.models import Model, load_model
#from keras.layers import Input, Dense
#from keras.callbacks import ModelCheckpoint, TensorBoard
#from keras import regularizers
from pyspark import SparkFiles
from pyspark.mllib.linalg import Vectors


def main():
# there is some details with loading data, which we have to proceed ahead
	filename = "Datenbasis_Gefiltert.csv"
	path = "/home/sherry/Downloads/"
	df = pd.read_csv(path+filename, usecols=['Position', 'CoilNumber','ProgramNumber630','Banddicke1',
	'Banddicke2','Banddicke3','Banddicke','Impoc'])
	zrd=pd.read_csv(os.path.join(path,'Zuordnung.csv'),header=0,sep=',')
	zrd.rename(index=str,columns ={'programm_coil':'ProgramNumber630',
	'material gemaess SAP':'Material',
	'Hersteller/Schluessel':'Hersteller'},inplace = True)

	df=pd.merge(df, zrd, how='left', on=['ProgramNumber630'])
	df.dropna(axis=0, how='any',inplace=True)
	df.round(3)
	df.drop_duplicates(subset=['Position'],inplace=True)
	df.to_pickle(os.path.join(path,'Datenbasis_Gefiltert_zusammengefuehrt.csv'))
	#print medianValue('CV', 0.7, df)
	print (conValue('CV', 0.7, df))



   #Step1: the statistical analysing
def maxValue(provider, banddick, df):
    df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
    return [max(df_cv['Banddicke1']), max(df_cv['Banddicke2']), max(df_cv['Banddicke3'])]

def minValue(provider, banddick, df):
    df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
    return [min(df_cv['Banddicke1']), min(df_cv['Banddicke2']), min(df_cv['Banddicke3'])]

def meanValue(provider, banddick, df):
	df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
	return [df_cv['Banddicke1'].mean(), df_cv['Banddicke2'].mean(), df_cv['Banddicke3'].mean()]

def Quater(provider, banddick, df):
	# TODO: this function should be extended to Q2,Q3
	df_cv = df.loc[(df['Hersteller'] == provider) & (df['B802.11 WiFi (wlp9s0)anddicke'] == banddick)]
	return [df_cv['Banddicke1'].quantile(.25), df_cv['Banddicke2'].quantile(.25), df_cv['Banddicke3'].quantile(.25)]

def medianValue(provider, banddick, df):
	df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
	half =  int(df.size/2)
	return [df_cv['Banddicke1'].iloc(half), df_cv['Banddicke2'].iloc(half), df_cv['Banddicke3'].iloc(half)]

def conValue(provider, banddick, df):
	# the convariance of the data
	df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
	return df_cv.cov()

def skewness(provider, banddick, df):
	df_cv = df.loc[(df['Hersteller'] == provider) & (df['Banddicke'] == banddick)]
	return [df_cv['Banddicke1'].skew(), df_cv['Banddicke2'].skew(), df_cv['Banddicke3'].skew()]


if __name__ == '__main__':
   main()