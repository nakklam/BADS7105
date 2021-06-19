WITH
Transaction_Covert_Date AS(
    SELECT
    cust_code,
    PARSE_DATE('%Y%m%d', CAST(shop_date AS STRING)) as convert_shop_date,
  FROM `customer-segment.nidadataset.supermarket`
),
Customer_Shop_Month AS (
  SELECT
    DISTINCT cust_code,
    DATE_TRUNC(convert_shop_date, month) shop_month
  FROM Transaction_Covert_Date
  WHERE cust_code IS NOT NULL
),
Customer_Shop_Previous AS (
  SELECT 
    cust_code, 
    shop_month,
    LAG(shop_month, 1) OVER(PARTITION BY cust_code ORDER BY shop_month) AS shop_prev_month,
  FROM Customer_Shop_Month
),
Customer_Shop_Type AS(
  SELECT
    cust_code, 
    shop_month,
    shop_prev_month,
    CASE 
      WHEN DATE_DIFF(shop_month, shop_prev_month, MONTH) IS NULL THEN 'New'
      WHEN DATE_DIFF(shop_month, shop_prev_month, MONTH) = 1 THEN 'Repeat'
      WHEN DATE_DIFF(shop_month, shop_prev_month, MONTH) > 1 THEN 'Reactivated'
    ELSE NULL 
    END AS type_tag
  FROM Customer_Shop_Previous
),
Customer_Count_Type AS(
    SELECT
        shop_month, 
        COUNT(CASE WHEN type_tag = 'New' THEN cust_code ELSE NULL END) AS num_new_cust, 
        COUNT(CASE WHEN type_tag = 'Repeat' THEN cust_code ELSE NULL END) AS num_repeat_cust, 
        COUNT(CASE WHEN type_tag = 'Reactivated' THEN cust_code ELSE NULL END) AS num_reactivated_cust,
        COUNT(cust_code) AS total_cust
    FROM Customer_Shop_Type
    GROUP BY shop_month
)

SELECT 
    FORMAT_DATE("%m/%y", shop_month) as Month,
    num_new_cust AS New_Customer, 
    num_repeat_cust AS Repeat_Customer, 
    num_reactivated_cust AS Reactivated_Customer,
    num_repeat_cust - LAG(total_cust, 1) OVER(ORDER BY shop_month) AS Churn_Customer
FROM Customer_Count_Type
ORDER BY shop_month