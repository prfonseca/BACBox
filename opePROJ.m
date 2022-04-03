function [opeR]=opePROJ(th,dim)

% variável de entrada dim = dimensão da imagem reconstruída
% variável de entrada th = número de passos angulares 0 - 360

% variável de saída opeR = matriz (l x dim^2) do operador projeção
                         % o número de linhas depende de dim

display(' ')
display('OPERADOR PROJECAO - TRANSFORMADA DE RADON')
display(' ')

std=zeros(dim);
k=1;
        sss=360/th;
        theta = 0:sss:(360-sss);
% theta = linspace(0,360,th);

for i=1:dim;
    for j=1:dim;
        std(i,j)=1;
        R = radon(std,theta);
        R=R(:);
        a=sum(R);
        R=a\R;% R=inv(a)*R;
        opeR(:,k)=R; clear R
        k=k+1;
%         std=zeros(dim);
        std(i,j)=0;
    end
    disp(num2str(i/dim))
end

% save('C:\Users\USUARIO\Desktop\OPERADOR_RADON\teste_sunga_100','opeR','-v7.3')

sound(sin(1:2000));

display(' ')
display('CÁLCULO TERMINADO')
display(' ')

end

