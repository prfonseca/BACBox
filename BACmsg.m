function BACmsg(varargin)
% conjunto de mensagens do BACbox
%
% sintaxes possíveis
% BACmsg('tipo_da_mensagem');
%
% BACmsg('tipo_da_mensagem','informacao_adicional') 
%   * algumas sintaxes permitem, por exemplo, informar que o arquivo X foi
%     salvo com sucesso

switch nargin
    case 0
        error('Escolha uma mensagem');
    case 1
        msg=varargin{1};
    case 2
        msg=varargin{1};
        mfile=varargin{2};
    otherwise
        mfile=mfilename;
        msg='naoprevisto';
end

clc
switch msg
    %%%%%% Apresentacoes
    case 'apresenta'
        disp(':::Unesp::: BACBox :::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
        disp('::');
        disp(['::Este conjunto de rotinas compreende diversos recursos e ',...
            'aplicações atualmente',10,'::utilizadas pelo Laboratório de Biomagnetismo ',...
            'da Univ. Estadual Paulista (Unesp).']);
        disp('::');
        disp('::Seu uso esta limitado ao Laboratorio de Biomagnetismo e seus colaboradores');
        disp('::');
        disp('::');
        disp(['::Desenvolvedor: Paulo R. Fonseca',10,':: prfonseca[at]ibb.unesp.br',10,':: prfonseca[at]feb.br',10,':: prfonseca[at]gmail.com']);
        disp(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
        %%%%%% Mensagens informativas
    case 'usrcanc'
        disp('Cancelado pelo usuário')
    case 'arqselec'
        disp(['Arquivo selecionado ',10,mfile])
    case 'arqsalvo'
        disp([mfile,10,'Arquivo salvo com sucesso.'])
    case 'buscando'
        disp('Buscando arquivos...')
    case 'comprimindo'
        disp('Comprimindo arquivo(s)...')
    case 'enviando'
        disp('Enviando arquivos...')
    case 'conc'
        disp('Concluído !')
        %%%%%% Mensagens de erro
    case 'naosuportado'
        disp([mfile,10,'ERRO: Esta função não suporta este tipo de entrada'])
    case 'semsaida'
        disp([mfile,10,'ERRO: Não foi especificada uma variável de saída.'])
    case 'naoprevisto'
        disp([mfile,10,'ERRO: Recurso não previsto na elaboração do programa. Contate o desenvolvedor'])
    case 'dirnaoexiste'
        disp([mfile,10,'ERRO: Diretório especificado não existe'])
    case 'varnaoexiste'
        disp([mfile,10,'ERRO: Variável especificada não existe'])
    case 'arqnaoexiste'
        disp([mfile,10,'ERRO: Arquivo especificado não existe'])
    case 'outrasintaxe'
        disp([mfile,10,'ERRO: tente esta sintaxe'])
    otherwise
        error('ERRO: Mensagem não prevista')
end
end