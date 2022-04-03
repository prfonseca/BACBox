function sinal=aux_existearquivo(fname,pname)
    % verifica se existe o arquivo. caso exista, carrega.
    if exist(fullfile(pname,fname),'file') % carrega se existe
        BACmsg('arqselec',fullfile(pname,fname));
        sinal=load(fullfile(pname,fname));
    else % erro se não existe arquivo
        BACmsg('arqnaoexiste',fullfile(pname,fname));return;
    end
end