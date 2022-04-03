function varargout=BACcomprimido(varargin)
% coleta um sinal de sete canais e gera imagens, salvando em extensão BAC


[fname,pname]=aux_interf_load;          % seleciona sinal
if fname==0; clc; BACmsg('usrcanc'); return; end
BACmsg('arqselec',fullfile(pname,fname));

sinal=load(fullfile(pname,fname));% carrega

% desativado por enquanto - recurso para comandos 
% switch nargin
%     case 0
%         [fname,pname]=aux_interf_load;          % seleciona sinal
%         if fname==0; clc; BACmsg('usrcanc'); return; end
%         BACmsg('arqselec',fullfile(pname,fname));
%         sinal=load(fullfile(pname,fname));% carrega
%     case 1
%         sinal=varargin{1}; fname=inputname(1);
%         if isnumeric(sinal)==0; sinal=load(fname); end
%     case 2
%         pname=varargin{1}; fname=varargin{2};
%         sinal=load(fullfile(pname,fname));% carrega
%     otherwise
%         BACmsg('naoprevisto',mfilename)
% end



fa=input('Freq. amostragem 10 Hz? \n ENTER p/ sim \n ou digite novo valor (Hz): \n ');
if isempty(fa); fa=10; end;

t=1/fa:1/fa:length(sinal)/fa;
aux_mostrasinal(t,sinal,fname) % exibe

figure(gcf);
title('Defina posição onde deseja gerar offset e cortar o sinal')
[x,~]=ginput(1);
x=round(x*fa);

disp(['descartando informações anteriores a ', num2str(x/fa),' s']);

sinal=sinal(x:end,:); clear x
numcanais=size(sinal,2);% numero de canais no sinal
for c=1:numcanais; sinal(:,c)=sinal(:,c)-sinal(1,c); end; clear c; % offset

figure(gcf); close;
t=1/fa:1/fa:length(sinal)/fa;
aux_mostrasinal(t,sinal,fname) % exibe

figure(gcf); title(['Determine as posições onde gerar imagens',10,10,'Botão direito indica último ponto']);

[x,~,bt]=ginput(1);
c=1; while bt~=3; c=c+1; [x(c),~,bt]=ginput(1); end; clear bt c; close(gcf);
xi=(round(x.*fa))'; clear x

interv=input('Imagens devem utilizar quantos segundos de sinal? \n ENTER p/ 3 s \n ou digite novo valor (s): \n ');
if isempty(interv); interv=3; end; % intervalo de tempo que vai gerar imagens

xf=xi+(interv.*fa);
numing=length(xf); %numero de imagens que serão geradas

vetsig=zeros(numing,numcanais);
for c=1:length(xf)
    vetsig(c,:)=mean(sinal(xi(c):xf(c),:),1);
end

sens=[
 %  C1      C2         C3         C4       C5
    0        0          0          0        0   % L1
    0        0          2          0        0   % L2
    0        3          0          7        0   % L3
    0        0          1          0        0   % L4
    0        4          0          6        0   % L5
    0        0          5          0        0   % L6
    0        0          0          0        0]; % L7

zi=zeros(257,257,1,numing);
for c=1:numing
    maux=sens; % distribuicao dos sensores
    pos1=find(maux~=0);
    for cp=1:length(pos1) % atribui
        maux(pos1(cp))=vetsig(c,sens(pos1(cp)));
    end
%     figure, imagesc(maux)

    maux(3,3)=mean([maux(2,3) maux(3,2) maux(4,3) maux(3,4)]);
    maux(5,3)=mean([maux(4,3) maux(6,3) maux(5,2) maux(5,4)]);
    maux(4,2)=mean([maux(4,3) maux(3,2) maux(5,2)]);
    maux(4,4)=mean([maux(4,3) maux(5,4) maux(3,4)]);
    maux(2,2)=mean([maux(3,2) maux(2,3) maux(3,3)]);
    maux(2,4)=mean([maux(2,3) maux(3,3) maux(3,4)]);
    maux(6,4)=mean([maux(5,4) maux(6,3) maux(5,3)]);
    maux(6,2)=mean([maux(5,2) maux(6,3) maux(5,3)]);
    maux(7,:)=maux(6,:)/2;
    maux(1,:)=maux(2,:)/2;
    maux(:,5)=maux(:,4)/2;
    maux(:,1)=maux(:,2)/2;
    
    
%     figure, imagesc(maux)   
    
    z=zeros(33);
    z(14:20,15:19)=maux;
    zi(:,:,1,c)=interp2(z,3,'spline');
end
zi=zi-min(zi(:)); % zera
zi=zi./max(zi(:)); %normalizando
figure, montage(zi,[]);
colormap(gray)
varargout{1}=zi;

[pt1,~]=strtok(fname,'.');
pt1=[pt1,'.mat'];

ondesalvar=fullfile(pname,pt1); clear pt1
uiputfile({'*.mat','MAT-File';...
          '*.*','All Files' },'Salvar dados',...
          ondesalvar)
save(ondesalvar, 'zi', 'xi','xf','fa', '-v6')

end

