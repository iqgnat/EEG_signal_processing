% clc;clear;close all
load('NF01.mat')
load('NF10.mat')
load('fo.mat')
% NFsess01=mean(NF01,1);
% NFsess10=mean(NF10,1);
figure
plot(f(1:300),NF01(1:300),'b-')
hold on 
plot(f(1:300),NF10(1:300),'r-')
hold off