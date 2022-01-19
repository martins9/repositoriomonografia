-- 1) 	Qual a média das notas dos alunos por estado, por tipo de prova e por ano?
select dl.sigla_uf, dp.nome_area, dt.nu_ano, ROUND(AVG(fdp.notaprova)::NUMERIC,2) AS NOTA_PROVA
from f_desempenho_prova fdp
join d_localidade dl on fdp.pk_localidade_residencia=dl.pk_localidade
join d_prova dp on fdp.pk_prova = dp.pk_prova
join d_tempo dt on fdp.pk_tempo=dt.pk_tempo
group by dl.sigla_uf, dp.nome_area, dt.nu_ano


-- 2)	Qual perfil socioeconômico dos alunos agrupando por estado e por ano?
select (CASE 
		WHEN dps.nivel_financeiro_familiar = 'A' and (dt.nu_ano in ('2014','2015')) THEN 'Nenhuma renda'
		WHEN dps.nivel_financeiro_familiar = 'B' and dt.nu_ano = '2014' THEN 'Até R$ 724,00'
		WHEN dps.nivel_financeiro_familiar = 'B' and dt.nu_ano = '2015' THEN 'Até R$ 788,00'
		WHEN dps.nivel_financeiro_familiar = 'C' and dt.nu_ano = '2014' THEN 'De R$724,01 a R$ 1.086,00'
		WHEN dps.nivel_financeiro_familiar = 'C' and dt.nu_ano = '2015' THEN 'De R$ 788,01 até R$ 1.182,00'
		WHEN dps.nivel_financeiro_familiar = 'D' and dt.nu_ano = '2014' THEN 'De R$ 1.086,01 até R$ 1.448,00'
		WHEN dps.nivel_financeiro_familiar = 'D' and dt.nu_ano = '2015' THEN 'De R$ 1.182,01 até R$ 1.572,00'
		WHEN dps.nivel_financeiro_familiar = 'E' and dt.nu_ano = '2014' THEN 'De R$ 1.448,01 até R$ 1.810,00'
		WHEN dps.nivel_financeiro_familiar = 'E' and dt.nu_ano = '2015' THEN 'De R$ 1.572,01 até R$ 1.970,00'
		WHEN dps.nivel_financeiro_familiar = 'F' and dt.nu_ano = '2014' THEN 'De R$ 1.810,01 até R$ 2.172,00'
		WHEN dps.nivel_financeiro_familiar = 'F' and dt.nu_ano = '2015' THEN 'De R$ 1.970,01 até R$ 2.364,00'
		WHEN dps.nivel_financeiro_familiar = 'G' and dt.nu_ano = '2014' THEN 'De R$ 2.172,01 até R$ 2.896,00'
		WHEN dps.nivel_financeiro_familiar = 'G' and dt.nu_ano = '2015' THEN 'De R$ 2.364,01 até R$ 3.152,00'
		WHEN dps.nivel_financeiro_familiar = 'H' and dt.nu_ano = '2014' THEN 'De R$ 2.896,01 até R$ 3.620,00'
		WHEN dps.nivel_financeiro_familiar = 'H' and dt.nu_ano = '2015' THEN 'De R$ 3.152,01 até R$ 3.940,00'
	   	WHEN dps.nivel_financeiro_familiar = 'I' and dt.nu_ano = '2014' THEN 'De R$ 3.620,01 até R$ 4.344,00'
		WHEN dps.nivel_financeiro_familiar = 'I' and dt.nu_ano = '2015' THEN 'De R$ 3.940,01 até R$ 4.728,00'
		WHEN dps.nivel_financeiro_familiar = 'J' and dt.nu_ano = '2014' THEN 'De R$ 4.344,01 até R$ 5.068,00'
		WHEN dps.nivel_financeiro_familiar = 'J' and dt.nu_ano = '2015' THEN 'De R$ 4.728,01 até R$ 5.516,00'
		WHEN dps.nivel_financeiro_familiar = 'K' and dt.nu_ano = '2014' THEN 'De R$ 5.068,01 até R$ 5.792,00'
		WHEN dps.nivel_financeiro_familiar = 'K' and dt.nu_ano = '2015' THEN 'De R$ 5.516,01 até R$ 6.304,00'
		WHEN dps.nivel_financeiro_familiar = 'L' and dt.nu_ano = '2014' THEN 'De R$ 5.792,01 até R$ 6.516,00'
		WHEN dps.nivel_financeiro_familiar = 'L' and dt.nu_ano = '2015' THEN 'De R$ 6.304,01 até R$ 7.092,00'
		WHEN dps.nivel_financeiro_familiar = 'M' and dt.nu_ano = '2014' THEN 'De R$ 6.516,01 até R$ 7.240,00'
		WHEN dps.nivel_financeiro_familiar = 'M' and dt.nu_ano = '2015' THEN 'De R$ 7.092,01 até R$ 7.880,00'
		WHEN dps.nivel_financeiro_familiar = 'N' and dt.nu_ano = '2014' THEN 'De R$ 7.240,01 até R$ 8.688,00'
		WHEN dps.nivel_financeiro_familiar = 'N' and dt.nu_ano = '2015' THEN 'De R$ 7.880,01 até R$ 9.456,00'
		WHEN dps.nivel_financeiro_familiar = 'O' and dt.nu_ano = '2014' THEN 'De R$ 8.688,01 até R$ 10.860,00'
		WHEN dps.nivel_financeiro_familiar = 'O' and dt.nu_ano = '2015' THEN 'De R$ 9.456,01 até R$ 11.820,00'
		WHEN dps.nivel_financeiro_familiar = 'P' and dt.nu_ano = '2014' THEN 'De R$ 10.860,01 até R$ 14.480,00'
		WHEN dps.nivel_financeiro_familiar = 'P' and dt.nu_ano = '2015' THEN 'De R$ 11.820,01 até R$ 15.760,00'
		WHEN dps.nivel_financeiro_familiar = 'Q' and dt.nu_ano = '2014' THEN 'Mais de R$ 14.480,01'
		WHEN dps.nivel_financeiro_familiar = 'Q' and dt.nu_ano = '2015' THEN 'Mais de 15.760,00'
		END ) AS AVALIACAO_FAMILIAR,
		dl.sigla_uf, dt.nu_ano, dpc.tp_sexo, count(*) AS QTD 
from f_inscricao fi
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_perfil_candidato dpc on fi.pk_candidato = dpc.pk_candidato
join d_perfil_socioeconomico dps on fi.pk_perfil_socio=dps.pk_perfil_socio
group by dps.nivel_financeiro_familiar, dl.sigla_uf, dpc.tp_sexo, dt.nu_ano
order by dl.sigla_uf


-- 3) Qual a média das notas dos alunos com necessidade especiais por estado e por ano? 
select dl.sigla_uf, dp.nome_area, dt.nu_ano, ROUND(AVG(fdp.notaprova)::NUMERIC,2) AS NOTA_PROVA
from f_desempenho_prova fdp
join d_localidade dl on fdp.pk_localidade_residencia=dl.pk_localidade
join d_prova dp on fdp.pk_prova = dp.pk_prova
join d_tempo dt on fdp.pk_tempo=dt.pk_tempo
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
group by dl.sigla_uf, dp.nome_area, dt.nu_ano


-- 4) Qual o total de inscritos no Enem por ano, sexo e estado? 
select dl.sigla_uf, dt.nu_ano, dpc.tp_sexo, count(*) AS QTD 
from f_inscricao fi
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_perfil_candidato dpc on fi.pk_candidato = dpc.pk_candidato
group by dl.sigla_uf, dpc.tp_sexo, dt.nu_ano

-- 6) Qual a porcentagem de acertos e erros por prova, estado e sexo
select fdp.qtdacertos, fdp.qtderros
from f_desempenho_prova fdp
join d_tempo dt on fdp.pk_tempo = dt.pk_tempo
join d_prova dp on fdp.pk_prova = dp.pk_prova
join d_escola de on fdp.pk_escola=de.pk_escola
join d_localidade dl on de.pk_localidade=dl.pk_localidade


select  de.nome_escola, dp.nome_area, dt.nu_ano, 
	sum(fdp.qtdacertos) as acertos, 
	sum(fdp.qtderros) as erros, 
	fdp.qtdacertos+fdp.qtderros as total
	from f_desempenho_prova fdp
	join d_tempo dt on fdp.pk_tempo = dt.pk_tempo
	join d_prova dp on fdp.pk_prova = dp.pk_prova
	join d_escola de on fdp.pk_escola=de.pk_escola
	join d_localidade dl on de.pk_localidade=dl.pk_localidade
	group by de.nome_escola, dp.nome_area, dt.nu_ano, fdp.qtdacertos, fdp.qtderros


-- 7) Qual a média da escola referente a média das notas nas provas referente ao nível nacional?
select dp.nome_area, dt.nu_ano, de.nome_escola, round(cast(avg(fdp.notaprova) as numeric),2) as Media_Prova
from f_desempenho_prova fdp 
join d_escola de on fdp.pk_escola=de.pk_escola
join d_prova dp on fdp.pk_prova=dp.pk_prova
join d_tempo dt on fdp.pk_tempo=dt.pk_tempo
group by de.nome_escola, dp.nome_area, dt.nu_ano


-- 8) Qual a média da escola referente a média das notas nas provas referente ao nível estadual?
select dp.nome_area, dl.sigla_uf, dt.nu_ano, de.nome_escola, round(cast(avg(fdp.notaprova) as numeric),2) as Media_Prova
from f_desempenho_prova fdp 
join d_escola de on fdp.pk_escola=de.pk_escola
join d_localidade dl on de.pk_localidade=dl.pk_localidade
join d_prova dp on fdp.pk_prova=dp.pk_prova
join d_tempo dt on fdp.pk_tempo=dt.pk_tempo
group by de.nome_escola, dp.nome_area, dl.sigla_uf, dt.nu_ano


-- 9) Quantas pessoas deficientes se inscreveram no ENEM por estado e por ano?
select
SUM(case when dd.in_deficiencia_auditiva='Sim' THEN 1 ELSE 0 END) AS Deficiencia_Auditiva,
SUM(case when dd.in_deficiencia_mental='Sim' THEN 1 ELSE 0 END) AS Deficiencia_Mental,
SUM(case when dd.in_deficit_atencao='Sim' THEN 1 ELSE 0 END) AS Deficit_Atencao,
SUM(case when dd.in_baixa_visao='Sim' THEN 1 ELSE 0 END) AS Baixa_Visao,
SUM(case when dd.in_sabatista='Sim' THEN 1 ELSE 0 END) AS Sabatista,
SUM(case when dd.in_dislexia='Sim' THEN 1 ELSE 0 END) AS Dislexia,
SUM(case when dd.in_gestante='Sim' THEN 1 ELSE 0 END) AS Gestante,
SUM(case when dd.in_cegueira='Sim' THEN 1 ELSE 0 END) AS Cegueira,
SUM(case when dd.in_lactante='Sim' THEN 1 ELSE 0 END) AS Lactante,
SUM(case when dd.in_surdez='Sim' THEN 1 ELSE 0 END) AS Surdez,
SUM(case when dd.in_autismo='Sim' THEN 1 ELSE 0 END) AS Autismo,
SUM(case when dd.in_idoso='Sim' THEN 1 ELSE 0 END) AS Idoso,
dl.sigla_uf, dt.nu_ano
from f_inscricao fi
join d_localidade dl on fi.pk_localidade_residencia=dl.pk_localidade
join d_tempo dt on fi.pk_tempo=dt.pk_tempo
join d_necessidades_especiais dd on fi.pk_necessidades_especiais=dd.pk_necessidades_especiais
group by dl.sigla_uf, dt.nu_ano


-- 10) Quantas pessoas deficientes se inscreveram agrupados por tipo de deficiência, estado e por ano?)
select 
SUM(case when da.in_mesa_cadeira_separada='Sim' THEN 1 ELSE 0 END) AS Mesa_Cadeira_Separada,
SUM(case when da.in_leitura_labial='Sim' THEN 1 ELSE 0 END) AS Leitura_Labial,
SUM(case when da.in_mesa_cadeira_rodas='Sim' THEN 1 ELSE 0 END) AS Mesa_Cadeira_Rodas,
SUM(case when da.in_guia_interprete='Sim' THEN 1 ELSE 0 END) AS Guia_Interprete,
SUM(case when da.in_apoio_perna='Sim' THEN 1 ELSE 0 END) AS Apoio_Perna,
SUM(case when da.in_transcricao='Sim' THEN 1 ELSE 0 END) AS Transcricao,
SUM(case when da.in_libras='Sim' THEN 1 ELSE 0 END) AS Libras,
SUM(case when da.in_ledor='Sim' THEN 1 ELSE 0 END) AS Ledor,
SUM(case when da.in_acesso='Sim' THEN 1 ELSE 0 END) AS In_Acesso,
dt.nu_ano, dl.sigla_uf
from f_inscricao fi, d_auxilio da, d_tempo dt, d_localidade dl
where fi.pk_auxilio=da.pk_auxilio and
fi.pk_tempo=dt.pk_tempo and
fi.pk_localidade_residencia=dl.pk_localidade
