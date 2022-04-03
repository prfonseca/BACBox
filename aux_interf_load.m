function [fname,pname]=aux_interf_load(varargin)
% interface para carregar um sinal
% pode receber como entrada um diretório ou um diretório e um título para
% interface

if nargin==0
    diretorio=cd;
    mensagem='Selecione um arquivo';
elseif nargin==1
    diretorio=varargin{1};
    mensagem='Selecione um arquivo';
elseif nargin==2
    diretorio=varargin{1};
     mensagem=varargin{2};
else
    BACmsg('naoprevisto',mfilename);return;
end


        [fname,pname]=uigetfile({'*.*','Todos arquivos (*.*)';...
            '*.dat','Arquivos DAT (*.dat)';...
            '*.txt','Arquivos TXT (*.txt)';...
            '*.lvm','Arquivos LVM (*.lvm)';...
            'tBAC*.lvm','Arquivos tBAC';...
            'sino*.mat','Sinogramas tBAC'},...
            mensagem,...
            'MultiSelect', 'off',diretorio);
end