%% =========================================================================
% Script Name:bc_rubber.m
% Description: Performs baseline correction
%
% Corresponding paper:
% "Multi-modal spatial metabolomics with mid-infrared microscope guided mass spectrometry imaging"
% Authors: Minqian Wei, Haining Wang, Yirong Zeng, Dan Ye, Gangqi Wang, Lixue Shi
% email:mqwei23@m.fudan.edu.cn
%
% Dependencies:
%   - MATLAB R2024a or later
%
% Citation:
% If you use this code, please cite the above article.
%
% License: For academic use only.
% =========================================================================

function varargout = bc_rubber(X)

msgstring = nargoutchk(1, 2, nargout);
if ~isempty(msgstring)
    error(msgstring);
end;


[no, nf] = size(X);

Y = zeros(no, nf);
L = zeros(no, nf);

for i = 1:no
    if nf > 0
        l = [];
        x = X(i, :);
        if length(x) > 1
            l2 = rubber(x);
        else
            l2 = [];
        end;
        l = [x(1) l2];
        
        Y(i, :) = x-l;
        L(i, :) = l;
    end;
end;



if nargout == 1
    varargout = {Y};
elseif nargout == 2
    varargout = {Y, L};
end;
    
%---------------------------------------------------------------------
function y = rubber(x)

nf = length(x); % number of points

l = linspace(x(1), x(end), nf);

xflat = x-l;
[val, idx] = min(xflat);
if ~isempty(val) && val < 0
    y = [rubber(x(1:idx)), rubber(x(idx:end))];
else
    y = l(2:end);
end;
