DROP TABLE IF EXISTS orgao;

CREATE TABLE IF NOT EXISTS "orgao" ( 
    "id_orgao" INTEGER, 
    "nm_orgao" VARCHAR(240),
    "sigla_orgao" VARCHAR(10),
    "esfera" VARCHAR(10),
    "home_page" VARCHAR(50),
    "nome_municipio" VARCHAR(30),
    "cd_municipio_ibge" INTEGER,
    PRIMARY KEY("id_orgao")
);