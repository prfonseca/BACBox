function varargout=BACimg(varargin)
% produz imagens a partir da leitura de N canais, especificados em
% BACsensor.
%
%sintaxes possíveis
%
% BACimg(sinal)
%   para especificar uma variavel existente no workspace
%
% BACimg('diretorio','arquivo')
%   para especificar um arquivo
%
% BACimg('manual')
%   para entrar manualmente todos os canais

% considera entradas

% switch nargin
%     case 0 % sem entrada. seleciona arquivo
%         
% end






switch nargin
    case 0; BACmsg('naoprevisto',mfilename);return;
    case 1 % uma entrada
        if ischar(varargin{1})
            if strcmp(varargin{1},'manual') %verifica se corresponde 'manual'
                sig=input(['entre dados \n ex: ',...
                    '[valor 1, valor2, ..., valor 13] \n']);
            else BACmsg('naoprevisto',mfilename);return;
            end
        else
            sig=varargin{1};
        end

    case 2
        filename=varargin{2};
        pathname=varargin{1};
        sig=load(fullfile(pathname,filename));
    otherwise
        BACmsg('naoprevisto',mfilename);
        return;
end


sens=BACsensor;% distribuicao dos sensores
maux=sens; % distribuicao dos sensores
pos1=find(maux~=0);


if manual==0 % caso não seja coleta manual
    figure(98), plot(sig)
    intervalo=input('entre intevalo (pontos) [inicio final] \n');
    sig=mean(sig(intervalo(1):intervalo(2),:));
end
clear manual 

for cp=1:length(pos1) % atribui
    maux(pos1(cp))=sig(1,sens(pos1(cp)));
end

% calcula medias ou pondera com psf
pondera=input('[1] Calcula por média simples \n[2] Calcula por média ponderada com psf \n');
switch pondera
    case 1
        maux(1,3)=mean([maux(1,2),maux(1,4),maux(2,3)]);
        maux(2,2)=mean([maux(1,2),maux(3,2),maux(2,3)]);
        maux(2,4)=mean([maux(2,3),maux(1,4),maux(2,4)]);
        maux(6,2)=mean([maux(5,2),maux(7,2),maux(6,3)]);
        maux(6,4)=mean([maux(6,3),maux(5,4),maux(7,4)]);
        maux(7,3)=mean([maux(6,3),maux(7,2),maux(7,4)]);
        maux(4,2)=mean([maux(4,1),maux(4,3),maux(3,2),maux(5,2)]);
        maux(4,4)=mean([maux(4,3),maux(4,5),maux(3,4),maux(5,4)]);
        maux(3,3)=mean([maux(2,3),maux(4,3),maux(3,2),maux(3,4)]);
        maux(5,3)=mean([maux(4,3),maux(6,3),maux(5,2),maux(5,4)]);
    case 2
        load psf13.mat
        [xi,yi]=meshgrid(-3:3);
        [x,y]=meshgrid(-3.5:.5:3.5);
        PSF=interp2(x,y,psf,xi,yi,'spline');
        PSF=PSF/max(PSF(:));
       
        pond=zeros([size(sens),length(pos1)]);
        for k=1:length(pos1)
            auxiliar=sens;
            auxiliar=auxiliar==sens(pos1(k));
            auxiliar=conv2(double(auxiliar),PSF,'same');
            pond(:,:,sens(pos1(k)))=auxiliar;
            clear auxiliar
        end
        % busca pontos iguais a zero
        nzero=maux~=0;
        mask=[0 1 0; 1 0 1; 0 1 0];
        onde=conv2(double(nzero),mask,'same');
        npontoscalc=[2 3 4]; % num pontos para calcular valor
        figure(8000)
        subplot(2,2,1);imagesc(sens);axis square;title('sensores')
        for l=1:length(npontoscalc)
            [ondex ondey]=find(onde==npontoscalc(l));
            subplot(2,2,npontoscalc(l));imagesc(onde==npontoscalc(l));axis square;title(num2str(npontoscalc(l)))
            for m=1:length(ondex)
                zer=zeros(size(maux));
                zer(ondex(m),ondey(m))=1;
                zer=conv2(zer,mask,'same');
                ondepond=find(zer==1);
                for n=1:length(ondepond)
                    if sens(ondepond(n))>0
                        mapapond=pond(:,:,sens(ondepond(n)));
                        zer(ondepond(n))=mapapond(ondex(m),ondey(m));
                    end
                end
                zer=zer.*maux;
                zer=sum(zer(:))/npontoscalc(l);
                maux(ondex(m),ondey(m))=zer;
                clear zer ondepond
            end
            clear ondex ondey
        end
    otherwise
        BACmsg('naoprevisto',mfilename);return;
end
z=zeros(33);
z(14:20,15:19)=maux;
% z=z/max(z(:));
zi=interp2(z,3,'spline');
switch nargout
    case 1
        varargout{1}=z;
    case 2
        varargout{1}=z;
        varargout{2}=zi;
end
figure(98), imagesc(z);axis square
figure(99), imagesc(zi);axis square

    function manual()
        
    end

end

