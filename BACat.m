function varargout=BACat(varargin)
% �ltimas atualiza��es
% 
% Sintaxes poss�veis
%   BACat: exibe todas atualizacoes
%   BACat(X): exibe ultimos X caracteres do log de atualizacoes
%   A=BACat(...): armazena na vari�vel A as informacos de atualizacao

iptchecknargin(0,1,nargin,mfilename);

fid=fopen('atualizacoes.txt','r');
texto=fread(fid);
if nargin==1
    if length(texto)>varargin{1};texto=texto(1:varargin{1});end
    texto=[char(texto'),10,10,'Para ver todos detalhes, use BACat'];
else
    texto=char(texto');
end

switch nargout
    case 0
        varargout={};
        clc; 
        aux_logobiomag
        disp('::::: Últimas atualizações de BACBox');
        disp('')
        disp('')
        disp(texto)
    case 1
        varargout{1}=texto;
    otherwise
        BACmsg('naoprevisto',mfilename);
        return;
end



