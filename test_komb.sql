--1. vypii�te jm�na hr��u, kte�� v ka�d�m roce, ve kter�m hr�li minim�ln� jeden z�pas, nast��leli alespo� 15 gol�
--2. Pro ka�d� lev� k��dlo z �eska v datab�zi vypi�te:
SELECT pl.player_id, pl.firstName, pl.lastName, sum(gss.goals) goals, count(distinct Month(g.date_time_GMT)) months_played
FROM player_info pl
JOIN game_skater_stats gss ON pl.player_id = gss.player_id
JOIN game g on gss.game_id = g.game_id AND year(g.date_time_GMT) = 2010
WHERE nationality = 'CZE' and primaryPosition = 'LW'
group by pl.player_id, firstName, lastName


select pi.player_id, pi.firstName,  pi.lastname, count(distinct month(g.date_time_GMT)), sum(gss.goals)
from player_info pi
join game_skater_stats gss on pi.player_id = gss.player_id
join game g on gss.game_id = g.game_id
where year(g.date_time_GMT) = 2010 and pi.primaryPosition = 'LW' and pi.nationality = 'CZE'
group by pi.player_id, pi.firstName,  pi.lastname

--3.
SELECT game_id, venue
from game
where game_id
not in
(
select game_id
from game_skater_stats
where goals = 0
)
and venue= 'United Center'



select g.venue, ti1.teamName awayTeam, ti2.teamName homeTeam, g.away_goals awayGoals, g.home_goals homeGoals
from game g
join team_info ti1 on g.away_team_id = ti1.team_id
join team_info ti2 on g.home_team_id = ti2.team_id
join game_skater_stats gss on gss.game_id = g.game_id
where not exists (
	select 1
	from game_skater_stats gss
	where gss.game_id = g.game_id and gss.shots = 0
)
group by g.venue, ti1.teamName , ti2.teamName , g.away_goals , g.home_goals 

