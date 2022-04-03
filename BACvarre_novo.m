% function varargout=BACvarre(varargin)
% 
% sino=varagin{1};
clc;close all;
clear dados espaco fname pname h1 c d sino arranjo sinograma sistema

[fname,pname]=aux_interf_load;
load(fullfile(pname,fname)); 
sino=sinograma;

% espacamento entre os pontos na amostragem
d=0.25; %cm

% distancia entre os sensores
bac13=3.5;% cm
bac37=2.25;% cm

sistema=input('Qual é  o sensor utilizado? \n[1] --> BAC13 \n[2] --> BAC37 \n\n');
if sistema==1
    espaco=bac13/d;
    sistema='13';
elseif sistema==2
    espaco=bac37/d;
    sistema='37';
else
    error('resposta inválida');
end



h1=figure;
subplot(221); mesh(sino(:,:,1)); title('1'); axis square;
subplot(222); mesh(sino(:,:,2)); title('2'); axis square;
subplot(223); mesh(sino(:,:,3)); title('3'); axis square;
subplot(224); mesh(sino(:,:,4)); title('4'); axis square;

% arranjo dos sensores
clc;
arranjo=input('Qual o arranjo dos sensores? \n ex: [1,4,2] \n');
close(h1);
dados=zeros(size(sino,1),size(sino,2)+2*espaco,3);
for c=1:size(sino,1)
dados(c,2*espaco-1+(1:size(sino,2)),1)=sinograma(c,:,arranjo(1));
dados(c,1*espaco-1+(1:size(sino,2)),2)=sinograma(c,:,arranjo(2));
dados(c,1:size(sino,2),             3)=sinograma(c,:,arranjo(3));
end
dados=dados(:,espaco:(end-espaco),:);
novotomo=median(dados,3);

figure, mesh(novotomo); title(sistema);

BACrecon(novotomo)


% figure,
% subplot(221); mesh(dados(:,:,1)); title('1'); axis square;
% subplot(222); mesh(dados(:,:,2)); title('2'); axis square;
% subplot(223); mesh(dados(:,:,3)); title('3'); axis square;