function aux_mostrasinalfft(t,sinal,f,Y,titulo)
% mostra sinal e sua FFT
% t é o eixo do tempo
% sinal é a variável que contem o sinal (1D)
% f é o eixo de frequencias
% Y é o espectro de Fourier (módulo da TF)
% titulo é o título do gráfico
%
% Desenvolvida em 22-Aug-2011 por Paulo Fonseca.


    figure
    subplot(211);
    plot(t,sinal);grid;
        xlabel('Tempo (s)');
        ylabel('Amplitude (u.a.)')
        if isempty(titulo)==0; title(titulo);  end
        axis([min(t) max(t) 1.1*min(sinal(:)) 1.1*max(sinal(:))])
	subplot(212)
    plot(f,Y);grid;
        xlabel('Frequencia (Hz');
        ylabel('Amplitude (u.a.)');
        grid on;
        axis([min(f) max(f) 0 1.1*max(Y)])
end