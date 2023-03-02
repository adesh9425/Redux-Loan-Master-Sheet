
-- Loan Payument 


with cte as (
select vprd.payment_gateway_id  ,vprd.user_id ,vprd."type" ,vprd.payment_request_amount,
 (case when vprd.payment_execution_charges is not null then vprd.payment_request_amount  -vprd.payment_execution_charges else vprd.payment_request_amount end)  as net_product_price ,
 
 vprd.payment_request_status ,vprd.row_status,
 vprd.coupon_code ,vprd.gross_request_amount ,vprd.collection_request_id ,vprd.payment_request_id ,vprd.payment_reference_id ,vprd.created_at 
 ,vprd.collection_by ,vprd.payment_execution_charges ,vprd.payment_request_mode ,vprd.intermediary_payment_date ,
 vprd.payment_received_in_bank_date  ,vprd.payment_request_comments

from v3_payment_requests_data vprd join v3_payment_gateways vpg on vprd.payment_gateway_id =vpg.id
 where vpg.lender_id =1756833 and
vprd.row_status ='active'   and payment_request_status in ('Paid' ,'Refunded')  

 )
 
 select (case 
 			 when 	cte.row_status ='active' and cte.payment_request_comments ='fee_refund' then 'Refunded'
			  when  cte.row_status ='active' and cte.collection_request_id is null then 'fees'
			  when cte.row_status ='active' and cte.collection_request_id is not null then vl.product_type
			  end
 ) as product_type,vl.id as loan_id,cte.*, 
 to_char(cte.payment_received_in_bank_date,'YYYY-Mon-DD') as db_settlement_date,
 (case when left(cte.payment_request_mode,4)='NEFT' then 'payment'  
 		when cte.collection_by='customer_refund' then 'refund'
 		else 'payment' end) as payment_type,
 
 (case when cte.collection_by='merchant_refund' then 'card_float_sbm_federal' 
 		when cte.collection_by='customer_refund' and cte.payment_request_mode<>'Online' then 'disbursement'
 		 else 'collection' end) as bank_account
 
  from cte left JOIN (select * from v3_collection_order_mapping where row_status='active' ) vcom on cte.collection_request_id  =vcom.collection_request_id
 left join v3_loans vl on vl.id=vcom.batch_id where net_product_price<>0
 
select * from v3_payment_requests_data vprd where payment_reference_id ='order_HTxWDeOBlCUKst'

