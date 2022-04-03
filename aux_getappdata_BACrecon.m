% retira informacoes da interface da BACrecon e deixa como variáveis
clc                                                                 % limpa tela

% caixa de dialogo para verificar detalhes
sn=questdlg(['Deseja detalhes como:',10,...
    '* nome do arquivo', 10,...
    '* angulos, tamanho',10,...
    '* metodo de interpolacao',10,...
    '* arranjo dos sensores',10,...
    '* janela de reconstrucao'],'Verificando','Sim','Não','Não');


if strcmp(sn,'Sim') % se usuario selecionar sim, coleta informacoes
    BACnomesino  = getappdata(gcf,'nomesino');
    BACtheta     = getappdata(gcf,'theta');
    BACtam       = getappdata(gcf,'tam');
    BACinterp    = getappdata(gcf,'interp');
    BACjanela    = getappdata(gcf,'janela');
end

novosino=getappdata(gcf,'novosinos');

if isempty(novosino)
    disp('Reconstrucao realizada com canal(is) independente(s)');   % informa
    BACtomo      = getappdata(gcf,'tomo');
    clear novosino                                                  % limpa variavel
else
    disp('Reconstrucao multi-canais');                              % informa
    BACnovosino  = getappdata(gcf,'novosinos');
    BACnovotomo  = getappdata(gcf,'novotomo');
    
    if strcmp(sn,'Sim') % se usuario selecionar sim, coleta informacoes
        BACsens         = getappdata(gcf,'sens');
    end
end
sinograma = getappdata(gcf,'sinograma');


clear sn;           % limpa variavel

disp([10,'As imagens e variaveis desta reconstrucao estao disponiveis no workspace.',...
    10, 10, 'Boa diversao. ']);

close(gcf)
