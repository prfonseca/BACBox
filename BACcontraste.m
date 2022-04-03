%processa duas aquisições para produzir contraste por diferença de excitação

% contraste por excitacao
[fname_sem,pname_sem]=uigetfile({'tBAC*.lvm';'tBAC files'},'Selecionar Arquivo "Normal" ',cd);
[fname_com,pname_com]=uigetfile({'tBAC*.lvm';'tBAC files'},'Selecionar Arquivo "Com terceira excitadora"',pname_sem);

quermulti=input('Deseja utilizar sinograma multi-canais? \n 0 -> nao 1 -> sim \n');
if isempty(quermulti); quermulti=1; end

sino_sem=BACquebra(pname_sem,fname_sem);
sino_com=BACquebra(pname_com,fname_com);
if quermulti==1
    sino_sem=BACvarre(sino_sem);
    sino_com=BACvarre(sino_com);
end
clear quermulti
%% reconstrucao
minterp='none'; % metodo de interpolacao
janela='none'; % janelai
clc;disp('Primeiro sinal')
tomo_sem=BACrecon(sino_sem,minterp,janela,3.6);
clc;disp('Segundo sinal')
tomo_com=BACrecon(sino_com,minterp,janela,3.6);

% diferenca=zeros(size(tomo_sem));

%% laco
limiarcorte=0.30;
for c=1:size(tomo_sem,3)%[1 4 7]%
    tomos=tomo_sem(:,:,c);
    tomoc=tomo_com(:,:,c);
    di=tomoc-tomos;
    di=real(sqrt(di));
    di0=di-min(di(:));
    diN=di0/max(di0(:));
%     di2=diN.^2;
    dia=imadjust(diN,[limiarcorte,1],[0 1],2);
    figure
    

    subplot(231);imagesc(tomos);axis square; title('Aquisicao Normal');
    subplot(232);imagesc(tomoc);axis square; title('Compensada');
    subplot(233);imagesc(di);axis square; title(['Imagem de diferença ', num2str(c)]);
    subplot(234);imagesc(di0);axis square; title('Zerada');
    subplot(235);imagesc(diN);axis square; title('Normalizada');
    subplot(236);imagesc(dia);axis square; title('Imagem final');
end

