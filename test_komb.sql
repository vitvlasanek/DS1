--1. vypiište jmína hráèu, kteøí v každém roce, ve kterém hráli minimálnì jeden zápas, nastøíleli alespoò 15 golù--SELECT distinct player_id, firstName, lastName--FROM player_info--WHERE player_info.player_id --NOT INwith tab as(	SELECT player_id, year(g.date_time_GMT) y , SUM(gss.goals) g	FROM game_skater_stats gss	JOIN game g ON gss.game_id = g.game_id	GROUP BY player_id, year(g.date_time_GMT))SELECT distinct t1.player_id, pli.firstName, pli.lastNameFROMtab t1JOIN player_info plion t1.player_id = pli.player_idWHERE t1.player_idNOT IN (SELECT player_idfrom tabWHERE g < 15)
--2. Pro každé levé køídlo z Èeska v databázi vypište:
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


