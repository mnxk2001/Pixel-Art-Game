-- USE Games
/*
    USER CŨ DAY_DIFF <> 0
*/

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
        AND event_name = 'tutorial'
        AND day_diff <> 0
    -- WHERE [user] = 'adfecf41987d22fad5e994732b8fc7de'
)
, result_user_join_tutorial AS -- USER CHỌN XEM/ KHÔNG XEM HƯỚNG DẪN
(
    SELECT *, 'join' AS [status]
    FROM RAW_
    WHERE quantity = -1
    UNION ALL 
    SELECT *, 'skip'
    FROM RAW_
    WHERE [user] NOT IN (
                            SELECT DISTINCT [user]
                            FROM RAW_
                            WHERE quantity = -1
                        )
        AND quantity = 0
)
, result_views AS -- SỐ LẦN XEM HƯỚNG DẪN CỦA TỪNG USER
(
    SELECT 
        [user]
        , COUNT(quantity) AS num_of_views
    FROM result_user_join_tutorial
    WHERE quantity = -1
    GROUP BY [user]
)
, result_most_step_old AS -- CÁC BƯỚC DỪNG LẠI CỦA USER KHÔNG HOÀN THÀNH XEM HƯỚNG DẪN
(
    SELECT 
        [user]
        , [version]
        , CASE 
            WHEN COUNT(quantity) = 2 THEN 0
            ELSE COUNT(quantity) - 2
        END AS step
    FROM RAW_
    WHERE [user] IN (
                        SELECT DISTINCT [user]
                        FROM RAW_
                        WHERE [user] IN (
                                            SELECT DISTINCT [user]
                                            FROM result_views
                                            WHERE num_of_views = 1
                                        )
                            AND quantity = 0
                    )
    GROUP BY [user], [version]
)
, result_finished_tutorial_more_time AS  -- USER XEM NHIỀU HƠN 1 LẦN VÀ HOÀN THÀNH XEM HƯỚNG DẪN
(
    SELECT DISTINCT [user]
    FROM RAW_
    WHERE [user] IN (
                        SELECT DISTINCT [user]
                        FROM RAW_
                        WHERE [user] IN (
                                            SELECT [user]
                                            FROM result_views
                                            WHERE num_of_views <> 1
                                        )
                            AND quantity = -2
                    )
)
, result_user_view_tutorial_finished_or_not AS 
(
    SELECT R.*
        , CASE 
            WHEN quantity = -2 THEN 'Finished'
            ELSE 'Not'
        END AS [status]
    FROM RAW_ R 
        INNER JOIN 
        (
            SELECT *
            FROM result_views
            WHERE num_of_views = 1
        ) T ON R.[user] = T.[user]
    WHERE R.quantity IN (-2, 0)
)
SELECT *
FROM result_most_step_old