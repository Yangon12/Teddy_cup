#一元线性回归程序：-----------------------------------
import numpy as np 
import matplotlib.pyplot as plt

#生成随机数据
x = np.arange(1, 10, 0.5) 
y = np.array([2, 3, 5, 4, 3, 7, 6, 8, 9, 10, 8, 11, 12, 13, 14, 15, 16, 17])

#利用最小二乘法拟合曲线
A = np.vstack([x, np.ones(len(x))]).T 
m, c = np.linalg.lstsq(A, y)[0]
print(type(m),type(c))
#画出数据和拟合线段图
plt.plot(x, y, 'o', label='Original data', markersize=10) 
plt.plot(x, m*x + c, 'r', label='Fitted line')
plt.legend() 
plt.show()
#预测图像未来函数取值
xx = input('pls input the num you want to predict:')
xx = float(xx)
yy = m*xx + c
print('The predicted value is:',yy)

#多元线性回归程序：-----------------------------------
import numpy as np 
import matplotlib.pyplot as plt 

# 自拟数据
x = np.array([1., 2., 3., 4., 5.]) 
y = np.array([1., 3., 2., 3., 5.]) 

# 多元线性回归
X = np.stack([np.ones(len(x)), x], axis=1) 
w = np.linalg.solve(np.dot(X.T, X), np.dot(X.T, y)) # 系数 

# 拟合曲线
x2 = np.array([0., 6.]) 
y2 = w[0] + w[1]*x2 

# 可视化
plt.plot(x, y, 'bo', label='Original data') 
plt.plot(x2, y2, 'r', label='Fitted line') 
plt.legend() 
plt.show()
