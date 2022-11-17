--st 7:15
--1.
-- Nalezn�te z�pasy, kde dom�c� t�m zv�t�zil, ale hostuj�c� t�m nast��lel v dan� sez�n� celkov� v�ce ne� dvojn�sobek g�l�.

-- V�sledek z�pasu naleznete v atributech game.home_goals a game.away_goals.

-- Po�et nast��len�ch g�l� t�mem v sez�n� pak naleznete nejjednodu�eji v game_teams_stats.goals.

-- Vypi�te sez�nu, datum a �as, jm�na t�m�, po�et g�l� dom�ci, po�et g�l� hostuj�c� a pak po�et g�l� v sez�n� dom�c�ch a po�et g�l� v sez�n� hostuj�c�ch

--moje 
with tab as 
(
select g.season, ti.team_id, teamName, sum(goals) gls
from game_teams_stats gts
join game g on gts.game_id = g.game_id
join team_info ti on gts.team_id = ti.team_id
group by g.season, ti.team_id, teamName
)

SELECT game_id, tih.teamName home, home_goals, t1.gls home_gls_season, t2.gls away_gls_season, tia.teamName away, away_goals, g.season
from game g
join tab t1 on g.home_team_id = t1.team_id AND g.season = t1.season
join tab t2 on g.away_team_id = t2.team_id AND g.season = t2.season
join team_info tih on g.home_team_id = tih.team_id
join team_info tia on g.away_team_id = tia.team_id
where home_goals > away_goals
AND
t2.gls > 2*t1.gls

--off
select *

from (

select g.season, g.date_time_GMT, ti1.teamName home_team, ti2.teamName away_team, g.home_goals, g.away_goals, (

select sum(goals)

from team_info ti

join game_teams_stats gts on ti.team_id = gts.team_id

join game g2 on gts.game_id = g2.game_id

where ti.team_id = g.home_team_id and g.season = g2.season

) home_team_season_goals, (

select sum(goals)

from team_info ti

join game_teams_stats gts on ti.team_id = gts.team_id

join game g2 on gts.game_id = g2.game_id

where ti.team_id = g.away_team_id and g.season = g2.season

) away_team_season_goals

from game g

join team_info ti1 on g.home_team_id = ti1.team_id

join team_info ti2 on g.away_team_id = ti2.team_id

) t

where t.away_goals < t.home_goals and t.away_team_season_goals > 2 * t.home_team_season_goals


--2.

-- Vypi�te t�my, kter� se v sez�n� 20102011 vyhrali v hal�ch 'Rogers Arena', 'Verizon Center', 'Philips Arena' (game.venue).

-- Informaci o vyhran�m nebo prohran�m z�pase naleznete v atributu game_teams_stats.won

--moje
select distinct team_id
from game_teams_stats
where won = 'TRUE'
and game_id in
(
select game_id
from game
where season = 20102011 AND venue in('Rogers Arena', 'Verizon Center', 'Philips Arena')
)

--off
select ti.team_id, ti.teamName

from team_info ti

join game_teams_stats gts on ti.team_id = gts.team_id

join game g on g.game_id = gts.game_id

where gts.won = 'TRUE' and g.season = 20102011 and venue in ('Rogers Arena', 'Verizon Center', 'Philips Arena')

group by ti.team_id, ti.teamName

having count(distinct venue) = 3


--3
-- U rozhod��ch, kte�� p�skali z�pas 5.11.2019 na TD Garden (game.venue) zjist�te n�sleduj�c� statistiky:

-- 1. Po�et z�pas�, kter� p�skali kde hr�l t�m Penguins (teamName)

-- 2. Po�et z�pas�, kter� p�skali kde hr�l t�m Bruins (teamName)

-- Pro nalezen� z�pas� v dan�m dnu pou�ijte cast(g.date_time_GMT as date) = '2019-11-05'

----off---
select gof.official_name, (

select count(*)

from game_officials gof2

join game g on gof2.game_id = g.game_id

join game_teams_stats gts on g.game_id = gts.game_id

join team_info ti on ti.team_id = gts.team_id

where gof.official_name = gof2.official_name and ti.teamName = 'Penguins'

) ,

(

select count(*)

from game_officials gof2

join game g on gof2.game_id = g.game_id

join game_teams_stats gts on g.game_id = gts.game_id

join team_info ti on ti.team_id = gts.team_id

where gof.official_name = gof2.official_name and ti.teamName = 'Bruins'

)

from game_officials gof

where exists (

select 1

from game g

where cast(g.date_time_GMT as date) = '2019-11-05' and venue = 'TD Garden' and gof.game_id = g.game_id

)


---moje
select * from team_info ti
where team_id
not in(
select distinct away_team_id
from game
where away_goals > home_goals + 3
and season = 20052006)
AND exists
(
select 1
from game_teams_stats gts
join game g on gts.game_id = g.game_id
where g.season = 20052006 AND ti.team_id = gts.team_id
)