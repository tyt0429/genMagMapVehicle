function gpstime = utc2gps(utctime)
    t1 = datetime(1970,1,1,0,0,0);
    t2 = datetime(1980,1,6,0,0,0);
    dt = seconds(t2-t1);
    utctime = (utctime - dt);
    gpstime = mod(utctime,604800) + 18; %leap seconds
end