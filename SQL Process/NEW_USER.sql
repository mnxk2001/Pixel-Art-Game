-- USE Games
/* 
    USER CÓ DAY_DIFF = 0
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
    -- WHERE [user] = 'adfecf41987d22fad5e994732b8fc7de'
)
, new_user_join_tutorial AS -- USER LẦN ĐẦU TẢI APP (DAY_DIFF = 0) VÀ CHỌN XEM HƯỚNG DẪN NGAY TỪ ĐẦU TRONG NGÀY HÔM ĐÓ
(
    SELECT *, 'join' AS tutorial_type
    FROM RAW_
    WHERE event_name = 'tutorial'
        AND quantity = -1 -- XEM HƯỚNG DẪN
        AND day_diff = 0 -- USER LẦN ĐẦU TẢI APP
)
, result_new_user_join_tutorial_once AS -- USER XEM HƯỚNG DẪN 1 LẦN TRONG NGÀY ĐẦU TIÊN TẢI APP
(
    SELECT *
    FROM new_user_join_tutorial
    WHERE [user] NOT IN (
                            -- USER XEM HƯỚNG DẪN NHIỀU LẦN TRONG NGÀY ĐẦU TIÊN TẢI APP -> LOẠI BỎ NHỮNG USER NÀY VÀ PHÂN TÍCH SAU
                            SELECT 
                                [user]
                            FROM new_user_join_tutorial
                            WHERE quantity = -1
                            GROUP BY [user]
                            HAVING COUNT([user]) > 1
                        )
)

, result_new_user_tutorial_type AS -- USER LẦN ĐẦU TẢI APP CHỌN XEM/ KHÔNG XEM TUTORIAL NGAY TRONG NGÀY TẢI APP NGAY TỪ ĐẦU (DAY_DIFF = 0)
(
    SELECT *
    FROM result_new_user_join_tutorial_once
    UNION
    SELECT *, 'skip'
    FROM RAW_
    WHERE 
        [user] NOT IN (SELECT DISTINCT [user] FROM result_new_user_join_tutorial_once)
        AND quantity = 0
        AND day_diff = 0
        AND event_name = 'tutorial'
)
, result_new_user_join_tutorial_finished_or_not AS -- new_user_join_tutorial_once HOÀN THÀNH/ KHÔNG HOÀN THÀNH XEM HƯỚNG DẪN
(
    -- USER CÓ 1 TRẠNG THÁI XEM HƯỚNG DẪN TRONG NGÀY (QUANTITY = -1) NHƯNG CÓ 2 TRẠNG THÁI HOÀN THÀNH XEM HƯỚNG DẪN (QUANTITY = -2)
    -- CÓ 4 USERS -> COUNT(DISTINCT USER)
    SELECT *
        , CASE 
            WHEN quantity = -2 THEN 'Finished'
            ELSE 'Not'
        END AS [status]
    FROM RAW_
    WHERE day_diff = 0
        AND [user] IN (SELECT DISTINCT [user] FROM result_new_user_join_tutorial_once)
        AND quantity IN (-2, 0)
        AND event_name = 'tutorial'
)
, result_most_step AS -- USER XEM NHƯNG KHÔNG HOÀN THÀNH THƯỜNG DỪNG TẠI BƯỚC NÀO
(
    SELECT 
        [user]
        , [version]
        , CASE 
            WHEN COUNT(DISTINCT quantity) = 2 THEN 0
            ELSE COUNT(DISTINCT quantity) - 2
        END AS step
    FROM 
        (
            SELECT *
            FROM RAW_
            WHERE day_diff = 0
                AND [user] IN (
                                SELECT DISTINCT [user]
                                FROM result_new_user_join_tutorial_finished_or_not
                                WHERE quantity = 0
                            )
                AND event_name = 'tutorial'
        ) S
    GROUP BY [user], [version]
)
SELECT *
FROM result_most_step
