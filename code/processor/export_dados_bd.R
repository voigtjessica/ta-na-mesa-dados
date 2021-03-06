library(tidyverse)
library(here)
library(magrittr)

help <- "
Usage:
Rscript export_dados_bd.R <anos>
<anos> pode ser um ano (2017) ou múltiplos anos separados por vírgula (2017,2018,2019)
Exemplos:
Rscript export_dados_bd.R 2019
Rscript export_dados_bd.R 2018,2019,2020
"

args <- commandArgs(trailingOnly = TRUE)
min_num_args <- 1
if (length(args) < min_num_args) {
  stop(paste("Wrong number of arguments!", help, sep = "\n"))
}

anos <- unlist(strsplit(args[1], split=","))
# anos = c(2018, 2019, 2020)

source(here::here("code/utils/utils.R"))
source(here::here("code/utils/join_utils.R"))
source(here::here("code/utils/constants.R"))

## Assume que os dados foram baixados usando o módulo do crawler de dados (presente no diretório crawler
## na raiz desse repositório)

# Processamento dos dados
message("#### Iniciando processamento...")

## Licitações
message("#### licitações...")
source(here::here("code/licitacoes/processa_licitacoes.R"))
source(here::here("code/licitacoes/processa_tipos_licitacoes.R"))

licitacoes <- import_licitacoes(anos) %>% 
  processa_info_licitacoes()

orgaos_licitacao <- licitacoes %>% 
  dplyr::distinct(id_orgao, nm_orgao)

tipo_licitacao <- processa_tipos_licitacoes()
info_licitacoes <- join_licitacao_e_tipo(licitacoes, tipo_licitacao) %>% 
  generate_id(TABELA_LICITACAO, L_ID) %>% 
  dplyr::select(id_licitacao, dplyr::everything())

## Licitantes
message("### licitantes...")

source(here::here("code/licitacoes/processa_licitantes.R"))

licitantes <- import_licitantes(anos) %>% 
  processa_info_licitantes()

info_licitantes <- join_licitante_e_licitacao(
  licitantes,
  info_licitacoes %>%
    dplyr::select(id_orgao, nr_licitacao, ano_licitacao, cd_tipo_modalidade, L_ID)
) %>% 
  generate_id(TABELA_LICITANTE, LICITANTE_ID) %>% 
  dplyr::select(id_licitante, id_licitacao, dplyr::everything())

## Itens de licitações
message("#### itens de licitações...")
source(here::here("code/licitacoes/processa_itens_licitacao.R"))
info_item_licitacao <- import_itens_licitacao(anos) %>%
  processa_info_item_licitacao() %>% 
  generate_id(TABELA_ITEM, I_ID) %>% 
  join_licitacoes_e_itens(info_licitacoes) %>% 
  dplyr::select(id_item, id_licitacao, dplyr::everything())

## Contratos
message("#### contratos...")
source(here::here("code/contratos/processa_contratos.R"))
source(here::here("code/contratos/processa_tipos_instrumento_contrato.R"))

contratos <- import_contratos(anos) %>% 
  processa_info_contratos()
  
tipo_instrumento_contrato <- 
  processa_tipos_instrumento_contrato()

info_contratos <- 
  join_contrato_e_licitacao(contratos, 
                            info_licitacoes %>% 
                              dplyr::select(id_orgao, 
                                            nr_licitacao, 
                                            ano_licitacao, 
                                            cd_tipo_modalidade,
                                            id_licitacao)) %>% 
  
  join_contrato_e_instrumento(tipo_instrumento_contrato) %>% 
  generate_id(TABELA_CONTRATO, CONTRATO_ID) %>% 
  dplyr::select(id_contrato, id_licitacao, id_orgao, dplyr::everything())

## Fornecedores nos contratos
message("#### fornecedores (contratos)...")
source(here("code/contratos/processa_fornecedores.R"))

info_fornecedores_contratos <- import_fornecedores(anos) %>% 
  processa_info_fornecedores() %>% 
  join_contratos_e_fornecedores(info_contratos %>% 
                                  dplyr::select(nr_documento_contratado)) %>% 
  dplyr::distinct(nr_documento, .keep_all = TRUE)

## Itens de contratos
message("#### itens de contratos...")
source(here("code/contratos/processa_itens_contrato.R"))

info_item_contrato <- import_itens_contrato(anos) %>% 
  processa_info_item_contrato() %>% 
  join_contratos_e_itens(info_contratos %>% 
                           dplyr::select(dt_inicio_vigencia, id_orgao, id_contrato, id_licitacao, nr_licitacao, ano_licitacao, 
                                         cd_tipo_modalidade, nr_contrato, ano_contrato, 
                                         tp_instrumento_contrato)) %>% 
  generate_id(TABELA_ITEM_CONTRATO, ITEM_CONTRATO_ID) %>% 
  join_itens_contratos_e_licitacoes(info_item_licitacao) %>% 
  dplyr::select(id_item_contrato, id_contrato, id_orgao, id_licitacao, id_item_licitacao, dplyr::everything()) %>% 
  create_categoria() %>%
  split_descricao()

## Alterações contratos
message("#### alterações de contratos...")
source(here::here("code/contratos/processa_alteracoes_contratos.R"))
source(here::here("code/contratos/processa_tipos_alteracao_contrato.R"))

alteracoes <- import_alteracoes_contratos(anos) %>% 
  processa_info_alteracoes_contratos()

tipo_operacao_alteracao <- processa_tipos_alteracao_contrato()

info_alteracoes_contrato <- alteracoes %>% 
  join_alteracoes_contrato_e_tipo(tipo_operacao_alteracao) %>% 
  join_alteracoes_contrato_e_contrato(info_contratos) %>% 
  generate_id(TABELA_ALTERACOES_CONTRATO, ALTERACOES_CONTRATO_ID) %>% 
  dplyr::select(id_alteracoes_contrato, id_contrato, dplyr::everything())

## Municípios
message("#### municípios...")
source(here::here("code/orgaos/processa_orgaos.R"))
info_orgaos_municipios <- import_orgaos() %>% 
  processa_info_orgaos()

## Completa CSV de órgãos com os órgãos presentes na tabela de licitação
info_orgaos <- info_orgaos_municipios %>% 
  dplyr::mutate(id_orgao = as.character(id_orgao)) %>% 
  dplyr::bind_rows(orgaos_licitacao) %>% 
  dplyr::distinct(id_orgao, .keep_all = TRUE)

# Escrita dos dados

message("#### escrevendo dados...")

readr::write_csv(info_licitacoes, here("data/bd/info_licitacao.csv"))
readr::write_csv(info_licitantes, here("data/bd/info_licitante.csv"))
readr::write_csv(info_item_licitacao, here("data/bd/info_item_licitacao.csv"))
readr::write_csv(info_contratos, here("data/bd/info_contrato.csv"))
readr::write_csv(info_fornecedores_contratos, here("data/bd/info_fornecedores_contrato.csv"))
readr::write_csv(info_item_contrato, here("data/bd/info_item_contrato.csv"))
readr::write_csv(info_alteracoes_contrato, here("data/bd/info_alteracao_contrato.csv"))
readr::write_csv(info_orgaos, here("data/bd/info_orgaos.csv"))

message("#### Processamento concluído!")
message("#### Confira o diretório data/bd")
