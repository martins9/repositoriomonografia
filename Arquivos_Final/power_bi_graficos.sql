-- 4) Qual o total de inscritos no Enem por ano, sexo e estado? 

select dl.sigla_uf, dt.nu_ano, dpc.tp_sexo, count(*) AS QTD 
from f_inscricao fi
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_perfil_candidato dpc on fi.pk_candidato = dpc.pk_candidato
group by dl.sigla_uf, dpc.tp_sexo, dt.nu_ano


-- 8) Quantas pessoas deficientes se inscreveram no ENEM por estado e por ano?

select dl.sigla_uf, dt.nu_ano,
count(*) AS QTD from f_inscricao fi
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_necessidades_especiais dd on fi.pk_necessidades_especiais=dd.pk_necessidades_especiais
where (dd.in_deficiencia_auditiva = 'Sim' or 
dd.in_deficiencia_mental='Sim' or 
dd.in_deficit_atencao='Sim' or 
dd.in_baixa_visao='Sim' or 
dd.in_sabatista='Sim' or
dd.in_dislexia='Sim' or
dd.in_gestante='Sim' or
dd.in_cegueira='Sim' or 
dd.in_lactante='Sim' or 
dd.in_surdez='Sim' or
dd.in_autismo='Sim' or
dd.in_idoso='Sim')
group by dl.sigla_uf, dt.nu_ano
