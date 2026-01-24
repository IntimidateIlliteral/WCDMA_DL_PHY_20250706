# WCDMA_DL_PHY_20250706
WCDMA下行空口物理层：  
中间输出（当前）：连续3帧PCCPCH的星座图    
最终输出：PCCPCH，解CRC无错误

运行：main.m  
输入：0.1s数字基带信号（在数据集data1中，中频载波15.36MHz，采样率61.44MHz）    

## contact me 1960851445@qq.com if you have anything instresting
## 关键遗留问题：多径合并-rake。想搞成rake接收（多径=时间分集，合并）
但是第一步多径搜索——用的扰码相关搜峰——根本搜不到多径，只有最强径，其他“径”幅度几乎无峰——第二大的极大值点为0.08左右，太弱了没法用。  
看论文里写的，一般rake跟踪的峰值大概0.3~1范围，再弱的不合并——合并无法提供Eb/N0增益，不跟了；  
因此目前的关键点：需要一个空口采样数据，有明显多径分集，可以合并的。  
【20260106】另外，rake搜多径，是否需要在匹配滤波前搜？——具体要在哪一步之前搜多径并跟踪?
## 关键遗留问题2：hdl代码生成
最近学了个绝招，用matlab把我写的函数，自动生成hdl SystemVerilog代码  
有了hdl代码，可以直接上fpga了  
等我有空了整理出来
## 关键遗留问题3：匹配滤波做的好像不对。
匹配滤波应该是用【成型后的符号，方波的滤波器响应】去匹配，而不是当前用的【滤波器的单位脉冲响应】去匹配？  
二者差了个卷积。
## 关键遗留问题4：匹配滤波/脉冲成型滚降滤波，是对【每个码片】做，还是对【每个符号=256个码片】做？注意101协议里的脉冲成型滚降滤波器
20260123 前，肯定确认是对每个码片做。  
20260123 明确了又一个ofdm原理内容: ofdm的滚降滤波,是对【每个ofdm符号=4096个点】做，而不是对【每个点】做。  
因此重新思考这个问题。
## 关键遗留问题5：虚部是+还是-？复包络，希尔伯特，IQ采样，上下变频
%% todo: I-Q sample 与超外差-中频接收机，基带信号的实部虚部到底是？
## 本人暂时还没有自己采空口数据的条件，如果有好人分享给我一份，感激不尽！
我的邮箱：1960851445@qq.com 

## 数据集dataSet较大，在想办法上传
## 数据集/data1 已上传！

注意：这几天才发现，输入的实际是基带信号，而不是中频信号  
----可以fft输入的xcorr plot幅度abs()：  
肉眼可见，频率约分布在0~1/20，即1/16*采样率=3.84MHz；  
若是中频信号，则频率分布应为带通，在1/4附近，即15.36=1/4*61.44


for a communication-engineer-major in 1t8j9u5__university: 
DIGITAL-COMMUNICATION-RECEIVER-DESIGN, An optional course by Pro.Hou. for senior students.
If you are a senior and taking the course, and the course is still aiming at WCDMA instead of LTE or NR,
please spontaneously ask Pro.Hou. for an upgrade to LTE or NR.
