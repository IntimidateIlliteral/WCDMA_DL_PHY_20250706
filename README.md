# WCDMA_DL_PHY_20250706

WCDMA下行空口物理层：

输入：0.1s数字中频信号（在数据集dataSet中，中频载波15.36MHz，采样率61.44MHz）
运行：ASCH，AB_descramble, despread_LOS
中间输出（当前）：连续3帧PCCPCH的星座图
最终输出：PCCPCH信道解CRC无错误


数据集dataSet较大，在想办法上传

注意：这几天才发现，输入的实际是基带信号，而不是中频信号
可以fft输入的xcorr 看幅度abs()：
肉眼可见，频率约分布在0~1/20，即1/16*采样率=3.84MHz；
若是中频信号，则频率分布应为带通，在1/4附近，即15.35=1/4*61.44


for a communication major in university__1t8j9u5: 
digital comm recv design, Pro.Hou. senior optional course.  Pro.Hou.
	If you are taking the coures as a senior, and the course is still aiming at WCDMA instead of LTE or NR,
	please spontaneously ask for an upgrade to LTE or NR.