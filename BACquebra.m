function dados=BACquebra(varargin)
% recebe dados experimentais e cria sinogramas.
% Sintaxes possíveis:
%   sinogramas=BACquebra;
%   sinogramas=BACquebra('diretorio','arquivo');
clc



%% entradas
if nargin==2&&isnumeric(varargin{1})
    nargo=0;
else
    nargo=nargin;
end
switch nargo
    case 0 % usa interface
        [filename, pathname] = aux_interf_load; % seleciona arquivo e diretorio
        if isequal(filename,0); BACmsg('usrcanc',mfilename); return; end
    case 2
        filename=varargin{2};
        pathname=varargin{1};
    otherwise
        BACmsg('naoprevisto',mfilename);return
end

BACmsg('arqselec', fullfile(pathname, filename))
fid=fopen(fullfile(pathname,filename)); % abre para leitura
%% pre-processamento do sinal
% carrega um sinal, determina valores de maximo e minimo e tambem posiciona
% adequadamente os clocks coletados

frewind(fid);

dadosinic=zeros(25e3,15);
for c=1:length(dadosinic)
    tline = fgets(fid);
    dadosinic (c,:)= str2num(tline); %#ok<ST2NM>
end

logica1=dadosinic(:,14);    logica2=dadosinic(:,15);
mlog1=max(logica1)/2;       mlog2=max(logica2)/2;
logica1=logica1>mlog1;      logica2=logica2>mlog2;
slog1=sum(logica1);         slog2=sum(logica2);

if slog1>slog2
    vai=14; med=15; logicavai=mlog1; logicamed=mlog2;
else
    vai=15; med=14; logicavai=mlog2; logicamed=mlog1;
end
% logicavai=max(dadosinic(:,14))/2;
% logicamed=max(dadosinic(:,15))/2;

clear dadosinic logica1 logica2 mlog1 mlog2 slog1 slog2

%% processamento do sinal
frewind(fid);   dados=[];   tem=0;  ntheta=0;   nr=0;   verprox=0;
while ~feof(fid)
    %     tline = str2num(fgets(fid));
    tline = fscanf(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',[1,15]);
    if size(tline)==[1,15] %#ok<BDSCA>
        if tline(1,vai)>logicavai % verificar 14
            if tline(1,med)>logicamed % verificar 15
                switch tem
                    case 0 % caso seja primeiro ponto daquela projecao
                        nr=nr+1;
                        som=tline(1:13);      k=1; tem=1;
                    case 1
                        som=som+tline(1:13);  k=k+1;
                end
            else%if tline(1,15)<logicamed
                if exist('som','var')
                    if ntheta==0; ntheta=1; end
                    dados(ntheta,nr,1:13)=som/k; %#ok<AGROW>
                    clc;
                    fprintf('r = %d theta = %d \n',nr,ntheta)
                    tem=0; clear som; verprox=1;
                end
            end
            %         disp(nr)
        else
            if verprox==1
                ntheta=ntheta+1;
                verprox=0;
                nr=0;tem=0;
                clear som;
                 
            end
        end
    end
    %     disp(ftell(fid))
end
fclose(fid);

sinograma=dados; %#ok<NASGU>
newname=fullfile(pathname,['sino_',strtok(filename,'.'),'.mat']);
save(newname,'sinograma');
clear sinograma

BACmsg('comprimindo');%informa
newnamezip=fullfile(pathname,[strtok(filename,'.'),'.zip']);
zip(newnamezip,fullfile(pathname, filename)) % comprime

delete(fullfile(pathname, filename))   % exclui sinal original
BACmsg('arqsalvo',newname) %informa