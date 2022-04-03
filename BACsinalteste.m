function varargout=BACsinalteste(varargin)
% rotina para gerar sinais de teste. O usuário pode especificar um conjunto
% de frequencias e o somatório de ondas seno com tais frequencias é
% apresentado como saída.
%
% sintaxe:
%   BACsinalteste
%       % gera um sinal de teste padrão, apenas exibindo. não salva.
%       % tempo: 25s
%       % frequencias: 2 Hz
%       % amostragem: 10 Hz
%
%   BACsinalteste(tempo,frequencias,amostragem)
%       % gera um sinal de teste padrão. não salva;
%       % tempo: duração do sinal (em segundos)
%       % frequencias: um vetor com as frequencias (Hz) de cada canal. por
%                       exemplo [0.5 1 1.5] gera um sinal com três canais,
%                       um de 0.5, outro de 1 e outro de 1.5 Hz.     
%       % amostragem: taxa de amostragem (Hz)
%
%   sinalsaida=BACsinalteste(tempo,frequencias,amostragem)
%       % gera um sinal de teste padrão, com as mesmas propriedades
%       anteriormente descritas, mas não salva. apenas aloca na variavel de
%       saída o sinal especificado.
% 
% última atualização em 19-Aug-2011 por Paulo Fonseca

% considera os argumentos de entrada
switch nargin
    case 0
        tmax=25;         fa=10;        freq=2;
    case 3
        tmax    =varargin{1};
        freq    =varargin{2};
        fa      =varargin{3};
    otherwise; clc; BACmsg('naoprevisto',mfilename); return;
end

nfreq=length(freq);     % numero de canais
t=1/fa:1/fa:tmax;t=t';  % eixo de tempo
L=length(t);            % comprimento do vetor
sinal=zeros(L,1);

for c=1:nfreq
    sinal=sinal+sin(2*pi*freq(c)*t);
end

figure (1), plot(t,sinal);
xlabel('tempo (s)'); ylabel('intensidade (u.a.)');
grid on;


switch nargout
    case 0;   varargout{1}='';
    case 1;   varargout{1}=sinal;
    otherwise; clc; BACmsg('naoprevisto',mfilename); return; 
end
