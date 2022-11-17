--st 9:00
--1.ro ka�dou pozici (player_info.primaryPosition) hr��e (mimo g�lmana) nalezn�te hr��e, 
--kter� v z�pasech sez�ny 20142015 (game.season) nast��lel nejv�ce g�l� (game_skater_stats.goals).

--moje
with tab as(
select gss.player_id, sum(goals) gls, pli.primaryPosition
from game_skater_stats gss
join game g on gss.game_id = g.game_id AND g.season = 20142015
join player_info pli on gss.player_id = pli.player_id

group by gss.player_id, pli.primaryPosition
)
select t1.player_id, firstName, lastName, gls, t1.primaryPosition
from player_info pli2
join tab t1 on pli2.player_id=t1.player_id
where not exists
(
select 1 from tab t2
where t1.gls < t2.gls
and t1.primaryPosition = t2.primaryPosition
)

--ze str
with playerstats as (

select pi.player_id, pi.firstName, pi.lastName, pi.primaryPosition, sum(gss.goals) sum_goals

from player_info pi

join game_skater_stats gss on gss.player_id = pi.player_id

join game g on gss.game_id = g.game_id

where g.season = 20142015

group by pi.player_id, pi.firstName, pi.lastName, pi.primaryPosition

)

select *

from playerstats ps1

where sum_goals >= all (

select sum_goals

from playerstats ps2

where ps1.primaryPosition = ps2.primaryPosition


--2(12 bodov)

-- Vyberte g�lmany, kte�� v roce 2018 hr�li z�pasy v hal�ch 'TD Garden', 'Honda Center', 'Amalie Arena' (game.venue).

-- Rok z�pasu z�sk�te s pomoc� funkce year(g.date_time_GMT).

-- Vypi�te player_id, firstName a lastName.

--moje
with tab as
(
select venue, ggs.player_id, count(*) games_in_venue
from game g
join game_goalie_stats ggs on g.game_id=ggs.game_id
where venue in ('TD Garden', 'Honda Center', 'Amalie Arena') AND YEAR(g.date_time_GMT) = 2018
group by venue, ggs.player_id
)
select pli.player_id, pli.firstName, pli.lastName from player_info pli
join tab t1 on pli.player_id = t1.player_id
group by pli.player_id, pli.firstName, pli.lastName
having COUNT(pli.player_id)>2
order by pli.player_id

--off
select pi.player_id, pi.firstName, pi.lastName

from player_info pi

join game_goalie_stats gss on pi.player_id = gss.player_id

join game g on g.game_id = gss.game_id

where year(g.date_time_GMT) = 2018 and venue in ('TD Garden', 'Honda Center', 'Amalie Arena')

group by pi.player_id, pi.firstName, pi.lastName

having count(distinct venue) = 3


-- 3 (12 bodov)

-- U rozhod��ch, kte�� p�skali z�pas 5.11.2019 na TD Garden (game.venue) zjist�te n�sleduj�c� statistiky:

-- 1. Po�et z�pas�, kter� p�skali kde hr�l t�m Penguins (teamName)

-- 2. Po�et z�pas�, kter� p�skali kde hr�l t�m Bruins (teamName)

-- Pro nalezen� z�pas� v dan�m dnu pou�ijte cast(g.date_time_GMT as date) = '2019-11-05'

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