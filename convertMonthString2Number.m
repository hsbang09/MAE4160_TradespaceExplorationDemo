% convertMonthString2Number.m
function out = convertMonthString2Number( month )

    out = 0;

    switch month
        case 'Jan'
            out = 1;
        case 'Feb'
            out = 2;
        case 'Mar'
            out = 3;
        case 'Apr'
            out = 4;
        case 'May'
            out = 5;
        case 'Jun'
            out = 6;
        case 'Jul'
            out = 7;
        case 'Aug'
            out = 8;
        case 'Sep'
            out = 9;
        case 'Oct'
            out = 10;
        case 'Nov'
            out = 11;
        case 'Dec'
            out = 12;
        otherwise
            error(strcat('Month not recognized: ', month));     
    end

end