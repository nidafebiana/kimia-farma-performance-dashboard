CREATE OR REPLACE TABLE `rakamin-kf-analytics-477115.kimia_farma.kf_analisa` AS
SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,

    -- Persentase Gross Laba Berdasarkan Harga
    CASE 
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,

    -- Nett Sales = Harga setelah diskon
    ROUND(t.price * (1 - t.discount_percentage), 2) AS nett_sales,

    -- Nett Profit = Nett Sales * Persentase Laba
    ROUND(
        (t.price * (1 - t.discount_percentage)) *
        CASE 
            WHEN t.price <= 50000 THEN 0.10
            WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
            WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
            WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
            WHEN t.price > 500000 THEN 0.30
        END
    , 2) AS nett_profit,

    t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-477115.kimia_farma.kf_final_transaction` AS t
LEFT JOIN `rakamin-kf-analytics-477115.kimia_farma.kf_product` AS p
    ON t.product_id = p.product_id
LEFT JOIN `rakamin-kf-analytics-477115.kimia_farma.kf_kantor_cabang` AS c
    ON t.branch_id = c.branch_id;
