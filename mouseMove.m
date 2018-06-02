function [C x y] = mouseMove (object, eventdata)
C = get (gca, 'CurrentPoint');
x = num2str(C(1,1)); y = num2str(C(1,2));
title(gca, ['(X,Y) = (', x, ', ',y, ')']);