# Project Description:
# TDMS Dataset Analysis based on unspuervised learning
# Author: Sherry
# coding: utf-8


from nptdms import TdmsFile
from sklearn.preprocessing import StandardScaler
import pandas
import numpy as np
from sklearn.feature_selection import VarianceThreshold
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from collections import defaultdict
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.preprocessing import StandardScaler


# tdms_file = TdmsFile("Automatik_Werkzeugbruchsicherung.tdms")
#list out the groups
groups = tdms_file.groups()  


#choose the Group x as a traget analysis
#Original dataset
channel_bool = tdms_file.group_channels('DINT')
channel_bool


# kick out the "all zero", "all one" value
df = tdms_file.object('DINT').as_dataframe()
num_attr = df.columns.size
dropall = []
for i in range(0,num_attr):
    index = df.columns[i]
    if(all(df[index]==0) or all(df[index]==1)):
        dropall.append(df.columns[i])
df.drop(dropall, axis = 1, inplace= True)



#Step 2:  Removing features with low variance
sel = VarianceThreshold(threshold=(.8* (1 - .8)))
x = sel.fit_transform(df.values)


#findout the selected columns
ix = np.isin(df.values[0,:], x[0])
column_indices = np.where(ix==True)
df = df.iloc[column_indices]


class PFA(object):
    def __init__(self, n_features, q=None):
        self.q = q
        self.n_features = n_features

    def fit(self, X):
        if not self.q:
            self.q = X.shape[1]

        sc = StandardScaler()
        X = sc.fit_transform(X)

        pca = PCA(n_components=self.q).fit(X)
        A_q = pca.components_.T

        kmeans = KMeans(n_clusters=self.n_features).fit(A_q)
        clusters = kmeans.predict(A_q)
        cluster_centers = kmeans.cluster_centers_

        dists = defaultdict(list)
        for i, c in enumerate(clusters):
            dist = euclidean_distances([A_q[i, :]], [cluster_centers[c, :]])[0][0]
            dists[c].append((i, dist))

        self.indices_ = [sorted(f, key=lambda x: x[1])[0][0] for f in dists.values()]
        self.features_ = X[:, self.indices_]



# PFA method
pfa = PFA(n_features=10)
pfa.fit(df)

# To get the transformed matrix
x = pfa.features_

# To get the column indices of the kept features
column_indices = pfa.indices_



df.columns[column_indices]
#df[df.columns[column_indices]]




# PDO: Process Data Objects


