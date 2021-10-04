-- SQL f_desempenho_prova
-- Sql que quantifica o total de  inscritos por sexo e estado
select uf.sigla_uf, ca.tp_sexo, count(ca.nu_inscricao) from candidato ca
inner join municipio mu on ca.cod_municipio_residencia = mu.cod_municipio
inner join uf on uf.sequencial_uf = mu.sequencial_uf
group by uf.sigla_uf, ca.tp_sexo

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2014 -U anacrl -c "\copy (select TABELA.NU_INSCRICAO, TABELA.ID_PROVA, TABELA.QTDACERTOS, TABELA.QTDERROS, TABELA.NOTAPROVA  from 
(SELECT ca.nu_inscricao AS NU_INSCRICAO, pr.id_prova AS ID_PROVA, 
sum(CASE WHEN (ca.tp_lingua = 0 and res.resposta_questao=qu.gabarito_en) or (ca.tp_lingua = 1 and res.resposta_questao=qu.gabarito_es) THEN 1 ELSE 0 END) AS QTDACERTOS,
sum(CASE WHEN (ca.tp_lingua = 0 and res.resposta_questao<>qu.gabarito_en) or (ca.tp_lingua = 1 and res.resposta_questao<>qu.gabarito_es) THEN 1 ELSE 0 END) AS QTDERROS,
re.nota_prova AS NOTAPROVA
FROM candidato ca INNER JOIN realiza re ON ca.nu_inscricao=re.nu_inscricao
INNER JOIN prova pr ON re.id_prova=pr.id_prova
INNER JOIN contem con ON pr.id_prova=con.id_prova
INNER JOIN questao qu ON con.sequencial_questao=qu.sequencial_questao
INNER JOIN responde res ON ca.nu_inscricao=res.nu_inscricao and res.sequencial_questao=qu.sequencial_questao
and ca.nu_inscricao = 140000000001
group by ca.nu_inscricao, re.nota_prova, pr.id_prova
UNION
SELECT CA.nu_inscricao AS NU_INSCRICAO, pr.id_prova AS ID_PROVA, 0 as QTDACERTOS, 45 as QTDERROS, re.nota_prova AS NOTAPROVA
FROM candidato ca INNER JOIN realiza re ON ca.nu_inscricao=re.nu_inscricao
INNER JOIN prova pr ON re.id_prova=pr.id_prova
and RE.nu_inscricao = 140000009194
group by ca.nu_inscricao, re.nota_prova, pr.id_prova) TABELA
ORDER BY TABELA.NU_INSCRICAO) to stdout" | PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw_2 -U anacrl -c "\copy d_temp_desempenho_prova from stdin"


---------------------------------------------------------------------------------------------------
-- SQL f_desempenho_prova

select  row_number() over (order by dtpc.nu_inscricao asc) as id_desempenho_prova, dtpc.nu_inscricao, dtdq.notaprova, dtdq.qtdacertos, dtdq.qtderros, dtl.pk_localidade,
dtt.pk_tempo, dtps.pk_d_perfil_socio, dtne.pk_necessidades_especiais, dta.pk_auxilio, dtpc.pk_candidato, dp.pk_prova, 
dte.pk_escola
from d_temp_perfil_candidato dtpc
INNER JOIN d_temp_perfil_socio dtps ON dtps.nu_inscricao=dtpc.nu_inscricao
INNER JOIN d_temp_tempo dtt ON dtpc.nu_inscricao=dtt.nu_inscricao
INNER JOIN d_temp_localidade dtl ON dtpc.nu_inscricao=dtl.nu_inscricao
LEFT JOIN d_temp_escola dte ON dtpc.nu_inscricao=dte.nu_inscricao
LEFT JOIN d_temp_necessidades_especiais dtne ON dtpc.nu_inscricao=dtne.nu_inscricao
LEFT JOIN d_temp_auxilio dta ON dtpc.nu_inscricao=dta.nu_inscricao
INNER JOIN d_temp_desempenho_prova dtdq ON dtpc.nu_inscricao=dtdq.nu_inscricao
INNER JOIN d_prova dp ON dtdq.id_prova= dp.id_prova
where dtpc.nu_inscricao<=140000000020


create table f_desempenho_prova (
       id_desempenho_prova INTEGER NOT NULL DEFAULT NEXTVAL('f_desempenho_prova_sequence'), 
       nu_inscricao double precision,
       notaprova numeric,
       qtdacertos integer,
       qtderros integer,
       pk_localidade integer,
       pk_tempo integer,
       pk_perfil_socio integer,
       pk_necessidades_especiais integer,
       pk_auxilio bigint,
       pk_candidato bigint,
       pk_prova integer,
       pk_escola bigint
);

----------------------------------------------------------------------------------------------------
-- SQL f_desempenho_questao

SELECT ca.nu_inscricao AS NU_INSCRICAO, pr.id_prova AS ID_PROVA, res.resposta_questao, qu.gabarito_en, qu.gabarito_es,
CASE WHEN (ca.tp_lingua = 0 and res.resposta_questao=qu.gabarito_en) or (ca.tp_lingua = 1 and res.resposta_questao=qu.gabarito_es)
               THEN 'CERTO' ELSE 'ERRADO' END AS STATUS_QUESTAO
FROM candidato ca INNER JOIN realiza re ON ca.nu_inscricao=re.nu_inscricao
INNER JOIN prova pr ON re.id_prova=pr.id_prova
INNER JOIN contem con ON pr.id_prova=con.id_prova
INNER JOIN questao qu ON con.sequencial_questao=qu.sequencial_questao
INNER JOIN responde res ON ca.nu_inscricao=res.nu_inscricao and res.sequencial_questao=qu.sequencial_questao
and ca.nu_inscricao <= 140000000001


select 
row_number() over (order by dtpc.nu_inscricao asc) as id_desempenho_prova,
dtpc.nu_inscricao, 
dtl.pk_localidade,
dtt.pk_tempo,
dtps.pk_d_perfil_socio, 
dtne.pk_necessidades_especiais,
dta.pk_auxilio,
dtpc.pk_candidato, 
dte.pk_escola,
dtdq.status_questao
from d_temp_perfil_candidato dtpc
INNER JOIN d_temp_perfil_socio dtps ON dtps.nu_inscricao=dtpc.nu_inscricao
INNER JOIN d_temp_tempo dtt ON dtpc.nu_inscricao=dtt.nu_inscricao
INNER JOIN d_temp_localidade dtl ON dtpc.nu_inscricao=dtl.nu_inscricao
LEFT JOIN d_temp_escola dte ON dtpc.nu_inscricao=dte.nu_inscricao
LEFT JOIN d_temp_necessidades_especiais dtne ON dtpc.nu_inscricao=dtne.nu_inscricao
LEFT JOIN d_temp_auxilio dta ON dtpc.nu_inscricao=dta.nu_inscricao
INNER JOIN d_temp_desempenho_questao dtdq ON dtpc.nu_inscricao=dtdq.nu_inscricao
ORDER BY dtpc.nu_inscricao ASC



PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2014 -U anacrl -c "\copy (select dtpc.nu_inscricao, dtdq.notaprova, dtdq.qtdacertos, dtdq.qtderros, dtl.pk_localidade,
dtt.pk_tempo, dtps.pk_d_perfil_socio, dtne.pk_necessidades_especiais, dta.pk_auxilio, --dq.pk_questao,
dtpc.pk_candidato, dp.pk_prova, 
dte.pk_escola
from d_temp_perfil_candidato dtpc
INNER JOIN d_temp_perfil_socio dtps ON dtps.nu_inscricao=dtpc.nu_inscricao
INNER JOIN d_temp_tempo dtt ON dtpc.nu_inscricao=dtt.nu_inscricao
INNER JOIN d_temp_localidade dtl ON dtpc.nu_inscricao=dtl.nu_inscricao
LEFT JOIN d_temp_escola dte ON dtpc.nu_inscricao=dte.nu_inscricao
LEFT JOIN d_temp_necessidades_especiais dtne ON dtpc.nu_inscricao=dtne.nu_inscricao
LEFT JOIN d_temp_auxilio dta ON dtpc.nu_inscricao=dta.nu_inscricao
INNER JOIN d_temp_desempenho_prova dtdq ON dtpc.nu_inscricao=dtdq.nu_inscricao
--INNER JOIN d_questao dq ON dtdq.id_prova=dq.id_prova
INNER JOIN d_prova dp ON dtdq.id_prova= dp.id_prova
where dtpc.nu_inscricao<=140000000020) to stdout" | PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw_2 -U anacrl -c "\copy d_temp_desempenho_questao from stdin"

==========================================================================================================================================================================================

select * from d_temp_perfil_socio_2015
where nu_inscricao=150000000012

select * from d_temp_perfil_candidato_2015
where nu_inscricao=150000000012

select * from d_perfil_socio
where nu_inscricao=150000000006

select * from d_perfil_candidato dpc
where dpc.tp_sexo='F'
and dpc.tp_estado_civil isnull
and dpc.idade=29
and dpc.nacionalidade='1'
and dpc.ano_conclusao='10'
and dpc.in_tp_ensino isnull


SELECT dtpc.nu_inscricao, dtdq.notaprova, dtdq.qtdacertos, dtdq.qtderros, dtl.pk_localidade_residencia,
dtl.pk_localidade_nascimento, dtl.pk_localidade_prova, dtps.pk_perfil_socio, dtne.pk_necessidades_especiais,
dta.pk_auxilio, dtpc.pk_candidato, dp.pk_prova, dte.pk_escola
from d_temp_perfil_candidato_2015 dtpc
INNER JOIN d_temp_perfil_socio_2015 dtps ON dtps.nu_inscricao=dtpc.nu_inscricao
INNER JOIN d_temp_localidade_2015 dtl ON dtpc.nu_inscricao=dtl.nu_inscricao
LEFT JOIN d_temp_escola_2015 dte ON dtpc.nu_inscricao=dte.nu_inscricao
LEFT JOIN d_temp_necessidades_especiais_2015 dtne ON dtpc.nu_inscricao=dtne.nu_inscricao
LEFT JOIN d_temp_auxilio_2015 dta ON dtpc.nu_inscricao=dta.nu_inscricao
INNER JOIN d_temp_desempenho_prova_2015 dtdq ON dtpc.nu_inscricao=dtdq.nu_inscricao
INNER JOIN d_prova dp ON dtdq.id_prova=dp.id_prova 
order by dtpc.nu_inscricao asc

==========================================================================================================================================================================================

select * from dblink('host=127.0.0.1 user=anacrl password=ljk14253 dbname=bd_enem_dados_dw', 'select nu_inscricao, count(*) as qtd from d_temp_desempenho_prova group by nu_inscricao') 
t (nu_inscricao double precision, qtd numeric)

==========================================================================================================================================================================================

select ca.nu_inscricao, pr.id_prova, 
ar.nome_area, qu.sequencial_questao
from candidato ca, realiza re, prova pr, 
questao qu, area ar, contem con
where ca.nu_inscricao=re.nu_inscricao and 
re.id_prova=re.id_prova and
pr.cod_area=ar.cod_area and 
pr.id_prova=con.id_prova and 
con.sequencial_questao=qu.sequencial_questao

select ca.nu_inscricao, qu.sequencial_questao
from candidato ca, realiza re, prova pr, 
questao qu, area ar, contem con
where ca.nu_inscricao=re.nu_inscricao and 
re.id_prova=pr.id_prova and 
pr.id_prova=con.id_prova and 
con.sequencial_questao=qu.sequencial_questao

select count(ca.nu_inscricao)
from candidato ca, realiza re, prova pr
where ca.nu_inscricao=re.nu_inscricao and 
re.id_prova=pr.id_prova



update f_inscricao as fi
set pk_localidade_nascimento=dtl.pk_localidade_nascimento
from d_temp_localidade_2015 dtl
where (fi.nu_inscricao :: text) like '150%'
and fi.nu_inscricao=dtl.nu_inscricao

==========================================================================================================================================================================================
-- Sql para criacao da tabela baseado no 

create table f_desempenho_questao_v1 as 
select dtdq.nu_inscricao,
row_number() OVER (PARTITION by 0) + 1088002808 as pk_f_desempenho_prova,
fdq.pk_auxilio,
fdq.pk_necessidades_especiais,
fdq.pk_perfil_socio,
fdq.pk_localidade_residencia,
fdq.pk_candidato,
fdq.pk_escola,
fdq.pk_tempo,
fdq.pk_localidade_nascimento,
fdq.pk_localidade_prova,
dtdq.status_questao,
dp.pk_prova, 
dq.pk_questao
from f_inscricao_2015 fdq
inner join d_temp_desempenho_questao_2015 dtdq ON fdq.nu_inscricao=dtdq.nu_inscricao
inner join d_prova dp ON dtdq.id_prova=dp.id_prova
inner join d_questao dq ON dtdq.sequencial_questao=dq.sequencial_questao
where dp.pk_prova <> 0 and dq.pk_questao <> 0
order by fdq.nu_inscricao;

==========================================================================================================================================================================================

PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "\copy (create table f_desempenho_questao_v1 as 
select dtdq.nu_inscricao,
row_number() OVER (PARTITION by 0) + 1088002808 as pk_f_desempenho_prova,
fdq.pk_auxilio,
fdq.pk_necessidades_especiais,
fdq.pk_perfil_socio,
fdq.pk_localidade_residencia,
fdq.pk_candidato,
fdq.pk_escola,
fdq.pk_tempo,
fdq.pk_localidade_nascimento,
fdq.pk_localidade_prova,
dtdq.status_questao,
dp.pk_prova, 
dq.pk_questao
from f_inscricao_2015 fdq
inner join d_temp_desempenho_questao_2015 dtdq ON fdq.nu_inscricao=dtdq.nu_inscricao
inner join d_prova dp ON dtdq.id_prova=dp.id_prova
inner join d_questao dq ON dtdq.sequencial_questao=dq.sequencial_questao
where dp.pk_prova <> 0 and dq.pk_questao <> 0
order by fdq.nu_inscricao) to stdout" | PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "\copy f_desempenho_questao from stdin"

==========================================================================================================================================================================================

echo "Calcular quantidade de alunos de 2014 na tabela f_desempenho_questao (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select count(*) from (select distinct nu_inscricao from f_desempenho_questao where (nu_inscricao :: text) like '140%') as t" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular quantidade de alunos de 2014 na tabela responde (bd_enem_dados_2014)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2014 -U anacrl -c "select count(*) from (select distinct nu_inscricao from responde) as t" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular quantidade de alunos de 2015 na tabela f_desempenho_questao (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select count(*) from (select distinct nu_inscricao from f_desempenho_questao where (nu_inscricao :: text) like '150%') as t" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular quantidade de alunos de 2015 na tabela responde (bd_enem_dados_2015)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2015 -U anacrl -c "select count(*) from (select distinct nu_inscricao from responde) as t" >> log_sql.log

echo "" >> log_sql.log
echo "Selecionar para o ano de 2014 um certo aluno = 140000000101 (bd_enem_dados_2014)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2014 -U anacrl -c "select nu_inscricao from responde where nu_inscricao = 140000000101" >> log_sql.log

echo "" >> log_sql.log
echo "Selecionar para o ano de 2014 um certo aluno = 140000000101 (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select nu_inscricao from f_desempenho_questao where nu_inscricao = 140000000101" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular a quantidade de respostas para o ano de 2014 de um certo aluno = 140000000101 (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select count(nu_inscricao) from f_desempenho_questao where nu_inscricao = 140000000101" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular a quantidade de respostas para o ano de 2014 de um certo aluno = 140000000101 (bd_enem_dados_2014)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2014 -U anacrl -c "select count(nu_inscricao) from f_desempenho_questao where nu_inscricao = 140000000101" >> log_sql.log

echo "" >> log_sql.log
echo "Selecionar para o ano de 2015 um certo aluno = 150000000100 (bd_enem_dados_2015)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2015 -U anacrl -c "select nu_inscricao from f_desempenho_questao where nu_inscricao = 150000000100" >> log_sql.log

echo "" >> log_sql.log
echo "Selecionar para o ano de 2015 um certo aluno = 150000000100 (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select nu_inscricao from responde where nu_inscricao = 150000000100" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular a quantidade de respostas para o ano de 2014 de um certo aluno = 150000000100 (bd_enem_dados_dw)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select count(nu_inscricao) from f_desempenho_questao where nu_inscricao = 150000000100" >> log_sql.log

echo "" >> log_sql.log
echo "Calcular a quantidade de respostas para o ano de 2014 de um certo aluno = 150000000100 (bd_enem_dados_2015)" >> log_sql.log
PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_2015 -U anacrl -c "select count(nu_inscricao) from f_desempenho_questao where nu_inscricao = 150000000100" >> log_sql.log
==========================================================================================================================================================================================================

select distinct nu_inscricao from f_desempenho_questao where (nu_inscricao :: text) like '140%'
except
select nu_inscricao from dblink('host=127.0.0.1 user=anacrl password=ljk14253 dbname=bd_enem_dados_2014', 'select distinct nu_inscricao from responde') 
t (nu_inscricao double precision)


PGPASSWORD=ljk14253 psql -h localhost -p 5432 -d bd_enem_dados_dw -U anacrl -c "select dtdq.nu_inscricao, fdq.pk_localidade_residencia, fdq.pk_tempo, dq.pk_questao, fdq.pk_perfil_socio, fdq.pk_necessidades_especiais,
fdq.pk_auxilio, fdq.pk_candidato, fdq.pk_escola, dp.pk_prova, dtdq.status_questao, fdq.pk_localidade_nascimento, fdq.pk_localidade_prova
from f_inscricao fdq
inner join f_desempenho_questao dtdq ON fdq.nu_inscricao=dtdq.nu_inscricao
inner join d_prova dp ON dtdq.id_prova=dp.id_prova
inner join d_questao dq ON dtdq.sequencial_questao=dq.sequencial_questao
where dp.pk_prova <> 0 and dq.pk_questao <> 0
and dtdq.nu_inscricao=140002295908
order by fdq.nu_inscricao" >> log_sql_f_questao_2014.log


