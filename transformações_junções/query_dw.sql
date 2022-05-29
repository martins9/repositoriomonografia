-------------------------------------------------------------------------
-- Query para pegar os dados para as tabelas 
-- d_perfil_candidato e d_auxilio
-------------------------------------------------------------------------
select ca.nu_inscricao, ne.in_mesa_cadeira_separada, ne.in_leitura_labial,
ne.in_mesa_cadeira_rodas, ne.in_guia_interprete, 
ne.in_apoio_perna, ne.in_transcricao, ne.in_libras, 
ne.in_ledor, ne.in_acesso
from necessidades_especiais ne
where ne.in_mesa_cadeira_separada=1 or ne.in_leitura_labial=1 or 
ne.in_mesa_cadeira_rodas = 1 or ne.in_guia_interprete=1 or 
ne.in_apoio_perna=1 or ne.in_transcricao=1 or ne.in_libras=1 or
ne.in_ledor=1 or ne.in_acesso=1 
order by ca.nu_inscricao limit 10


-------------------------------------------------------------------------
-- Query para pegar os dados para as tabelas 
-- d_perfil_candidato e d_deficiencia
-------------------------------------------------------------------------
select in_deficiencia_auditiva, in_deficiencia_mental, 
in_deficit_atencao, in_baixa_visao, in_sabatista, in_dislexia, 
in_gestante, in_cegueira, in_lactante, in_surdez, in_autismo, 
in_idoso
from necessidades_especiais 
where in_deficiencia_auditiva=1 or in_deficiencia_mental=1 or
in_deficit_atencao=1 or in_baixa_visao=1 or in_sabatista=1 or
in_dislexia=1 or in_gestante=1 or in_cegueira=1 or in_lactante=1
or in_surdez=1 or in_autismo=1 or in_idoso=1
order by nu_inscricao limit 500


select ca.nu_inscricao, a2.nu_inscricao from candidato ca
left join (select ne.nu_inscricao --ne.in_mesa_cadeira_separada, ne.in_leitura_labial,
--ne.in_mesa_cadeira_rodas, ne.in_guia_interprete, 
--ne.in_apoio_perna, ne.in_transcricao, ne.in_libras, 
--ne.in_ledor, ne.in_acesso
from  necessidades_especiais ne
where ne.in_mesa_cadeira_separada=1 or ne.in_leitura_labial=1 or 
ne.in_mesa_cadeira_rodas = 1 or ne.in_guia_interprete=1 or 
ne.in_apoio_perna=1 or ne.in_transcricao=1 or ne.in_libras=1 or
ne.in_ledor=1 or ne.in_acesso=1
order by ne.nu_inscricao limit 500) as a2 on
a2.nu_inscricao=ca.nu_inscricao


select
ca.nu_inscricao,
	count(qe.gabarito_en) filter (where ca.tp_lingua = 0 and re.resposta_questao=qe.gabarito_en),
	count(qe.gabarito_es) filter (where ca.tp_lingua = 1 and re.resposta_questao=qe.gabarito_es)
from candidato ca, responde re, questao qe
where ca.nu_inscricao= re.nu_inscricao and
re.sequencial_questao=qe.sequencial_questao and
ca.nu_inscricao=140000000001 and ca.nu_inscricao=140000000002
group by ca.tp_lingua, ca.nu_inscricao

-----------------------------------------------------------------------
--- Criar Foreign Key senão existir
----------------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (SELECT * FROM pg_constraint WHERE conname = 'id_localidade_fkey') THEN
       ALTER TABLE d_escola
    		ADD CONSTRAINT id_localidade_fkey
    		FOREIGN KEY (idlocalidade) REFERENCES d_localidade(idlocalidade);
    END IF;
END;
$$;

-----------------------------------------------------------------------
--- Replace certo ou errado
----------------------------------------------------------------------
select
	case when  re.resposta_questao=qu.gabarito_en then
		replace(re.resposta_questao, re.resposta_questao, 'certo')
	else 
		replace(re.resposta_questao, re.resposta_questao, 'errado')
	end
from responde re, questao qu 
where re.sequencial_questao=qu.sequencial_questao limit 10



select distinct on (tp_sexo, tp_estado_civil, idade, nacionalidade, ano_conclusao, in_tp_ensino) nu_inscricao,
tp_sexo, tp_estado_civil, idade, nacionalidade, ano_conclusao, in_tp_ensino
from candidato limit 1000



ALTER TABLE d_escola ADD CONSTRAINT d_escola_fkey FOREIGN KEY (idlocalidade) REFERENCES d_localidade (idlocalidade);


==================================================================================================================================
select ca.nu_inscricao, rea.nota_prova, 
qu.gabarito_en 
from candidato ca, realiza rea, prova pr, 
area ar, contem con, questao qu, responde re
where ca.nu_inscricao=rea.nu_inscricao and 
rea.id_prova=pr.id_prova and pr.cod_area=ar.cod_area
and pr.id_prova=con.id_prova and con.sequencial_questao = qu.sequencial_questao
and qu.sequencial_questao=re.sequencial_questao and re.resposta_questao=qu.gabarito_en 
GROUP BY ca.nu_inscricao, rea.nota_prova, qu.gabarito_en
limit 1000



select es.cod_escola, 
es.nome_escola, mu.nome_municipio, uf.sigla_uf
from escola es, municipio mu, uf uf
where es.cod_municipio_escola=mu.cod_municipio 
and mu.sequencial_uf=uf.sequencial_uf
and es.nome_escola='EEEFM SANTOS DUMONT'


======================================================================================

select in_deficiencia_auditiva, in_deficiencia_mental,
in_deficit_atencao, in_baixa_visao, in_sabatista,
in_dislexia, in_gestante, in_cegueira, in_lactante,
in_surdez, in_autismo, in_idoso
from necessidades_especiais
where in_deficiencia_auditiva = 1 or 
in_deficiencia_mental = 1 or 
in_deficit_atencao = 1 or 
in_baixa_visao=1 or 
in_sabatista=1 or
in_dislexia =1 or
in_gestante=1 or
in_cegueira=1 or 
in_lactante=1 or 
in_surdez=1 or
in_autismo=1 or
in_idoso=1

======================================================================================

select * from questao_socioeconomico qu, preenche pr
where qu.sequencial_questionario_socio=pr.sequencial_questionario_socio and
qu.sequencial_questionario_socio = 1 or
qu.sequencial_questionario_socio = 2 or
qu.sequencial_questionario_socio = 3 or
qu.sequencial_questionario_socio = 4 or
qu.sequencial_questionario_socio = 8 or
qu.sequencial_questionario_socio = 11 or
qu.sequencial_questionario_socio = 17 or
qu.sequencial_questionario_socio = 18 or
qu.sequencial_questionario_socio = 26 or
qu.sequencial_questionario_socio = 27 or
qu.sequencial_questionario_socio = 28 or
qu.sequencial_questionario_socio = 29 or
qu.sequencial_questionario_socio = 63 or
limit 10

=====================================================================================
-- Exibe o tablespace

select spcname
      ,pg_tablespace_location(oid) 
from   pg_tablespace

==================================================================================


--Transacional-2014
select ca.tp_sexo, uf.sigla_uf, count(*) from candidato ca, municipio mun, uf uf
where ca.cod_municipio_residencia=mun.cod_municipio
and mun.sequencial_uf=uf.sequencial_uf
group by ca.tp_sexo, uf.sigla_uf
order by uf.sigla_uf


--DW-2014
select dl.sigla_uf, dpc.tp_sexo, count(*)
from f_inscricao fi, d_perfil_candidato dpc, d_localidade dl
where fi.pk_localidade= dl.pk_localidade and 
fi.pk_candidato=dpc.pk_candidato
group by dpc.tp_sexo, dl.sigla_uf 
order by dl.sigla_uf



--Transacional-2014
select es.cod_escola, es.nome_escola, que.sequencial_questao, count(*)
from candidato ca, escola es, municipio mun, uf uf, 
realiza rea, prova pro, area ar, contem con, questao que, 
responde res
where ca.cod_escola=es.cod_escola and 
es.cod_municipio_escola=mun.cod_municipio and 
mun.sequencial_uf=uf.sequencial_uf and
ca.nu_inscricao=rea.nu_inscricao and 
rea.id_prova=pro.id_prova and
pro.cod_area=ar.cod_area and
pro.id_prova=con.id_prova and
con.sequencial_questao=que.sequencial_questao and
ca.nu_inscricao=res.nu_inscricao and 
res.sequencial_questao=que.sequencial_questao and
res.resposta_questao=que.gabarito_en and
ar.sigla_area='CH' and
uf.sigla_uf='RJ' and
ca.nu_inscricao=140000000037
group by es.cod_escola, es.nome_escola, que.sequencial_questao


select es.cod_escola, es.nome_escola, count(*)
from candidato ca, escola es, municipio mun, uf uf, 
realiza rea, prova pro, area ar, contem con, questao que, 
responde res
where ca.cod_escola=es.cod_escola and 
es.cod_municipio_escola=mun.cod_municipio and 
mun.sequencial_uf=uf.sequencial_uf and
ca.nu_inscricao=rea.nu_inscricao and 
rea.id_prova=pro.id_prova and
pro.cod_area=ar.cod_area and
pro.id_prova=con.id_prova and
con.sequencial_questao=que.sequencial_questao and
ca.nu_inscricao=res.nu_inscricao and 
res.sequencial_questao=que.sequencial_questao and
res.resposta_questao=que.gabarito_en and
ar.sigla_area='CH' and
uf.sigla_uf='RJ'
group by es.cod_escola, es.nome_escola


-- DW:2014

select de.cod_escola, de.nome_escola, count(*) 
from f_desempenho_prova fdp, d_escola de, d_localidade dl, 
d_perfil_candidato dpc, d_prova dp, d_questao dq
where fdp.pk_escola=de.pk_escola and
fdp.pk_localidade=dl.pk_localidade and
fdp.pk_candidato=dpc.pk_candidato and
fdp.pk_prova=dp.pk_prova and
dp.id_prova=dq.id_prova and
dp.nome_area='PROVA DE CIENCIA HUMANAS' and
dl.sigla_uf='RJ'
group by de.cod_escola, de.nome_escola

=========================================================================================================
-- Qual a média das notas dos alunos com necessidade especiais por estado?

select nep.in_deficiencia_auditiva,nep.in_deficiencia_mental,nep.in_deficit_atencao,
nep.in_baixa_visao,nep.in_sabatista,nep.in_dislexia,nep.in_gestante,nep.in_cegueira,
nep.in_lactante,nep.in_surdez,nep.in_autismo,nep.in_idoso, uf.sigla_uf,round(avg(rea.nota_prova),2)
from candidato can
join realiza rea on (can.nu_inscricao=rea.nu_inscricao)
join necessidades_especiais nep on (can.nu_inscricao=nep.nu_inscricao)
join municipio mun on (mun.cod_municipio=can.cod_municipio_residencia)
join uf uf on (mun.sequencial_uf=uf.sequencial_uf)
where (nep.in_deficiencia_auditiva = 1 or 
nep.in_deficiencia_mental = 1 or 
nep.in_deficit_atencao = 1 or 
nep.in_baixa_visao=1 or 
nep.in_sabatista=1 or
nep.in_dislexia =1 or
nep.in_gestante=1 or
nep.in_cegueira=1 or 
nep.in_lactante=1 or 
nep.in_surdez=1 or
nep.in_autismo=1 or
nep.in_idoso=1)
--and sigla_uf='AM'
group by nep.in_deficiencia_auditiva,nep.in_deficiencia_mental,nep.in_deficit_atencao,
nep.in_baixa_visao,nep.in_sabatista,nep.in_dislexia,nep.in_gestante,nep.in_cegueira,
nep.in_lactante,nep.in_surdez,nep.in_autismo,nep.in_idoso, uf.sigla_uf

===================================================================================================================================================================================

select spcname
      ,pg_tablespace_location(oid) 
from   pg_tablespace


update f_inscricao_teste
set pk_localidade_nascimento=dl.pk_localidade
from f_inscricao_teste fit, d_localidade dl, dblink('host=localhost user=anacrl password=ljk14253 dbname=bd_enem_dados_2014',
					 'select * from view_cod_municipio_nascimento') 
					 t (nu_inscricao double precision, cod_municipio_nascimento numeric)
where fit.nu_inscricao=t.nu_inscricao
and dl.cod_municipio=t.cod_municipio_nascimento
and dl.pk_localidade <> 0


update f_inscricao_teste as fit
set pk_localidade_nascimento=filn.pk_localidade
from f_inscricao_localidade_nascimento filn
where fit.nu_inscricao=filn.nu_inscricao
====================================================================================================================================================================================


select ca.nu_inscricao, cod_municipio_residencia, cod_municipio_nascimento, cod_municipio_prova
from candidato ca, municipio mu where (ca.cod_municipio_residencia=mu.cod_municipio or 
	ca.cod_municipio_nascimento=mu.cod_municipio or ca.cod_municipio_prova=mu.cod_municipio)
order by ca.nu_inscricao

====================================================================================================================================================================================

select t.sigla_uf,
	   t.acesso_internet,
	   t.nu_ano,
	   sum(t.qtd)
from 
(select dl.sigla_uf, dt.nu_ano,
		CASE
		when (((dps.acesso_internet='A' or dps.acesso_internet='B' or dps.acesso_internet='C') and dt.nu_ano = 2014) OR (dps.acesso_internet='B' and dt.nu_ano = 2015)) then 'SIM'
		when ((dps.acesso_internet='A' and dt.nu_ano = 2015) OR (dps.acesso_internet='D' and dt.nu_ano = 2014))  then 'NAO'
		END AS ACESSO_INTERNET,
count(*) AS QTD from f_inscricao fi
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_perfil_socio dps on fi.pk_perfil_socio=dps.pk_perfil_socio
where dps.acesso_internet notnull
group by dl.sigla_uf, ACESSO_INTERNET, dt.nu_ano) t
group by t.sigla_uf, t.acesso_internet, t.nu_ano

================================================================================================================================================================================================

update d_necessidades_especiais dn
set in_deficiencia_fisica=dner.in_deficiencia_fisica
from d_necessidades_especiais_repair dner
where (dn.in_deficiencia_auditiva=dner.in_deficiencia_auditiva
and dn.in_deficiencia_mental=dner.in_deficiencia_mental
and dn.in_deficit_atencao=dner.in_deficit_atencao
and dn.in_baixa_visao=dner.in_baixa_visao
and dn.in_sabatista=dner.in_sabatista
and dn.in_dislexia=dner.in_dislexia
and dn.in_gestante=dner.in_gestante
and dn.in_cegueira=dner.in_cegueira
and dn.in_lactante=dner.in_lactante
and dn.in_surdez=dner.in_surdez
and dn.in_autismo=dner.in_autismo
and dn.in_idoso=dner.in_idoso)
and dn.pk_necessidades_especiais<>-1