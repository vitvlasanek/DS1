--příklad 1:
--Vzpište jména hráčů, kteří v každém roce, ve kterém hráli minimálně jeden zápas, nastříleli alespoň 15 gólů (game.skater_stats.goals)
SELECT DISTINCT(pli.firstName), pli.lastName
FROM player_info pli
JOIN game_skater_stats gss ON pli.player_id = gss.player_id
LEFT JOIN game g ON gss.game_id = g.game_id
WHERE gss.player_id = pli.player_id
GROUP BY pli.firstName, pli.lastName, YEAR(g.date_time_GMT)
HAVING NOT COUNT(gss.goals) < 15
ORDER BY pli.firstName

--WHERE NOT EXISTS (SELECT * FROM game_skater_stats
--					left JOIN game g ON game_skater_stats.game_id = g.game_id
--					WHERE pli.player_id = game_skater_stats.player_id AND game_skater_stats.goals < 15)

--JOIN game_skater_stats gss ON pli.player_id = gss.player_id
--JOIN game g ON gss.game_id = g.game_id

--GROUP BY pli.firstName, pli.lastName, YEAR(g.date_time_GMT)
--HAVING COUNT(gss.goals) > 15
--ORDER BY pli.firstName
--WHERE NOT EXISTS (SELECT * FROM game_skater_stats WHERE COUNT(gss.goals) > 15)


--(SELECT gss.player_id FROM game_skater_stats gss
--LEFT JOIN game g ON gss.game_id = g.game_id
--WHERE gss.player_id = pli.player_id
--GROUP BY pli.firstName, pli.lastName, YEAR(g.date_time_GMT)
--HAVING COUNT(gss.goals) > 15)
--ORDER BY pli.firstName


--příklad 2:
--Pro každého hráče ze švédska (player_info.nationality) hrajícího obranu (player_info.primaryPosition = D), vypište následující údaje
--	Kolikrát byl trestán za sekání
--	Počet různých měsíců ve kterých v roce 2011 hrál
--	ID hráče
--	jméno a příjmení hráče

SELECT pli.player_id,  pli.firstName, pli.lastName, COUNT(p.secondaryType) AS trestu_za_sekani, COUNT(DISTINCT MONTH(g.date_time_GMT)) AS ruzne_mesice_v_2011
FROM player_info pli
LEFT JOIN game_plays_players gpp ON pli.player_id = gpp.player_id
LEFT JOIN game_plays p ON gpp.play_id = p.play_id AND p.secondaryType = 'Slashing'
JOIN game_skater_stats gss ON pli.player_id = gss.player_id
JOIN game g ON gss.game_id = g.game_id AND YEAR(g.date_time_GMT) = '2011'
WHERE pli.nationality = 'FIN' AND pli.primaryPosition = 'D'
GROUP BY pli.player_id,  pli.firstName, pli.lastName


--příklad 3:
--Nalezněte zápasy odehrané v TD Garder (game.venue), kde všichni hráči ve hře měli minimálně jednu minutu vyloučení (game.skater_stats.penaltyMinutes). 
--Vynechte zápasy, které nemají v tabulce game_skater_stats žádné záznamy. 
--Vypište datum zápasu, místo (venue), jména týmů,v zápase a výsledné skóre zápasu(game.away_goals a game.home_goals)
SELECT g.date_time_GMT, g.venue, ht.teamName AS home_team, awt.teamName AS away_team, g.home_goals, g.away_goals
FROM game g 
LEFT JOIN team_info ht ON g.home_team_id = ht.team_id
LEFT JOIN team_info awt ON g.away_team_id = awt.team_id
WHERE 0 < ALL(SELECT gss.penaltyMinutes FROM game_skater_stats gss WHERE g.game_id = gss.game_id) AND g.venue = 'TD Gardner'
ORDER BY g.venue
