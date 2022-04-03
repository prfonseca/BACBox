function BACmap(varargin)

ph=figure(999); clf; BACmenu(gcf);

setappdata(ph,'todosdados',[]);

set(ph,'Position',[30 100 500 500],'Color',[1 1 1],...
    'Tag','tabelaprinc',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Name',':: BACBox');
uicontrol(gcf,'Style','text',...
    'String','Numero linhas',...
    'Position',[10 360 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
uicontrol(gcf,'Style','edit',...
    'String','5',...
    'Tag','smatx',...
    'Position',[150 360 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
uicontrol(gcf,'Style','text',...
    'String','Numero colunas',...
    'Position',[10 330 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
uicontrol(gcf,'Style','edit',...
    'String','5',...
    'Tag','smaty',...
    'Position',[150 330 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
uicontrol(gcf,'Style','text',...
    'String','Valor basal',...
    'Position',[10 300 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
uicontrol(gcf,'Style','edit',...
    'String','-0.05',...
    'Tag','basal',...
    'Position',[150 300 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);

uicontrol(gcf,'Style','pushbutton',...
    'String','Iniciar digitação',...
    'Position',[150 250 100 25],...
    'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph,...
    'Callback',{@tabelagui,ph});

end

function tabelagui(varargin)
% recebe instrucoes para criar uma tabela

switch nargin
    case 1
        ph=varargin{1};
    case 3
        ph=varargin{3};
    otherwise
        BACmsg('naoprevisto',mfilename)
end

nx=str2double(get(findobj(ph,'Tag','smatx'),'String'));
ny=str2double(get(findobj(ph,'Tag','smaty'),'String'));

dados=cell(nx,ny); dados(:,:)={0}; % cria dados iniciais

lin_width=25;           col_width=75;

% cria janela
k=figure(998);clf;
set(k,'Position',[400 200 (ny+3)*col_width (nx+1)*lin_width],'Color',[1 1 1],...
    'Tag','tabela',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Name',':: Tabela - BACBox');

% cria tabela
tabelah=uitable(k,'Data',dados);
set(tabelah,...
    'ColumnWidth',{col_width},...
    'Position',[0 0 (ny+1)*col_width (nx+1)*lin_width])
versao=version('-release');versao=str2double(versao(1:4));
if versao>2007;  set(tabelah,'ColumnEditable',true);end; clear versao

uicontrol('Style','pushbutton',...
    'Position',[(ny+1)*col_width+5 (nx)*lin_width 100 25],...
    'Tag','add_matriz',...
    'String','Adicionar matriz',...
    'Callback',{@meusdados,k,1})
uicontrol('Style','pushbutton',...
    'Position',[(ny+1)*col_width+5 (nx-2)*lin_width 100 25],...
    'Tag','ok',...
    'String','Processar',...
    'Callback',{@meusdados,k,0})
% uicontrol('Style','pushbutton',...
%                 'String','Pegar valores',...
%                 'Position',[150 250 100 25],...
%                 'FontSize',10,'BackGroundColor',[1 1 1],'parent',w,...
%                 'Callback',{@bla,findobj('Tag','tabela'),basal});

end

function meusdados(varargin)
% recebe os dados de tabelagui e grava em matriz

% ponteiros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=varargin{3};                          % figura que contem tabela
matrizh=findobj(k,'type','uitable');    % ponteiro da tabela
ph=findobj('Tag','tabelaprinc');        % ponteiro da principal

% dados coletados  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
basal=str2double(get(findobj(ph,'Tag','basal'),'String')); % valor basal
todosdados=getappdata(ph,'todosdados'); % variavel que armazena mapeamentos
matriz=cell2mat(get(matrizh,'Data')); % coleta valor da tabela agora
matriz(isnan(matriz))=0; % se a celula estiver em branco, preenche com 0

% atribui os dados da tabela agora
if isempty(todosdados)
    todosdados=matriz;
else
    todosdados(:,:,size(todosdados,3)+1)=matriz;
end

mais=varargin{4};




switch mais
    case 1 % caso deseje utilizar mais um mapeamento
        set(findobj(ph,'Tag','smatx'),'Enable','inactive')
        set(findobj(ph,'Tag','smaty'),'Enable','inactive')
        set(findobj(ph,'Tag','basal'),'Enable','inactive')
        setappdata(ph,'todosdados',todosdados);
        tabelagui(findobj('Tag','tabelaprinc'))
    case 0 % caso deseje processar
        close(k) % fecha figura que contem tabela
        clf(ph)  % limpa figura principal
        BACmenu(ph); % cria menu
        uicontrol(gcf,'Style','text',...
            'String',['Digitados processados ',num2str(size(todosdados,3)),' mapeamentos'],...
            'Position',[10 360 200 50],...
            'FontSize',10,'BackGroundColor',[1 1 1],'parent',ph);
        
        mX=input(['Entre com o deslocamento da imagem em X: ']);
        mY=input(['Entre com o deslocamento da imagem em Y: ']);
        
        tam_zer=input(['Entre com tam_zer: ']);
        n_interp=input(['Entre com n_interp: ']);
        metodo=input('Entre com método: \n');
        
        todosdados=todosdados-basal; % subtrai basal
        todosdados=todosdados/max(todosdados(:)); % normaliza
        interpolados=BACzero(tam_zer,todosdados(:,:,1),mX,mY,n_interp,metodo);
        
        novosdados=zeros([size(interpolados) size(todosdados,3)]);
        
        for c=1:size(todosdados,3)
            novosdados(:,:,c)=BACzero(tam_zer,todosdados(:,:,c),mX,mY,n_interp,metodo);
        end
        
        salvarimg(novosdados);
        
%         setappdata(ph,'novosdados',novosdados);
% %         todosdados
% %         todosdados-basal
end
end

function salvarimg(varargin)
dados=varargin{1};

[filename,pathname]=uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Save Image',...
          [cd, '\BACimg.tiff']);
[filename,fmt]=strtok(filename,'.');
for c=1:size(dados,3)
	nometemp=[pathname,filename,num2str(c),fmt];
    dadotemp=im2uint8(dados(:,:,c));
    imwrite(dadotemp,nometemp);
end
end
