function interpolada=BACzero(tam_zer,b,ini,inj,n_interp,metodo)
% -------------------------
% toma uma imagem b de dimensão quadrada de ordem 5,7,9 ou 13 e insere numa
% matriz quadrada nula (zeros) de ordem tam_zer nas coordenadas
% especificadas em (ini,inj). Em seguida, faz n_interp interpolações dessa
% matriz pelo metodo escolhido.
% -------------------------

% insersão de zeros
[dix diy]=size(b);
if [dix diy]<[tam_zer tam_zer] %#ok<BDSCA>
    Matriz=zeros(tam_zer);
    if (ini+dix)>tam_zer || (inj+diy)>tam_zer
        errordlg(['Cuidado, suas coordenadas excedem ',int2str(tam_zer), 'x',...
            int2str(tam_zer)],'Erro');
        return;
    else
        Matriz(ini+(0:dix-1),inj+(0:diy-1))=b;
    end
elseif [dix diy]>[tam_zer tam_zer]
    errordlg(['Cuidado, imagem maior que ',int2str(tam_zer), 'x',int2str(tam_zer)],...
        'Erro');
end
b=Matriz; clear Matriz
switch metodo
    case 1
        metodo='spline';
    case 2
        metodo='cubic';
    case 3
        metodo='linear';
    case 4
        metodo='nearest';
end
interpolada=interp2(b,n_interp,metodo);
if size(interpolada)==[257 257]
    interpolada=interpolada(2:257,2:257);
else
    interpolada=imresize(interpolada,[256 256]);
    helpdlg('Sua imagem foi redimensioada para 256x256','Redimensionamento');
end
end