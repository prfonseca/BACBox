function varargout=BACem(varargin)
% recebe um sinograma e o reconstroi usando EM
%   esta fun��o utiliza recursos desenvolvidos em colabora��o com Rodrigo
%   S. S. Viana (rodrigossviana@gmail.com)
%
% sitaxe:
%   tomo=BACem(sinograma,niter,sout)
% em que:
%       sinograma � uma matriz 2D (projecoes x feixes)
%       niter: n�mero de itera��es (n�mero inteiro)
%       sout: dimens�o da imagem (imagem quadrada)
clc;
sinograma   =varargin{1};
niter       =varargin{2};
sout        =varargin{3};

ppp=getappdata(0,'projecoes');
if isempty(ppp)
    [projecoes, feixesporprojecao]=size(sinograma); %dimens�es
    [opeR]=opePROJ(projecoes,feixesporprojecao); % constroi operador
    setappdata(0,'opeR',opeR);
    setappdata(0,'projecoes',projecoes);
    setappdata(0,'feixesporprojecao',feixesporprojecao);
else
    fff=getappdata(0,'feixesporprojecao');
    if [ppp,fff]==size(sinograma);
        opeR=getappdata(0,'opeR');
        feixesporprojecao=fff;
        projecoes=ppp;
    else
        [projecoes, feixesporprojecao]=size(sinograma); %dimens�es
        [opeR]=opePROJ(projecoes,feixesporprojecao); % constroi operador
        setappdata(0,'opeR',opeR);
        setappdata(0,'projecoes',projecoes);
        setappdata(0,'feixesporprojecao',feixesporprojecao);
    end
end
clear ppp fff

sinograma=sinograma'; % transposta
sinograma=sinograma-min(sinograma(:));
sinograma=sinograma/max(sinograma(:));
sinograma=im2uint16(sinograma);
sinograma=im2double(sinograma);

maiszero=20;
sinograma=[zeros(maiszero,projecoes); sinograma ;zeros(maiszero,projecoes)]; % acrescenta zeros

svetor=sinograma(:); % interpola
Svetor=interp1(1:length(svetor),svetor,linspace(1,length(svetor),size(opeR,1)))';

switch nargout
    case 0
        varargout={};
    case 1
        [Rec,~]=em(opeR,Svetor,niter,feixesporprojecao);
        if feixesporprojecao~=sout;Rec=imresize(Rec,[sout,sout]);end
        varargout{1}=Rec;
    case 2
        [Rec,Vec]=em(opeR,Svetor,niter,feixesporprojecao);
        if feixesporprojecao~=sout;Rec=imresize(Rec,[sout,sout]);end
        varargout{1}=Rec;
        varargout{2}=Vec;
    otherwise
         clc;BACmsg('naoprevisto',mfilename);return;
end