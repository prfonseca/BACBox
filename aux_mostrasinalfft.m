function aux_mostrasinalfft(t,sinal,f,Y,titulo)
% mostra sinal e sua FFT
% t � o eixo do tempo
% sinal � a vari�vel que contem o sinal (1D)
% f � o eixo de frequencias
% Y � o espectro de Fourier (m�dulo da TF)
% titulo � o t�tulo do gr�fico
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