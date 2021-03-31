function [Mag_left, Mag_right] = divide2LR(Mag)
count_r = 1; count_l = 1;
Mag_right = zeros(1,13);
for i = 1:size(Mag(:,13))
    if Mag(i,13) > 135 || Mag(i,13) < -135
        Mag_right(count_r,:) = Mag(i,:);
        count_r = count_r + 1;
    elseif (Mag(i,13) < 45 && Mag(i,13) >= 0) || (Mag(i,13) > -45 && Mag(i,13) <= 0)
        Mag_left(count_l,:) = Mag(i,:);
        count_l = count_l + 1;
    end
end
end