CREATE TABLE KimiaFarma.analisis AS
WITH temp AS(
SELECT 
  tr.transaction_id,
  tr.date,
  tr.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  tr.customer_name,
  tr.product_id,
  pr.product_name,
  pr.price as actual_price,
  tr.discount_percentage,
  CASE 
    WHEN pr.price <= 50000 THEN 0.10
    WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
    WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
    WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
    ELSE 0.30
  END as persentase_gross_laba,
  pr.price-(pr.price*tr.discount_percentage) as net_sales,
  tr.rating as rating_transaksi
FROM `kimiafarmapbi.KimiaFarma.kf_final_transaction` as tr
LEFT JOIN `kimiafarmapbi.KimiaFarma.kf_kantor_cabang` as kc
ON tr.branch_id=kc.branch_id
LEFT JOIN `kimiafarmapbi.KimiaFarma.kf_product` as pr
ON tr.product_id=pr.product_id
-- LIMIT 10
)
SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  persentase_gross_laba,
  net_sales,
  net_sales - (actual_price * (1-persentase_gross_laba)) as net_profit,
  rating_transaksi
FROM
  temp


