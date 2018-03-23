function linecord = Drawline(x,y)
%DRAWLINE implements the line equation. To calculate the movement path from
%point to point.
%   Input: 
%         x: Start point with x,y cordinates
%         y: End point with x,y cordinates
%     
%   Output: 
%         linecord: Path points from x to y

    linecord  = [];

    pt1(2) = round(x(1));
    pt1(1) = round(x(2));

    pt2(2) = round(y(1));
    pt2(1) = round(y(2));

    a = pt1(1);
    b= pt1(2);
    u = pt2(1)-pt1(1);
    v = pt2(2)-pt1(2);
    d1x = sign(u);
    d1y = sign(v);
    d2x = sign(u);
    d2y = 0;
    m   = abs(u);
    n   = abs(v);
    if (m<=n)
        d2x = 0;
        d2y = sign(v);
        m   = abs(v);
        n   = abs(u);
    end
    s = m / 2;
    for i=1:round(m)
        linecord = [linecord ; [a b]];
        s = s+n;
        if (s >= m) 
        s = s- m;
        a = a + d1x;
        b = b + d1y;
        else 
            a = a+d2x;
            b = b +d2y;
        end
    end
end
