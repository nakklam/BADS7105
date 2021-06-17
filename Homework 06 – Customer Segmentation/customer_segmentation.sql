CREATE TABLE `customer-segment.nidadataset.Customer_Single_View` AS
SELECT
    cust_code,
    COUNT(DISTINCT basket_id) AS total_visit,
    SUM(spend) AS total_spend,
    DATE_DIFF(MAX(max_shop_date),MAX(convert_shop_date), WEEK) + 1 AS cust_week, -- how far from first transcation
    DATE_DIFF(MAX(max_shop_date),MAX(convert_shop_date), DAY) AS recency,
    COUNT(DISTINCT basket_id)/ (DATE_DIFF(MAX(max_shop_date),MAX(convert_shop_date), WEEK)+1)  AS weekly_frequency,
    SUM(spend)/ (DATE_DIFF(MAX(max_shop_date),MAX(convert_shop_date), WEEK)+1) AS weekly_monetory,
    SUM(spend)/COUNT(DISTINCT basket_id) AS avg_bastket_size,

    COUNT(DISTINCT trn_basket_sen_la) AS basket_sen_la,
    COUNT(DISTINCT trn_basket_sen_mm) AS basket_sen_mm,
    COUNT(DISTINCT trn_basket_sen_um) AS basket_sen_um,
    COUNT(DISTINCT trn_basket_sen_xx) AS basket_sen_xx,

    COUNT(DISTINCT trn_customer_sen_la) AS customer_sen_la,
    COUNT(DISTINCT trn_customer_sen_mm) AS customer_sen_mm,
    COUNT(DISTINCT trn_customer_sen_up) AS customer_sen_up,
    COUNT(DISTINCT trn_customer_sen_xx) AS customer_sen_xx,

    COUNT(DISTINCT trn_basket_type_ss) AS basket_type_ss,
    COUNT(DISTINCT trn_basket_type_tu) AS basket_type_tu,
    COUNT(DISTINCT trn_basket_type_fs) AS basket_type_fs,
    COUNT(DISTINCT trn_basket_type_xx) AS basket_type_xx,

    COUNT(DISTINCT trn_basket_dominant_fr) AS basket_dominant_fr,
    COUNT(DISTINCT trn_basket_dominant_gr) AS basket_dominant_gr,
    COUNT(DISTINCT trn_basket_dominant_mi) AS basket_dominant_mi,
    COUNT(DISTINCT trn_basket_dominant_nf) AS basket_dominant_nf,
    COUNT(DISTINCT trn_basket_dominant_xx) AS basket_dominant_xx,
FROM (
		SELECT
        *,
        PARSE_DATE('%Y%m%d', CAST(shop_date AS STRING)) as convert_shop_date,
        DATE_ADD(MAX(PARSE_DATE('%Y%m%d', CAST(shop_date AS STRING))) OVER(), INTERVAL 1 DAY) AS max_shop_date,
        basket_price_sensitivity,
        IF(BASKET_PRICE_SENSITIVITY = 'LA', basket_id, NULL) AS trn_basket_sen_la,
        IF(BASKET_PRICE_SENSITIVITY = 'MM', basket_id, NULL) AS trn_basket_sen_mm,
        IF(BASKET_PRICE_SENSITIVITY = 'UM', basket_id, NULL) AS trn_basket_sen_um,
        IF(BASKET_PRICE_SENSITIVITY = 'XX', basket_id, NULL) AS trn_basket_sen_xx,
        CUST_PRICE_SENSITIVITY,
        IF(CUST_PRICE_SENSITIVITY = 'LA', basket_id, NULL) AS trn_customer_sen_la,
        IF(CUST_PRICE_SENSITIVITY = 'MM', basket_id, NULL) AS trn_customer_sen_mm,
        IF(CUST_PRICE_SENSITIVITY = 'UM', basket_id, NULL) AS trn_customer_sen_up,
        IF(CUST_PRICE_SENSITIVITY = 'XX', basket_id, NULL) AS trn_customer_sen_xx,
        basket_type,
        IF(basket_type = 'Small Shop', basket_id, NULL) AS trn_basket_type_ss,
        IF(basket_type = 'Top Up', basket_id, NULL) AS trn_basket_type_tu,
        IF(basket_type = 'Full Shop', basket_id, NULL) AS trn_basket_type_fs,
        IF(basket_type = 'XX', basket_id, NULL) AS trn_basket_type_xx,
        basket_dominant_mission,
        IF(basket_dominant_mission = 'Fresh',basket_id, NULL ) AS trn_basket_dominant_fr,
        IF(basket_dominant_mission = 'Grocery',basket_id, NULL ) AS trn_basket_dominant_gr,
        IF(basket_dominant_mission = 'Mixed',basket_id, NULL ) AS trn_basket_dominant_mi,
        IF(basket_dominant_mission = 'Non Food',basket_id, NULL ) AS trn_basket_dominant_nf,
        IF(basket_dominant_mission = 'XX',basket_id, NULL ) AS trn_basket_dominant_xx
    FROM `customer-segment.nidadataset.supermarket`
)
WHERE cust_code IS NOT NULL
GROUP BY
    cust_code