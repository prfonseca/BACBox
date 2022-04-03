function varargout=BACsensor(varargin)
% considera a disposi��o dos sensores e descarta aqueles nao utilizados
% disponivel apenas para sistema de 13 canais.
%
% Sintaxes poss�vels
%   sens=BACsensor
%   sens=BACsensor(vetor_canais), vetor_canais � um vetor com numero dos
%                                   canais a serem utilizados com arranjo
%                                   padr�o.
%   sens=BACsensor(vetor_canais,'personalizado'), vetor_canais � um vetor com numero dos
%                                   canais a serem utilizados com arranjo
%                                   personalizado
%
% sens=[
%     0        13         0          8        0
%     0        0          7          0        0
%     0        6          0          2        0
%     12       0          1          0        9
%     0        5          0          3        0
%     0        0          4          0        0
%     0        11         0          10       0];
%
% Atualizada por Paulo Fonseca em 25-Aug-2011.

fh=figure(gcf); %pega uma figura se necessario
switch nargin
    case 0 % usu�rio n�o entra nada
        tipo=arranjo; % arranjo
        if strcmp(tipo,'Padr�o')==0; mapa;% interface para personalizar
        else sens=padrao;                 % usa matriz padr�o 
             setappdata(fh,'sens',sens);  % salva na raiz
        end
    case 1 % usu�rio entra n�mero dos canais. usa matriz padr�o.
        sens=padrao;                 % matriz padr�o
        vmedida=varargin{1};         % recebe entrada
        sens=descarta(vmedida,sens); % descarta sensores n�o utilizados
        setappdata(fh,'sens',sens);   % salva na raiz
    case 2 % usu�rio entra n�mero dos canais e string de personaliza��o
        vmedida =varargin{1};         % vetor com numero dos canais
        tipo    =varargin{2};         % arranjo dos sensores
        sens=padrao;
        sens=descarta(vmedida,sens); % descarta sensores n�o utilizados
        if strcmp(tipo,'padr�o')==0||strcmp(tipo,'padrao')==0
            mapa(sens);
        end
    otherwise; BACmsg('naoprevisto',mfilename);return;
end

switch nargout
    case 0
    case 1
        if nargin==1
            varargout{1}=getappdata(fh,'sens');
            rmappdata(fh,'sens'); close(fh);
        else
            varargout{1}='para salvar a variavel em seu workspace, use getappdata';
        end
end
end

function mapa(varargin)
fh=figure(gcf);                         %pega uma figura
th=uitable(fh,...                   %cria a tabela
    'Position',[10 30 250 160],...  % posi��o e dimens�es
    'Units','pixel',...             % unidades
    'ColumnWidth',{30},...          % largura das colunas
    'BackgroundColor',[0 1 1],...   % cor de fundo da tabela
    'Tag','tabela',...              % tag da tabela
    'ColumnEditable',true(1,7));    % define colunas editaveis

if nargin==0;    padrao(th)                   % usa valores padrao da tabela
else             set(th,'Data',varargin{1})   % usa valores fornecidos na entrada  
end

uicontrol('Style', 'pushbutton', 'String', 'Padr�o',...
    'Position', [270 0 50 20],...
    'Callback', {@padrao,th});
uicontrol('Style', 'pushbutton', 'String', 'Girar 90�',...
    'Position', [270 40 50 20],...
    'Callback', {@noventa,th});
uicontrol('Style', 'pushbutton', 'String', 'Ok',...
    'Position', [270 80 50 20],...
    'Callback', {@feito,fh,th});

figure(fh)
end

function varargout=padrao(varargin)
sens=[
    0        8          0          13       0
    0        0          7          0        0
    0        2          0          6        0
    9        0          1          0        12
    0        3          0          5        0
    0        0          4          0        0
    0        10         0          11       0];
Sens=zeros(7);      Sens(:,2:6)=sens;  clear sens
% joga as posi��es dentro da tabela, quando ela existe
if nargin==1;    set(varargin{1},'Data',Sens);
elseif nargin==3;set(varargin{3},'Data',Sens);end
% 
if nargout==1; varargout{1}=Sens; end

end

function noventa(varargin)
% gira posicao do sensor em 90�
if nargin==1;    th=varargin{1};
elseif nargin==3;th=varargin{3};end
Sens=get(th,'Data');
Sens=Sens';
set(th,'Data',Sens);

end
% 
function feito(~,~,fh,th)
Sens=get(th,'Data');
n0=Sens(Sens~=0);
n0=sort(n0)';
if length(n0)>1
    for c=2:length(n0)
        if n0(c)==n0(c-1)
            errordlg(['Sensor est� ', num2str(n0(c)),' repetido.',10,'Refa�a'],...
                'Erro','modal')
            return
        end
    end
end
grava(fh,th)
end

function sens=descarta(vmedida,sens)
     %descarta sensores nao utilizados
     pos1=find(sens~=0);
     P=pos1*ones(1,length(vmedida));
     Q=sens(P);
     for c=1:length(vmedida); Q(:,c)=Q(:,c)==vmedida(c); end
     Q=sum(Q,2); sens(P(Q==0))=0;
     clear Q P
end

function grava(ph,th)
    % grava os dados na figura
    Sens=get(th,'Data');
    setappdata(ph,'sens',Sens);
    set(th,'ColumnEditable',false(1,7))
end

function tipo=arranjo
    tipo=questdlg('Qual ser� o arranjo dos sensores?',...
        'Sensores','Padr�o','Personalizado','Padr�o');
end