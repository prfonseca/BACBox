function varargout=BACsensor(varargin)
% considera a disposição dos sensores e descarta aqueles nao utilizados
% disponivel apenas para sistema de 13 canais.
%
% Sintaxes possívels
%   sens=BACsensor
%   sens=BACsensor(vetor_canais), vetor_canais é um vetor com numero dos
%                                   canais a serem utilizados com arranjo
%                                   padrão.
%   sens=BACsensor(vetor_canais,'personalizado'), vetor_canais é um vetor com numero dos
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
    case 0 % usuário não entra nada
        tipo=arranjo; % arranjo
        if strcmp(tipo,'Padrão')==0; mapa;% interface para personalizar
        else sens=padrao;                 % usa matriz padrão 
             setappdata(fh,'sens',sens);  % salva na raiz
        end
    case 1 % usuário entra número dos canais. usa matriz padrão.
        sens=padrao;                 % matriz padrão
        vmedida=varargin{1};         % recebe entrada
        sens=descarta(vmedida,sens); % descarta sensores não utilizados
        setappdata(fh,'sens',sens);   % salva na raiz
    case 2 % usuário entra número dos canais e string de personalização
        vmedida =varargin{1};         % vetor com numero dos canais
        tipo    =varargin{2};         % arranjo dos sensores
        sens=padrao;
        sens=descarta(vmedida,sens); % descarta sensores não utilizados
        if strcmp(tipo,'padrão')==0||strcmp(tipo,'padrao')==0
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
    'Position',[10 30 250 160],...  % posição e dimensões
    'Units','pixel',...             % unidades
    'ColumnWidth',{30},...          % largura das colunas
    'BackgroundColor',[0 1 1],...   % cor de fundo da tabela
    'Tag','tabela',...              % tag da tabela
    'ColumnEditable',true(1,7));    % define colunas editaveis

if nargin==0;    padrao(th)                   % usa valores padrao da tabela
else             set(th,'Data',varargin{1})   % usa valores fornecidos na entrada  
end

uicontrol('Style', 'pushbutton', 'String', 'Padrão',...
    'Position', [270 0 50 20],...
    'Callback', {@padrao,th});
uicontrol('Style', 'pushbutton', 'String', 'Girar 90º',...
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
% joga as posições dentro da tabela, quando ela existe
if nargin==1;    set(varargin{1},'Data',Sens);
elseif nargin==3;set(varargin{3},'Data',Sens);end
% 
if nargout==1; varargout{1}=Sens; end

end

function noventa(varargin)
% gira posicao do sensor em 90º
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
            errordlg(['Sensor está ', num2str(n0(c)),' repetido.',10,'Refaça'],...
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
    tipo=questdlg('Qual será o arranjo dos sensores?',...
        'Sensores','Padrão','Personalizado','Padrão');
end