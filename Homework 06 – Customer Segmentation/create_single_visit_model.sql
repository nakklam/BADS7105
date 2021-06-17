CREATE OR REPLACE MODEL `customer-segment.nidadataset.Single_Visit_Model`
OPTIONS(model_type='kmeans', num_clusters=4, 
        kmeans_init_method='kmeans++', max_iterations=50)
AS (
    SELECT 
    recency,
    weekly_frequency,
    weekly_monetory,
    avg_bastket_size,

    basket_sen_la,
    basket_sen_mm,
    basket_sen_um,
    basket_sen_xx,

    customer_sen_la,
    customer_sen_mm,
    customer_sen_up,
    customer_sen_xx,

    basket_type_ss,
    basket_type_tu,
    basket_type_fs,
    basket_type_xx,

    basket_dominant_fr,
    basket_dominant_gr,
    basket_dominant_mi,
    basket_dominant_nf,
    basket_dominant_xx,
    FROM `customer-segment.nidadataset.Customer_Single_View`
    WHERE total_visit = 1
);