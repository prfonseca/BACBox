function novomap

fh=gcf;             %pega a figura atual
BACmenu(fh);        %põe o menu;
th=uitable;         %cria a tabela
coord=get(fh,'position');           % coordenadas da janela principal
set(th,'ColumnWidth',{30});         % largura das colunas
set(th,'BackgroundColor',[0 1 1]);  % cor de fundo da tabela
set(th,'Position',[coord(1)-250-100 coord(2)+180-100 250 160]) % dimensões
set(th,'Tag','tabela');             % tag da tabela
padrao                              % valores padrao da tabela
set(th,'ColumnEditable',true(1,7)); % define colunas editaveis

uicontrol('Style', 'pushbutton', 'String', 'Padrão',...
        'Position', [coord(1)-250-100 coord(2)+180-150 50 20],...
        'Callback', @padrao);

uicontrol('Style', 'pushbutton', 'String', 'Girar 90º',...
        'Position', [coord(1)-250-25 coord(2)+180-150 50 20],...
        'Callback', @noventa);
  
uicontrol('Style', 'pushbutton', 'String', 'Ok',...
        'Position', [coord(1)-250+50 coord(2)+180-150 50 20],...
        'Callback', @feito);

    
figure(fh)
end

function padrao(varargin)
    th=findobj(gcf,'Tag','tabela');
    sens=[
        0        8          0          13       0
        0        0          7          0        0
        0        2          0          6        0
        9        0          1          0        12
        0        3          0          5        0
        0        0          4          0        0
        0        10         0          11       0];
    Sens=zeros(7);      Sens(:,2:6)=sens;  clear sens
    set(th,'Data',Sens); % joga as posições dentro da tabela
end

function noventa(varargin)
    th=findobj(gcf,'Tag','tabela');
    Sens=get(th,'Data');
    Sens=Sens';
    set(th,'Data',Sens);
end

function feito(varargin)
    th=findobj(gcf,'Tag','tabela');
    Sens=get(th,'Data');
    n0=Sens(Sens~=0);
    n0=sort(n0)';
    if length(n0)>1
        for c=2:length(n0)
            if n0(c)==n0(c-1)
                errordlg(['Sensor está ', num2str(n0(c)),' repetido.',10,'Refaça'],'Erro','modal')
                return
            end
        end
    end
    setappdata(gcf,'sens',Sens);
end