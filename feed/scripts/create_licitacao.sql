DROP TABLE IF EXISTS licitacao;

CREATE TABLE IF NOT EXISTS "licitacao" (    
    "CD_ORGAO" VARCHAR(20),
    "NM_ORGAO" VARCHAR(240),
    "NR_LICITACAO" VARCHAR(20),
    "ANO_LICITACAO" INTEGER,
    "CD_TIPO_MODALIDADE" VARCHAR(3),
    "NR_COMISSAO" VARCHAR(10),
    "ANO_COMISSAO" VARCHAR(4),
    "TP_COMISSAO" VARCHAR(1),
    "NR_PROCESSO" VARCHAR(20),
    "ANO_PROCESSO" INTEGER,
    "TP_OBJETO" VARCHAR(3),
    "CD_TIPO_FASE_ATUAL" VARCHAR(3),
    "TP_LICITACAO" VARCHAR(3),
    "TP_NIVEL_JULGAMENTO" VARCHAR(1),
    "DT_AUTORIZACAO_ADESAO" DATE DEFAULT NULL,
    "TP_CARACTERISTICA_OBJETO" VARCHAR(2),
    "TP_NATUREZA" VARCHAR(1),
    "TP_REGIME_EXECUCAO" VARCHAR(1),
    "BL_PERMITE_SUBCONTRATACAO" VARCHAR(1),
    "TP_BENEFICIO_MICRO_EPP" VARCHAR(1),
    "TP_FORNECIMENTO" VARCHAR(1),
    "TP_ATUACAO_REGISTRO" VARCHAR(1),
    "NR_LICITACAO_ORIGINAL" VARCHAR(20),
    "ANO_LICITACAO_ORIGINAL" INTEGER,
    "NR_ATA_REGISTRO_PRECO" VARCHAR(20),
    "DT_ATA_REGISTRO_PRECO" DATE,
    "PC_TAXA_RISCO" REAL,
    "TP_EXECUCAO" VARCHAR(1),
    "TP_DISPUTA" VARCHAR(1),
    "TP_PREQUALIFICACAO" VARCHAR(1),
    "BL_INVERSAO_FASES" VARCHAR(1),
    "TP_RESULTADO_GLOBAL" VARCHAR(1),
    "CNPJ_ORGAO_GERENCIADOR" VARCHAR(14),
    "NM_ORGAO_GERENCIADOR" VARCHAR(60),
    "DS_OBJETO" TEXT,
    "CD_TIPO_FUNDAMENTACAO" VARCHAR(8),
    "NR_ARTIGO" VARCHAR(10),
    "DS_INCISO" VARCHAR(10),
    "DS_LEI" VARCHAR(10),
    "DT_INICIO_INSCR_CRED" DATE,
    "DT_FIM_INSCR_CRED" DATE,
    "DT_INICIO_VIGEN_CRED" DATE,
    "DT_FIM_VIGEN_CRED" DATE,
    "VL_LICITACAO" REAL,
    "BL_ORCAMENTO_SIGILOSO" VARCHAR(1),
    "BL_RECEBE_INSCRICAO_PER_VIG" VARCHAR(1),
    "BL_PERMITE_CONSORCIO" VARCHAR(1),
    "DT_ABERTURA" DATE,
    "DT_HOMOLOGACAO" DATE,
    "DT_ADJUDICACAO" DATE,
    "BL_LICIT_PROPRIA_ORGAO" VARCHAR(1),
    "TP_DOCUMENTO_FORNECEDOR" VARCHAR(1),
    "NR_DOCUMENTO_FORNECEDOR" VARCHAR(14),
    "TP_DOCUMENTO_VENCEDOR" VARCHAR(1),
    "NR_DOCUMENTO_VENCEDOR" VARCHAR(14),
    "VL_HOMOLOGADO" REAL,
    "BL_GERA_DESPESA" VARCHAR(1),
    "DS_OBSERVACAO" TEXT,
    "PC_TX_ESTIMADA" DECIMAL,
    "PC_TX_HOMOLOGADA" DECIMAL,
    "BL_COMPARTILHADA" VARCHAR(1),
    "LICITACAO_ID" INTEGER,
    PRIMARY KEY("LICITACAO_ID")
);
