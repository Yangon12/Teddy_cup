#常用度量的一些方法：
import numpy as np
from math import *

#Eucledian Distance
def eculidSiml(x,y):
    return sqrt(sum(pow(a - b, 2) for a, b in zip(x,y)))

#Manhattan Distance
def manhattan_dis(x,y):
    return sum(abs(a - b) for a, b in zip(x,y))
print(manhattan_dis([1, 3, 2, 4], [2, 5, 3, 11]))

#Minkowski Distance
def minkowski_dis(x,y,p):
    sumvalue = sum(pow(abs(a - b), p) for a, b in zip(x,y))
    mi = 1 / float(p)
    return round(sumvalue ** mi, 3)

#Cosine Similarity
def cosine_dis(x,y):
    num = sum(map(float, x * y ))
    denom = np.linalg.norm(x) * np.linalg.norm(y)
    return round(num / float(denom), 3)

#Jaccard Similarity
def jaccard_similarity(x,y):
    intersection_cardinality = len(set.intersection(*[set(x), set(y)]))
    union_cardinality = len(set.union(*[set(x), set(y)]))
    return intersection_cardinality / float(union_cardinality)


