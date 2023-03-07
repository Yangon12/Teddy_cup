#数据库转换
import netCDF4 as nc 
file_nc = nc.Dataset('E:\Tedy_cup\Linear_Regression\precip.2022.nc', 'r') 
file_csv = open('E:\Tedy_cup\Linear_Regression\precip.2022.csv', 'w') 
for var in file_nc.variables: 
    data = file_nc.variables[var] 
    file_csv.write(var + ',') 
    for i in range(data.shape[0]): 
        file_csv.write(str(data[i]) + ',')
        file_csv.write('\n')
file_csv.close()

#数据库清洗
import pandas as pd
import numpy as np

data = pd.read_csv("E:\Tedy_cup\Linear_Regression\precip.2022.csv")
#用pandas dataframe格式加载数据集
data = data.drop(['Events','Date','SeaLevelPressureHighInches','SeaLevelPressureLowInches'],axis=1)
#舍弃或删除数据集中不必要的列
#在降雨量过少时，存在用'T'代替具体降雨量的情况
#需要将所有的字母T替换成0，以便模型能够正常的使用数据
data = data.replace('T',0.0)
#数据集中用'-'表示否，或者数据无法获得的情况
#同样需要将'-'替换成0
data = data.replace('-',0.0)
data.to_csv('E:\Tedy_cup\Linear_Regression\precip.2022_final.csv')
#将清洗后的数据保存成csv文件

#数据处理与预测
import pandas as pd
import numpy as np
import sklearn as sk
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
#解决中文显示问题
plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus'] = False

#读入清洗后的数据集
data = pd.read_csv("E:\Tedy_cup\Linear_Regression\precip.2022_final.csv")

#特征值以列向量'x'的形式作为输入用于模型训练
#最后一列是降雨量，用作训练的标签
X = data.drop(['PrecipitationSumInches'], axis = 1)

#最后一列是降雨量，可作为模型的输出或用作训练模型的标签
Y = data['PrecipitationSumInches']
#将Y变换成二维列向量，-1代表由系统计算出有多少行数据
Y = Y.values.reshape(-1,1)
#考虑数据库中随机的一天，我们画出图像并观察这一天
day_index = 789
days = [i for i in range(Y.size)]
#初始化线性回归模型
clf = LinearRegression()
#用输入数据训练线性回归模型
clf.fit(X, Y)
#选择一个样本输入测试线性回归模型
input = np.array([[74],[60],[45],[67],[49],[43],[93],[75],[57],[29.68],[10],[7],[2],[20],[4],[31]])
input = input.reshape(1,-1)
#显示降雨量输出值
print('降雨量（英寸）为：', clf.predict(input))
#画出预测的降雨量水平在所有日期降雨量中的位置
print("降雨量趋势图：")
plt.scatter(days, Y.tolist(), color = 'g')
plt.scatter(days[day_index], Y[day_index], color = 'r')
x_major_locator = MultipleLocator(200)
y_major_locator = MultipleLocator(1)
plt.title("降雨量水平")
plt.xlabel("日期")
plt.ylabel("降雨量（英寸）")
plt.show()
x_vis = X.filter(['TempAvgF','DewPointAvgF','HumidityAvgPercent',
                  'SeaLevelPressureAvgInches','VisibilityAvgMiles',
                  'WindAvgMPH'], axis = 1)
#画出一些重要的特征值（x值）与降雨量的关系
print("降雨量 vs 影响因素图：")

x_vis = X.filter(['TempAvgF','DewPointAvgF','HumidityAvgPercent',
                  'SeaLevelPressureAvgInches','VisibilityAvgMiles',
                  'WindAvgMPH'], axis = 1)
y_interval = [20, 20, 20, 0.2, 2, 2]
for i in range(x_vis.columns.size):
    plt.subplot(3,2,i+1)
    plt.scatter(days, x_vis[x_vis.columns.values[i]])
    plt.scatter(days[day_index], x_vis[x_vis.columns.values[i]][day_index],
                color = 'r')
    plt.title(x_vis.columns.values[i])
x_major_locator = MultipleLocator(200)
y_major_locator = MultipleLocator(y_interval[i])
ax = plt.gca()
ax.xaxis.set_major_locator(x_major_locator)
ax.yaxis.set_major_locator(y_major_locator)
if i==3:
    plt.ylim(29.4, 30.8)
    plt.show()
