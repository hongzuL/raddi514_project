function x = filters(x)
    % low pass filter
%     a = [1 -2 1];
%     b = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
%     x=filter(b,a,x);
    %high pass filter
%     a = [1 -1];
%     b = [-1/32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1/32];
%     x = filter(b,a,x);
    %differentiation
%     a = [-8];
%     b = [2 1 0 -1 -2];
%     x = filter(b,a,x);
    %squaring
%     x = x.^2;
    %moving average
    a = 1;
    b=1/50*ones(10,1);
    x = filter(b,a,x);