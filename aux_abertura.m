function aux_abertura(nome_arquivo)
% faz abertura de rotinas com logo, help e fechamento de janelas

clc;
aux_logobiomag

disp(['====== ' nome_arquivo]);
help(nome_arquivo);

fecha = questdlg('Fechar todas as figuras abertas antes de iniciar?','Fechar','Sim','N�o','Sim');
if strcmp(fecha,'Sim'); close all; end;
end
