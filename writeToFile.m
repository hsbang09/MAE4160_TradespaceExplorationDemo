function writeToFile(filePath, sat, writeHeader)

    colnames = [];

    if writeHeader
        colnames = fieldnames(sat);
        fid = fopen(filePath, 'w') ;
        fprintf(fid, '%s,', colnames{1:end-1,1}) ;
        fprintf(fid, '%s\n', colnames{end,1}) ;
        fclose(fid) ;
        
        colnames_temp = strings(1, length(colnames));
        for i = 1:length(colnames)
            colnames_temp(i) = colnames{i};
        end
        colnames = colnames_temp;
    
    else % Assume there is already a header
        text = fileread(filePath);
        header = splitlines(text);
        header = header{1};
        header = strsplit(header, ',');
        
        colnames = strings(1, length(header));
        for i = 1:length(header)
            colnames(i) = header{i};
        end
    end

    content = strings(1, length(colnames));
    
    for i = 1:length(colnames)
        % Get value of a struct
        value = sat.(colnames(i));
        
        if length(value) == 1 % struct is a single input (either numeric or string)
            if isnumeric(value)
                content(i) = num2str(value);
            else
                content(i) = value;
            end
           
        else % struct value is an array 
            valueString = "";
            for j = 1:length(value)
                if isnumeric(value(j))
                    valueString = strcat(valueString," ",num2str(value(j)));
                else
                    valueString = strcat(valueString," ",value(j));
                end
            end
        end
    end
    
    fid = fopen(filePath, 'a+') ;
    fprintf(fid, '%s,', content{1,1:end-1});
    fprintf(fid, '%s\n', content{1,end});
    fclose(fid) ;
end