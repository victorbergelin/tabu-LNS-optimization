function count=ModifiedAMPLmatrix(fid,pname,p,colhdrtype,varargin)
%
%   function count=AMPLmatrix(fid,pname,p,[rowheads,colheads])
%
% Write matrix of floats to AMPL data file
%
%   fid   : file handle of the data file from 'fopen' 
%   pname : name to be given to the parameter in the file (string)
%   p     : the value of the parameter (matrix)
%
%   rowheads (optional) : row indices
%   colheads (optional) : column indices
%
%   If the matrix is M x N, rowheads should be 1 x N and colheads
%   should be 1 x M. If omitted, rows are labeled 1 to N and
%   columns 1 to M. Ths facility allows zero-based indices to be
%   used in the AMPL parameter, or any other index system
%
%   count : number of bytes written
%
% Copyright A. Richards, MIT, 2002
%
%%% Create a new columnheader ###
colhdrmatrix = cell(1,4);
if (colhdrtype == 1)
    colhdrmatrix{1,1} = 't_s';
    colhdrmatrix{1,2} = 't_e';
    colhdrmatrix{1,3} = 'g';
    colhdrmatrix{1,4} = 'l';
else if(colhdrtype == 2)
    colhdrmatrix{1,1} = 'I_df';
    colhdrmatrix{1,2} = 'I_dt';
    colhdrmatrix{1,3} = 'f_min';
    colhdrmatrix{1,4} = 'f_max';
    else
        error('Error! Argument shall be 1 or 2');
    end
end
s=size(p);c=0;

if size(s,2)>2,
  error('Not matrix')
else
  % matrix
  w = size(p,2);
  % get column headers
  colhdr=[1:w];
  if nargin>4,
    colhdr=varargin{2};
  end
  % print parameter name
  c = c + fprintf(fid,['param ' pname ' : ']);
  % print column headers
  for j=[1:w],
    c = c + fprintf(fid,'\t\t%s',colhdrmatrix{1,j});
    
  end
  % and the equals
  c = c + fprintf(fid,'\t:=\n');
  % get row headers
  h = size(p,1);
  rowhdr=[1:h];
  if nargin>4,
    rowhdr=varargin{1};
  end
  % print rows
  for i=[1:(h-1)],
    % print row header
    c = c + fprintf(fid,'\t%4.0f',rowhdr(i));
    % print row data
    for j=[1:w],
      c = c + fprintf(fid,'\t\t%6.2f',p(i,j));
    end
    % new line
    c = c + fprintf(fid,'\n');
  end
  % do last row separate
  c = c + fprintf(fid,'\t%4.0f',rowhdr(h));
  for j=[1:w],
    c = c + fprintf(fid,'\t\t%6.2f',p(h,j));
  end
  % end with semicolon
  c = c + fprintf(fid,'\t;\n');
end
count=c;