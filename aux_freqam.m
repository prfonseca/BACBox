function fa=aux_freqam
% seleciona frequencia de amostragem
clc; 
fa=input('Qual a frequência de amostragem (Hz)? \n ENTER para 10 Hz \n');
if isempty(fa);  fa=10; end
end