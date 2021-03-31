function [texttrj,textsensor] = aligndata(texttrj, textsensor)

for i = 1:size(texttrj,1)
    if(texttrj(i,1) < texttrj(1,1))
        texttrj(i,1) = texttrj(i,1)+3600;
    end
end
if texttrj(1,1) > textsensor(1,1)
    begintime = texttrj(1,1);
else
    begintime = textsensor(1,1);
end

if texttrj(end,1) < textsensor(end,1)
    endtime = texttrj(end,1);
else
    endtime = textsensor(end,1);
end

texttrj = align( begintime, endtime, texttrj);
textsensor = align( begintime, endtime, textsensor);

end

function [ align_data ] = align( begin_time, end_time, data )

for i = 1:size(data,1)
    if(data(i,1) >= begin_time)
        data = data(i:end,1:end);
        break;
    end
end
for i = 1:size(data,1)
    if(data(i,1) > end_time)
        data = data(1:i-1, 1:end);
        break;
    end
end

align_data = data;

end