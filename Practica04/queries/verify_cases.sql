USE db_test;
SELECT o.ID,o.buyer_ID,o.seller_ID,o.subtotal,o.fulfillment_status,
       COUNT(DISTINCT i.product_ID) AS productos
FROM tb_buyer_orders o LEFT JOIN tbd_order_items i ON i.seller_order_ID=o.ID
WHERE o.ID IN (2,3,5,6,7)
GROUP BY o.ID,o.buyer_ID,o.seller_ID,o.subtotal,o.fulfillment_status
ORDER BY o.ID;

SELECT p.order_ID,p.payment_method,p.payment_status,p.amount,t.event_type,t.remarks
FROM tb_payments p LEFT JOIN tb_payment_transactions t ON t.payment_ID=p.ID
WHERE p.order_ID IN (2,3,5,6,7)
ORDER BY p.order_ID,p.ID,t.ID;

SELECT buyer_order_ID,shipment_status,tracking_number FROM tb_shipments
WHERE buyer_order_ID IN (2,3,5,6,7) ORDER BY buyer_order_ID,ID;

SELECT c.buyer_order_ID,c.cancellation_reason,c.cancellation_status,r.amount,r.refund_status
FROM tb_cancellations c LEFT JOIN tb_refunds r ON r.cancellation_ID=c.ID
WHERE c.buyer_order_ID IN (5,7);

SELECT buyer_order_ID,quantity,return_reason,return_status FROM tb_returns WHERE buyer_order_ID=3;
SELECT order_ID,payment_status FROM tb_payment_methods WHERE payment_reference='C5-oficial-01';

SELECT operation_date,db_user,table_name,operation,description
FROM tb_logs WHERE db_user LIKE 'AppWeb@%'
AND table_name IN ('tb_buyer_orders','tb_shipments','tb_payment_transactions','tb_returns','tb_refunds','tb_cancellations')
ORDER BY id DESC LIMIT 100;
