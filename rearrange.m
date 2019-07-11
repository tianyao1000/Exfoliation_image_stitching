function subm = rearrange(u,v)
    subm=[u(1) u(2) 1  0 0 0 -u(1)*v(1) -u(2)*v(1) -v(1);
        0 0 0 u(1) u(2) 1 -u(1)*v(2) -u(2)*v(2) -v(2)];
end