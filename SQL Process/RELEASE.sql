-- USE Games

WITH 
skip_user AS 
(
    SELECT 
        [user]
        -- , COUNT([user]) AS num
    FROM 
        (
            SELECT DISTINCT 
                [user]
                , day0
            FROM data_game
        ) RAW_1
    GROUP BY [user]
    HAVING COUNT([user]) > 1

        /* loại bỏ những user này -- user có nhiều hơn 1 day0
            109af4536eaa15b4512bdd439b469f63 
            6cec003a839b3560eeb94fba674488dd 
            3240ebc3ea65615b27c992f23f32d1f3 
            adfecf41987d22fad5e994732b8fc7de 
        */
)
, RAW_ AS  -- DỮ LIỆU ĐÃ LOẠI BỎ 4 USER CÓ NHIỀU HƠN 1 DAY0
(
    SELECT *
    FROM data_game
    WHERE [user] NOT IN (SELECT * FROM skip_user)
    -- WHERE [user] = 'adfecf41987d22fad5e994732b8fc7de'
)
, join_1day AS  -- USER CHỈ CÓ DAY_DIFF = 0
(
    SELECT *
    FROM RAW_
    WHERE [user] IN (
                        SELECT DISTINCT 
                            [user]
                        FROM RAW_
                        GROUP BY [user]
                        HAVING COUNT(DISTINCT day_diff) = 1
                    )
)
, result_join_a_day AS -- churn : chỉ có 1 day_diff = 0, stay : có nhiều hơn 1 day_diff = 0
(
    SELECT
        [user]
        , date_time
        , SUM(quantity) AS duration_played
        , COUNT(DISTINCT [level]) AS all_level_played
        , CASE 
            WHEN SUM(quantity) < 60 THEN '<1m'
            WHEN SUM(quantity) < 3600 THEN STR(SUM(quantity) / 60) + 'm'
            ELSE STR(SUM(quantity) / 3600) + 'h'
        END AS [minues]
        , 'churn' AS stay_churn
        , [version]
    FROM join_1day
    WHERE event_name <> 'tutorial'
    GROUP BY 
        [user]
        , date_time
        , [version]
    UNION 
    SELECT 
        [user]
        , date_time
        , SUM(quantity) AS duration_played
        , COUNT(DISTINCT [level]) AS all_level_played
        , CASE 
            WHEN SUM(quantity) < 60 THEN '<1m'
            WHEN SUM(quantity) < 3600 THEN STR(SUM(quantity) / 60) + 'm'
            ELSE STR(SUM(quantity) / 3600) + 'h'
        END AS [minues]
        , 'stay' AS stay_churn
        , [version]
    FROM RAW_
    WHERE event_name <> 'tutorial'
        AND [user] NOT IN (
                            SELECT DISTINCT [user]
                            FROM join_1day
                        )
    GROUP BY 
        [user]
        , date_time
        , [version]
)
, result_continue_play AS  -- USER TIẾP TỤC CHƠI SAU NGÀY ĐẦU TIÊN
(
    SELECT R.*
    FROM RAW_ R 
        INNER JOIN 
        (
            SELECT *
            FROM RAW_
            WHERE event_name = 'user_engagement'
                AND day_diff = 0
        ) T ON R.[user] = T.[user]
            AND R.event_name = T.event_name
            AND R.day_diff > T.day_diff
)
, result_bonus_lives AS
(
    SELECT 
        [user]
        , date_time
        , reason_to_die
        , COUNT(reason_to_die) AS num_of_lose
    FROM RAW_
    WHERE win = 0
    GROUP BY 
        [user]
        , date_time
        , reason_to_die
)
, result_level_played AS -- USER CHƠI TỚI NHỮNG LEVEL NÀO
(
    SELECT 
        [user]
        , [version]
        , COUNT(DISTINCT [level]) AS num_of_level
    FROM RAW_
    GROUP BY 
        [user]
        , [version]
)
, result_time_played_by_level AS -- THỜI GIAN CHƠI CỦA TỪNG LEVEL
(
    SELECT 
        [user]
        , [level]
        , SUM(quantity) AS [time_played]
        , [version]
    FROM RAW_
    WHERE event_name = 'game_end'
    GROUP BY 
        [user]
        , [level]
        , [version]
)
, result_time_played_lose AS 
(
    SELECT 
        [user]
        , [level]
        , SUM(quantity) AS [time_played]
        , COUNT(reason_to_die) AS [num_of_lose]
        , [version]
    FROM RAW_
    WHERE 
        event_name = 'game_end'
        AND win = 0
    GROUP BY 
        [user]
        , [level]
        , [version]
)
SELECT *
FROM result_time_played_lose
