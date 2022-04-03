function varargout=BACvarre(varargin)
% coleta sinogramas de cada canal para produzir sinogramas compostos por
% varredura
% Sintaxes possíveis
%   novos_sinogramas=BACvarre
%   novos_sinogramas=BACvarre('arquivo'),    arquivo é o caminho completo
%                               para uma medida tBAC
%   novos_sinogramas=BACvarre(sinogramas),   sinogramas é uma variável 3D 
%                               com os sinogramas a serem processados
%   novos_sinogramas=BACvarre(sinogramas,arranjo), arranjo é uma matriz 2D
%                               contendo a disposição espacial dos sensores

%% entradas e saidas
% considera as entradas
switch nargin
    case 0 % caso nao seja fornecida entrada, carrega sinograma
        [fname,pname]=aux_interf_load;
        if isequal(fname,0);  BACmsg('usrcanc'); return;
        else
            if exist(fullfile(pname,fname),'file') % carrega se existe
                BACmsg('arqselec',fullfile(pname,fname));
                load(fullfile(pname,fname));
                sino=sinograma;
                clear sinograma;
            else % erro se não existe arquivo
                BACmsg('arqnaoexiste',fullfile(pname,fname));return;
            end
        end
    case 1 % caso seja fornecida uma entrada
        if strcmp(class(varargin{1}),'double'); sino=varargin{1}; % variável
        elseif ischar(varargin{1});           
            [~,fmt]=strtok(a,'.');
            if strcmp(fmt,'.mat')
                load(varargin{1});      sino=sinograma;     clear sinograma;
            elseif strcmp(fmt,'.lvm')||strcmp(fmt,'.txt')
                sino=BACquebra(varargin{1}); % sinal
            end
        else BACmsg('naoprevisto',mfilename); return; % erro caso nao previsto
        end
    case 2 % caso usuário já entre sinograma e arranjo
        sino=varargin{1};
        sens=varargin{2};
    otherwise
        BACmsg('naoprevisto',mfilename)
        return
end
% considera saidas
if nargout==0;     BACmsg('semsaida',mfilename);    return;     end



%% pre-varredura
[nang nptos nsino]=size(sino); % numero de tomografias
if nptos==81
    Sino=sino(1:nang,1:(nptos-1),1:nsino);
else
    Sino=sino;
end
% Sino=Sino-min(Sino(:));
% Sino=Sino+1;
% Sino=Sino/max(Sino(:));
[nang nptos nsino]=size(Sino); % numero de tomografias
if exist('sens','var')==0
    if nsino==13 % posicao dos sensores
        sens=BACsensor(1:13);
    else
        quais=input(['Foram detectados ',num2str(nsino),' sinogramas. \n',...
            'A quais canais eles correspondem? \n']);
        sens=BACsensor(quais);
    end
end
senspos=find(sens~=0);

% faz varredura e novo sinograma
novosino=zeros(nang, (size(sens,2)-1)+nptos,size(sens,1));
for ca=1:nang
    sinoa=squeeze(Sino(ca,:,:));
    Var=zeros(size(sens,1),(size(sens,2)-1)+nptos,nptos);
    for c=1:nptos
        Sens=sens;
        Sens(senspos)=sinoa(c,Sens(senspos));
        Var(:,c+(0:(size(sens,2)-1)),c)=Sens;
    end
    Var0=sum(Var~=0,3);
    VarS=sum(Var,3);
    VarM=VarS./Var0;
    novosino(ca,1:size(VarM,2),1:size(VarM,1))=VarM';
%     figure(1),imagesc(VarM);axis square;title(num2str(ca));drawnow
end
varargout{1}=novosino;

end