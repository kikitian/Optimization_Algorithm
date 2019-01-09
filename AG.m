% ��Ⱥ�㷨�����ֵ
% ����˼·: 
% ������Ⱥ�㷨��Щ���ƣ����ǿ��Ŷӵ�������ͬȥ��Ŀ�꣡
% ��Ⱥ�㷨�������������"��Ϣ��"�ӷ�! ���Ч���������㷨��û�еģ�

clc;
clear;
% f�����ֵ����-ǰ�����ֵ;������2.4
f = inline('2.4-(x.^4 + 3*y.^4 - 0.2*cos(3*pi*x) - 0.4*cos(4*pi*y) + 0.6)');
x = -1:0.001:1;
y = -1:0.001:1;
[X,Y] = meshgrid(x,y);
F = f(X,Y);
figure(1);
mesh(X,Y,F);
xlabel('������x'); ylabel('������y'); zlabel('�ռ�����z');
hold on;

% ����/������Χ������:
lower_x = -1;
upper_x = 1;
lower_y = -1;
upper_y = 1; 

% ģ�ͳ�ʼ��������:
ant = 80;      % ��������300ֻ̫����,����100ֻ���ɽ������
times = 30;    % ÿֻ������Ѱ80��
rou = 0.9;     % ��Ϣ�ػӷ�����
p0 = 0.2;      % ����ת�Ƶĸ��ʳ���

% ��ʼ����λ��(�ռ������)����Ӧ�ȼ���:
ant_x = zeros(1,ant);  % ÿֻ����λ�õ�x����
ant_y = zeros(1,ant);  % ÿֻ����λ�õ�y����
tau = zeros(1,ant);    % ��Ӧ��/������ֵ
Macro = zeros(1,ant);  % Macro��tau��ͬʹ�õ��м����������
for i=1:ant
    ant_x(i) = (upper_x-lower_x)*rand() + lower_x;
    ant_y(i) = (upper_y-lower_y)*rand() + lower_y;
    tau(i) = f(ant_x(i),ant_y(i));         % ��ʼ��Ӧ��/����ֵ
    plot3(ant_x(i),ant_y(i),tau(i),'k*');  % ��ʼȺ���ú�ɫ*���
    hold on;
    Macro = zeros(1,ant);
end

fprintf('��Ⱥ������ʼ(�����ֵ):\n');
T = 1;
tau_best = zeros(1,times);  % ��¼ÿ��Ѱ�Һ��Ⱥ���е����ֵ!
p = zeros(1,ant);   % ÿֻ����״̬ת�Ƶĸ���,����p0�Ƚ�
while T < times
    lamda = 1/T;
    % �����ǲ鿴��ֵ�ĵط�!��
    [tau_best(T),bestindex] = max(tau);
    
    % �����㹻�ߣ���ǰ����!
    % �������и�����: ��ǰ��Ӧ��ֵ �� ǰ���ֵ�ֵ�Աȣ� ����������һ��ֵ�Աȣ�
    % ��Ϊ��������ѭ����ֵ�ܿ�����Ϊ��һ��������Զ��˴˽ӽ���
    if T >= 3 && abs((tau_best(T) - tau_best(T-2))) < 0.000001
        fprintf('�����㹻��,��ǰ����!\n');
        % С��˼:���һ�λ�ͼ����������԰����һ��������ɫ�����Ǻ�ɫ��
        plot3(ant_x(bestindex), ant_y(bestindex), f(ant_x(bestindex),ant_y(bestindex)), 'b*');
        break;
    end
    plot3(ant_x(bestindex), ant_y(bestindex), f(ant_x(bestindex),ant_y(bestindex)), 'r*');
    hold on;
    
    for i = 1:ant
        p(i) = (tau(bestindex) - tau(i))/tau(bestindex); % ÿһֻ���ϵ�ת�Ƹ���
    end
    % λ�ø���: �������ʱ����tempx��tempy��һ����!
    for i = 1:ant
        % С��p0���оֲ�����:
        if p(i) < p0
            tempx = ant_x(i) + (2*rand-1)*lamda;
            tempy = ant_y(i) + (2*rand-1)*lamda;
        % ����p0����ȫ������:
        else
            tempx = ant_x(i) + (upper_x-lower_x)*(rand-0.5);
            tempy = ant_y(i) + (upper_y-lower_y)*(rand-0.5);
        end
        % ����Խ�磬��һ��Խ���ж�:
        if tempx < lower_x
            tempx = lower_x;
        end
        if tempx > upper_x
            tempx = upper_x;
        end
        if tempy < lower_y
            tempy = lower_y;
        end
        if tempy > upper_y
            tempy = upper_y;
        end
        % �ж������Ƿ��ƶ�,��tempx��tempy�Ƿ����
        % tau(i)����һ�ֵ�ֵ��Macro�Ǽ�ʱ���µ�ֵ!!
        if f(tempx,tempy) > tau(i)
            ant_x(i) = tempx;
            ant_y(i) = tempy;
            Macro(i) = f(tempx,tempy);
        end
    end
   
    % ��Ӧ�ȸ���:
    for i = 1:ant
        tau(i) = (1-rou)*tau(i) + Macro(i);
    end
    
    % ����������һ��:
    T = T + 1;
end
hold off;
    
fprintf('��Ⱥ�����������ֵ��:(%.5f,%.5f,%.5f)\n',...
        ant_x(bestindex), ant_y(bestindex), f(ant_x(bestindex),ant_y(bestindex)));
fprintf('��������:%d\n',T)
    
    