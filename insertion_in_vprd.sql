insert into v3_payment_requests_data 
( type,payment_request_amount ,payment_request_status ,source_account_id ,destination_account_id ,user_id ,
payment_request_id ,row_status ,payment_reference_id , created_at , updated_at ,intermediary_payment_date ,
payment_received_in_bank_date ,payment_request_mode ,payment_execution_charges ,payment_gateway_id ,gateway_response ,
collection_by ,collection_request_id ,payment_request_comments ,prepayment_amount ,net_payment_amount ,fee_amount ,
expire_date ,performed_by ,coupon_code ,coupon_data ,gross_request_amount ,extra_details 
) 

select 'reset_joining_fees',payment_request_amount ,payment_request_status ,source_account_id ,destination_account_id ,user_id ,
 concat('F',payment_request_id,'c') ,row_status ,payment_reference_id , Now() , Now() ,'2022-02-03' ,
'2022-05-05'  ,payment_request_mode ,payment_execution_charges ,payment_gateway_id ,gateway_response ,
'customer_refund ',collection_request_id ,'fee_refund' ,prepayment_amount ,net_payment_amount ,fee_amount ,
Now() ,null ,null ,coupon_data ,gross_request_amount ,extra_details 
 from v3_payment_requests_data WHERE payment_reference_id='order_IraxjN8GvXUQEo' and row_status='active'

 
select * from v3_payment_requests_data vprd WHERE payment_reference_id='order_ItWTOHMeioobUg'
 

-- select * from v3_payment_requests_data vprd  where payment_request_id='43qbaE53m8A0'
 
 insert into v3_payment_requests (payment_request_id,created_at,updated_at,performed_by)
 (select concat('F',payment_request_id,'c'),now(),now(),null  from v3_payment_requests_data
 where payment_reference_id='order_IraxjN8GvXUQEo' and row_status='active')





-- 
insert into v3_payment_requests_data 
( type,payment_request_amount ,payment_request_status ,source_account_id ,destination_account_id ,user_id ,
payment_request_id ,row_status ,payment_reference_id , created_at , updated_at ,intermediary_payment_date ,
payment_received_in_bank_date ,payment_request_mode ,payment_execution_charges ,payment_gateway_id ,gateway_response ,
collection_by ,collection_request_id ,payment_request_comments ,prepayment_amount ,net_payment_amount ,fee_amount ,
expire_date ,performed_by ,coupon_code ,coupon_data ,gross_request_amount ,extra_details 
) 

select 'processing_fee',3818.48 ,payment_request_status ,source_account_id ,destination_account_id ,user_id ,
 concat('F',payment_request_id,'c') ,row_status ,payment_reference_id , Now() , Now() ,intermediary_payment_date ,
payment_received_in_bank_date ,payment_request_mode ,0 ,payment_gateway_id ,gateway_response ,
'customer',collection_request_id ,null ,prepayment_amount ,net_payment_amount ,fee_amount ,
Now() ,null ,null ,coupon_data ,3818.48 ,extra_details 
 from v3_payment_requests_data WHERE payment_request_id='BbRX82nYmpo0' and row_status='active'
