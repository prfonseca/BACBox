function BACfft(varargin)
% Recebe um sinal de entrada e computa FFT como na msfft10
%
% sintaxes possíveis
%
%   BACfft
%
%   BACfft(variavel_de_entrada);
%
%   BACfft('diretorio\arquivo_de_entrada.fmt');
%   
%   BACfft('diretorio','arquivo.fmt');
%
% Em que:
%   variavel_de_entrada
%       nome da variável quando o sinal ja está carregado
%   'diretorio\arquivo_de_entrada.fmt'
%       caminho completo para um arquivo
%
% ---------------
% Desenvolvimento BACfft.m
%       Paulo Fonseca
% --------------
% Desenvolvimento msfft10.m 
%       José Ricardo Miranda
%       Murilo Stelzer
% ---------------
% atualizado em 19-Aug-2011 por Paulo Fonseca
%

% entradas
switch nargin
    case 0
        [pname,fname,sinal,fa]=BACload;
    case 1
        [pname,fname,sinal,fa]=BACload(varargin{1});
    case 2
        [pname,fname,sinal,fa]=BACload(varargin{1},varargin{2});
    otherwise; BACmsg('naoprevisto',mfilename);return;
end

[L,nc]=size(sinal); % tamanho do sinal e número de canais
if nc==1; txtcanal= 'um canal.';
else txtcanal=[num2str(nc), ' canais.'];
end
clc;disp(['Este sinal possui ',txtcanal,10]); clear txtcanal;
% verifica quais canais serão trabalhados
ncanais=input('Qual canal deseja visualizar FFT? \n \n Ex: [1, 2, 4] \n ou ENTER para todos \n');
if isempty(ncanais)
    ncanais=1:nc;clear nc;
end
t=1/fa:1/fa:L/fa; % eixo de tempo
NFFT=round(L/2)*2; % numero de pontos para a FFT
f=(fa/2)*linspace(0,1,NFFT/2+1); %eixo de frequencia
titulografico=fullfile(pname,fname); % titulo do grafico
for c=ncanais
    FFt=abs(fft(sinal(:,c),L));
    PP=conj(FFt).*FFt/L;
    PP=PP(1:NFFT/2+1);
    titulo=[titulografico, ' canal ',num2str(c)];
    aux_mostrasinalfft(t,sinal(:,c),f,PP,titulo)
end
end




