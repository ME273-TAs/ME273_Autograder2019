function dlmwrite_without_final_newline(YourFileName, YourMatrix, precision, delimiter)
%write numeric data out in delimited format, but with
%no end-of-line character on the last line
%* YourFileName - name of file
%* YourMatrix - numeric array of data
%* precision - format to write data with, or empty; default is '%.15g'
%* delimiter - delimiter to use between fields, or empty; default is ','
if ~exist('precision', 'var') || isempty(precision)
    precision = '%.15g';
end
if ~exist('delimiter', 'var') || isempty(delimiter)
    delimiter = ',';
end
cols = size(YourMatrix,2);
last_line_fmt = [repmat([precision delimiter], 1, cols-1), precision];
line_fmt = [last_line_fmt '\n'];
[fid, message] = fopen(YourFileName, 'w');
if fid < 0
    error('Failed to open file "%s" because "%s"', YourFileName, message);
end
fprintf(fid, line_fmt, YourMatrix(1:end-1, :).' );  %transpose is important here
fprintf(fid, last_line_fmt, YourMatrix(end,:) );
fclose(fid);
end