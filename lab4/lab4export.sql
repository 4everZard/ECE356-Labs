SELECT * FROM
(SELECT DISTINCT(playerID), inducted FROM HallOfFame WHERE (inducted = "N" AND playerID NOT IN (SELECT playerID FROM HallOfFame WHERE inducted = "Y")) OR inducted = "Y") AS i
INNER JOIN 
(SELECT DISTINCT(h.playerID), SUM(b.H), SUM(b.HR), SUM(b.R), SUM(b.RBI), SUM(p.SO), SUM(p.H), AVG(p.ERA), SUM(f.PO), SUM(f.SB), SUM(f.CS)
    FROM HallOfFame AS h LEFT JOIN Batting AS b ON h.playerID = b.playerID LEFT JOIN Pitching AS p ON h.playerID = p.playerID LEFT JOIN Fielding AS f ON h.playerID = f.playerID
    GROUP BY playerID) AS f
ON i.playerID = f.playerID;