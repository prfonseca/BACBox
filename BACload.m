function varargout=BACload(varargin)
% funcao para carregar sinal
%
% ENTRADAS:
% --------
% BACload
%   para usar uma interface e selecionar o sinal
%
% BACload(sinal)
%   para especificar uma variavel existente no workspace
%
% BACload('diretorio','arquivo')
%   para especificar um arquivo
%
% SAIDAS:
% --------
% sinal=BACload(...)
%   grava o sinal carregado em BACload numa variavel do workspace. a
%   primeira coluna corresponde ao tempo; as demais correspondem ao sinal
%
% [diretorio,arquivo,sinal]=BACload(...)
%   grava nome do diretorio e arquivo e o sinal workspace, sendo que  a
%   primeira coluna corresponde ao tempo; as demais correspondem ao sinal
%
% [diretorio,arquivo,sinal,fa]=BACload(...)
%   fa é a frequencia de amostragem (Hz)
%
% Atualizada em 20-Aug-2011 por Paulo R. Fonseca

% ======== considera entradas
switch nargin
    case 0 % sem entradas, usa interface para carregar
        [fname,pname]=aux_interf_load(cd);        
        if isequal(fname,0);  BACmsg('usrcanc'); return;
        else
            if exist(fullfile(pname,fname),'file') % carrega se existe
                BACmsg('arqselec',fullfile(pname,fname));
                sinal=load(fullfile(pname,fname));
            else % erro se não existe arquivo
                BACmsg('arqnaoexiste',fullfile(pname,fname));return;
            end
        end
        
    case 1 % somente variavel
        entrada=varargin{1};
        if isnumeric(entrada)
            sinal=entrada;	fname=inputname(1);     pname=cd;
        elseif ischar(entrada);
            if exist(entrada,'var');
                sinal=varargin{1};
                fname=inputname(1);
                pname=cd;
            elseif exist(entrada,'file')
                [pname, fname, ext]=fileparts(entrada);
                if isempty(pname);pname=cd;end
                fname=[fname ext];
                sinal=aux_existearquivo(fname,pname); % verifica se existe e carrega
            else
                % sugere outra sintaxe caso entre string e não exista sinal
                BACmsg('arqnaoexiste',entrada);disp([10,10,'tecle ENTER']);pause
                BACmsg('outrasintaxe',['BACload(',entrada,');']);return;
            end
        end
        
    case 2 % caminho
        pname=varargin{1};
        fname=varargin{2};
        sinal=aux_existearquivo(fname,pname); % verifica se existe e carrega
    otherwise
        BACmsg('naoprevisto',mfilename);return;
end

fa=aux_freqam;

t=(1/fa:1/fa:length(sinal)/fa)';

nc=size(sinal,2);
if nc==1; txtcanal= 'um canal.';
else txtcanal=[num2str(nc), ' canais.'];
end
clc;disp(['Este sinal possui ',txtcanal]); clear txtcanal;
ncanais=input('Qual canal deseja visualizar? (ENTER para todos 0 para nenhum) \n');
if isempty(ncanais)
    ncanais=1:nc;clear nc;
end
if ncanais~=0;
    legenda=[];
    for c=1:size(ncanais,2)
        k=num2str(ncanais(c));
        if size(k,2)~=2;
            k=['0',k];
        end
        legenda=[legenda;k]; %#ok<*AGROW>
        clear k
    end
    figure(800)
    plot(t,sinal(:,ncanais))
    xlabel('tempo (s)')
    legend(legenda)
    grid on
    title(fname)
end
% sinalsaida=[t,sinal];





% ======== considera saidas
switch nargout
    case 0
    case 1
        varargout{1}=sinal;
    case 3
        varargout{1}=pname;
        varargout{2}=fname;
        varargout{3}=sinal;
    case 4
        varargout{1}=pname;
        varargout{2}=fname;
        varargout{3}=sinal;
        varargout{4}=fa;
    otherwise
        BACmsg('naoprevisto',mfilename);return;
end

end



