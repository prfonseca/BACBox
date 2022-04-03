clear 

load ..\tBAC_data\'sino_tbac_2011_01_27_duas barras.mat'
sino=sinograma; clear sinograma;

[nang nptos nsino]=size(sino);              % dimensoes do sinograma

sens=BACsensor(1);                   % cria matriz de sensores
possens=find(sens~=0);                     % posicao dos sensores
[sx sy]=size(sens);                        % dimensao da matriz de sensores

novamat=zeros(sx,nptos+sy-1);

% for csino=1:nsino
    for cang=1:nang                            % para todas posicoes angulares

        for cptos=1:nptos
            sensaux=sens;
            valor=(sino(cang,cptos,:));
            sensaux(possens)=valor(sens(possens));
            novamat(1:sx,(1:sy)+cptos-1)=novamat(1:sx,(1:sy)+cptos-1)+sensaux;
        end
        imagesc(novamat);title(num2str(cang));drawnow
    end
% end