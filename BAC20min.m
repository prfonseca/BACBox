function BAC20min(varargin)
% Abre um sinal, corta janela de 20 minutos e calcula sua FFT.
%
% Sintaxes poss�veis:
%   BAC20min(sinal_do_workspace); : utiliza um sinal ja carregado no MatLab
%   BAC20min;                     : seleciona um sinal para carregar
%
% Desenvolvimento:
%    Murilo Stelzer; Paulo Fonseca
% Ultima atualiza��o:
%   Paulo Fonseca, em 20/02/2012.

aux_abertura(mfilename); % chama a abertura


%%%%% considera entradas
switch nargin
    case 0;[pname,fname,sinal]=carrega; % selecionar arquivo
    case 1;[pname,fname,sinal]=carrega(varargin{1},inputname(1)); % usuario entra sinal
    case 2;[pname,fname,sinal]=carrega; % chamada via BACBox
end
if isempty(sinal); return; end;

%%%%% Parametros gerais
m=3; k=1000;                % pontos inicial e final que serao representados na FFT
faq=aquisicao;              % seleciona frequencia de aquisicao
[n, ncanais]=size(sinal);   % numero de pontos e de canais desse canal
f=(m:k)*(faq/2)/(n/2);      % eixo de frequencia
t=1/faq:1/faq:n/faq;        % eixo de tempo
vintemin=20*60*faq;         % numero de pontos equivalentes a 20 min


%%%%% seleciona um canal para testar
S=num2str((1:ncanais)');
[Selection,ok] = listdlg('ListString',S,...
    'CancelString','Cancelar',...
    'PromptString','Selecione um sinal para fazer os cortes',...
    'SelectionMode','single');
if ok==0; clc; disp('Cancelado pelo usu�rio'); return; end
canal=Selection; % toma o canal selecionado
clear Selection ok


%%%%% filtra todos os canais
pb=[0.003 0.02];[B,A]=butter(2,pb);         % calcula butterworth passa banda
sinalf=zeros(size(sinal));                  % cria sinal filtrado
for c=1:ncanais
    sinalf(:,c)=filtfilt(B,A,sinal(:,c));   % filtra cada canal
end

%%%%% toma um dos canais para processar
M=sinal(1:n,canal);     % sinal original
Mf=sinalf(1:n,canal);   % sinal filtrado
%M=M-mean(M);           % caso queira remover valor m�dio do sinal

%%%%% FFTs
Ft=abs(fft(M,n));       % faz FFT sinal original
P=conj(Ft).*Ft/n;       % espectro
P1=P(m+1:k+1);          % seleciona uma parte do espectro para representar

FFt=abs(fft(Mf,n));     % calcula FFT sinal filtrado
PP=conj(FFt).*FFt/n;    % espectro
PP1=PP(m+1:k+1);        % seleciona uma parte do espectro para representar

figure
subplot(2,3,1:2); plot(t,M); grid;  % plota sinal original
title(fname);xlabel('Tempo (s)');ylabel('Intensidade (u.a.)'); % titulo e eixos
subplot(2,3,4:5); plot(t,Mf); grid; % plota sinal filtrado
title([fname,' filtrado']);xlabel('Tempo (s)');ylabel('Intensidade (u.a)')

subplot(2,3,3); plot(f,P1); grid; % FFT sinal original
title(fname); xlabel('Freq��ncia (Hz)'); ylabel('Intensidade (u.a)')
subplot(2,3,6); plot(f,PP1); grid % FFT sinal filtrado
title([fname,' filtrado']);xlabel('Freq��ncia (Hz)');ylabel('Intensidade (u.a)')

disp('Pressione uma tecla'); pause % faz uma parada para avaliar o gr�fico

%%%%% corta

if n>vintemin % sinal maior que 20 min
    posnova=1;
    figure(gcf);clf;
    subplot(2,2,1:2);
    plot(t,Mf);grid;title('AGORA SELECIONE ONDE SER� A NOVA POSICAO 0');xlabel('Tempo (s)');
    hold on
    plot(ones(2,1)*t(posnova),[min(Mf(:)) max(Mf(:))],':g','linewidth',4)
    plot(ones(2,1)*(t(posnova+vintemin)),[min(Mf(:)) max(Mf(:))],':r','linewidth',4)
    hold off
    legend({'Sinal','Marca de 0 min', 'Marca de 20 min'},'location','EastOutside')
    [posnova,posy] = ginput(1); clear posy %#ok<NASGU>;
    posnova=round(posnova*faq);
    disp(['Sua posicao �: ',num2str(posnova)])
    if posnova+vintemin>length(Mf)
        posnova=length(Mf)-vintemin;
        disp('ATENCAO voce selecionou um ponto que excede o tamanho do sinal.');
        disp(['sua nova posi��o foi ajustada para: ',num2str(posnova)])
    end
    
    subplot(223)
    plot(t(posnova:(posnova+vintemin)),Mf(posnova:(posnova+vintemin)));grid;title('CORTADO');xlabel('Tempo (s)');
    subplot(224)
    novoFF=Mf(posnova:(posnova+vintemin-1));
    NFF=abs(fft(novoFF,length(novoFF)));      % faz FFT sinal
    PNFF=conj(NFF).*NFF/length(novoFF);       % espectro
    novof=(m:k)*(faq/2)/(vintemin/2);         % eixo de frequencia
    plot(novof,PNFF(m+1:k+1))
    grid;title('FFT CORTADO');xlabel('Frequencia (Hz)');
    
    tabom=questdlg('Ficou bom?','Avalicao do corte','Yes','No','Yes');
    switch tabom
        case 'Yes'; tabom=1;
        case 'No';  tabom=0;
    end
    while tabom==0
        posnova=1;
        figure(gcf);clf;
        subplot(2,2,1:2);
        plot(t,Mf);grid;title('AGORA SELECIONE ONDE SER� A NOVA POSICAO 0');xlabel('Tempo (s)');
        hold on
        plot(ones(2,1)*t(posnova),[min(Mf(:)) max(Mf(:))],':g','linewidth',4)
        plot(ones(2,1)*(t(posnova+vintemin)),[min(Mf(:)) max(Mf(:))],':r','linewidth',4)
        hold off
        legend({'Sinal','Marca de 0 min', 'Marca de 20 min'},'location','EastOutside')
        [posnova,posy] = ginput(1); clear posy %#ok<NASGU>;
        posnova=round(posnova*faq);
        clc;
        disp(['Sua posicao �: ',num2str(posnova)])
        if posnova+vintemin>length(Mf)
            posnova=length(Mf)-vintemin;
            disp('ATENCAO voce selecionou um ponto que excede o tamanho do sinal.');
            disp(['sua nova posi��o foi ajustada para: ',num2str(posnova)])
        end
        subplot(223)
        plot(t(posnova:(posnova+vintemin)),Mf(posnova:(posnova+vintemin)));
        grid;title('CORTADO');xlabel('Tempo (s)');
        subplot(224)
        novoFF=Mf(posnova:(posnova+vintemin-1));
        NFF=abs(fft(novoFF,length(novoFF)));       % faz FFT sinal
        PNFF=conj(NFF).*NFF/length(novoFF);       % espectro
        novof=(m:k)*(faq/2)/(vintemin/2);         % eixo de frequencia
        plot(novof,PNFF(m+1:k+1))
        grid;title('FFT CORTADO');xlabel('Frequencia (Hz)');
        tabom=questdlg('Ficou bom?','Avalicao do corte','Yes','No','Yes');
        switch tabom
            case 'Yes'; tabom=1;
            case 'No';  tabom=0;
            case 'Cancel'; error('Cancelado pelo usuario');
        end
        
    end
    % aplica o corte para todos os sinais
    [pot20c,sinalc]=fazpratodos(sinalf,ncanais,posnova,vintemin,faq,m,k);
    salva(pot20c,sinalc,fname,pname)% salva 

elseif n==vintemin
    clc;
    warndlg('Sinal selecionado tem exatamente vinte minutos','Aten��o','modal')
    return;
else % caso sinal seja menor que 20 min
    clc;
    errordlg('Sinal selecionado � menor que vinte minutos','Erro','modal');
    return;
end
end
%%%%%%%%%% Fun��es adicionais

function salva(pot20c,sinalc,fname,pname) %#ok<INUSL>
    [s1,s2]=strtok(fname,'.');
    nomesaidasinal=fullfile(pname,[s1,'_20min',s2]);
    nomesaidafft=fullfile(pname,[s1,'_FFT20min',s2]);
    save(nomesaidasinal, 'sinalc','-ascii')
    save(nomesaidafft,   'pot20c','-ascii')
    superstring=['Arquivos salvos em: ',nomesaidasinal,10,' e ',10, nomesaidafft];
    clc;
    aux_logobiomag
    disp(' ')
    disp('Processamento conclu�do');
    
    helpdlg(superstring,'Informa��o:');
end

function [pot20c,sinalc]=fazpratodos(sinal,ncanais,posnova,vintemin,faq,m,k)
% recebe configura��es de corte e filtragem feitas para um canal e repete
% para todos os canais do sinal

novof=(m:k)'*(faq/2)/(vintemin/2);         % eixo de frequencia
novot=1/faq:1/faq:vintemin/faq;           % eixo de tempo

sinalc=zeros(length(novot),ncanais);
pot20c=zeros(length(novof),ncanais);

    for c=1:ncanais
        sinalc(:,c)=sinal(posnova:(posnova+vintemin-1),c); 
        fft20=abs(fft(sinalc(:,c),vintemin));              % faz FFT sinal
        pot20=conj(fft20).*fft20/vintemin;                 % espectro
        pot20c(:,c) = pot20(m+1:k+1);                      % corta espectro
        
        figure,                                            % plota
        subplot(211);plot(novot,sinalc(:,c));title(['canal ',num2str(c),' cortado']);grid on;
        subplot(212);plot(novof,pot20c(:,c));title(['FFT canal ',num2str(c),' cortado']);grid on;
    end
    whos
    pot20c=[novof, pot20c];
end


function faq=aquisicao
% frequencia de aquisicao - interface
fa = questdlg('Qual a frequencia de aquisi��o?', ...
    'Frequencia de aquisi��o', ...
    '10 Hz','20 Hz','Outra','20 Hz');
switch fa
    case '10 Hz'; 	faq=10; % botao 10 Hz
    case '20 Hz';   faq=20; % botao 20 Hz
    case 'Outra'    % caixa de dialogo para digitar
        prompt = {'Qual a frequencia de amostragem? (Hz)'};
        dlg_title = 'Digitar Faq'; num_lines = 1;   def = {'20.0'};
        faq= inputdlg(prompt,dlg_title,num_lines,def);
        faq=str2double(cell2mat(faq));
end
end

function [pname,fname,sinal]=carrega(varargin)
% carrega arquivo ou variavel do workspace
if nargin==0 % seleciona um arquivo
    [fname,pname]=uigetfile({'*.*','Todos os arquivos'},'Selecione Arquivo',cd);
    if fname==0;clc;disp('Cancelado pelo usu�rio'); sinal=[]; return;
    else clc;disp('Arquivo selecionado:');disp(fullfile(pname,fname));
        sinal=load(fullfile(pname,fname));
    end
else
    sinal=varargin{1};
    fname=[varargin{2},'.txt'];
    pname=cd;
    disp(fullfile(pname,fname))
end
end
