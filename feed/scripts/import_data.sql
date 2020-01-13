\copy licitacao FROM '/data/licitacoes/2019/licitacao.csv' WITH NULL AS '' DELIMITER ',' CSV HEADER;

ALTER TABLE contrato ADD CONSTRAINT fk_contrato FOREIGN KEY(CD_ORGAO, NR_LICITACAO, ANO_LICITACAO, CD_TIPO_MODALIDADE) REFERENCES licitacao(CD_ORGAO, NR_LICITACAO, ANO_LICITACAO, CD_TIPO_MODALIDADE);
\copy contrato FROM '/data/contratos/2019/contrato.csv' WITH NULL AS '' DELIMITER ',' CSV HEADER;

ALTER TABLE empenho DROP CONSTRAINT empenho_pkey;
ALTER TABLE empenho DROP CONSTRAINT empenho_cd_orgao_fkey;
\copy empenho FROM '/data/empenhos/2019/2019.csv' WITH NULL AS '' DELIMITER ',' CSV HEADER;


