function [fname, pname] = aux_interf_save_sinal(varargin)
% interface para salvar um sinal
%
% sintaxes
%   aux_interf_save_sinal(pname,fname.ext)
%   aux_interf_save_sinal(pname,fname.ext,'complemento')
%

complemento='';
switch nargin
    case 0
        pname=cd;
        fname='escolhaonome';
        ext='.txt';
    case 1
        [pname, fname, ext]=fileparts(varargin{1});
        if isempty(pname);pname=cd;end
    case 2
        pname=varargin{1};
        fname=varargin{2};
        [~, fname, ext]=fileparts(fname);
    case 3
        pname=varargin{1};
        fname=varargin{2};
        [~, fname, ext]=fileparts(fname);
        complemento=varargin{3};
    otherwise;  BACmsg('naoprevisto',mfilename);return;

end
if isempty(complemento)
    prompt = {'entre aqui o novo nome:'};
    dlg_title = 'Alterar nome do arquivo:';
    num_lines = 1;
    def = {[fname,'_proc',ext]};
    complemento = char(inputdlg(prompt,dlg_title,num_lines,def));
else
    complemento=[fname,complemento,ext];
end
% [fname, pname] = uiputfile( ...
% { '*.lvm','Arquivos LVM(*.lvm)';...
%  '*.txt','Arquivos TXT(*.txt)';...
%  '*.dat','Arquivos DAT(*.dat)';...
%  '*.m;*.fig;*.mat;*.mdl','MATLAB Files (*.m,*.fig,*.mat,*.mdl)';...
%   '*.*',  'Todos arquivos(*.*)'},...
%  'Salvar arquivo',fullfile(pname,complemento));

[fname, pname] = uiputfile(fullfile(pname,complemento),'Salvar arquivo');

end