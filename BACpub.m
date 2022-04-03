function BACpub(varargin)
% publica codigo do matlab em latex ou html
% publicarcodigo(caminho,arquivo) 

clc;

if nargin==0
    [filename,pathname]=uigetfile();
else
    pathname=varargin{1};
    filename=varargin{2};
end

function_options.evalCode=false;

formato=input(['Qual o formato desejado? \n', ...
'[1] doc\n',...
'[2] latex\n',...
'[3] ppt\n',...
'[4] pdf\n',...
'[5] html\n']);
if isempty(formato);formato=5;end

switch formato
    case 1
        function_options.format='doc';
    case 2
        function_options.format='latex';
    case 3
        function_options.format='ppt';
    case 4
        function_options.format='pdf';
        fucntion_options.imageFormat='bmp'; %#ok<STRNU>
    case 5
        function_options.format='html';
    otherwise
        BACmsg('naoprevisto',mfilename);return;
end


comment=publish(fullfile(pathname,filename),function_options);
BACmsg('arqsalvo',comment);
    
    