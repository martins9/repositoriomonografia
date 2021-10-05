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




select mu.cod_municipio, mu.nome_municipio, uf.sigla_uf
from municipio mu, uf uf
where mu.sequencial_uf=uf.sequencial_uf limit 1000


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