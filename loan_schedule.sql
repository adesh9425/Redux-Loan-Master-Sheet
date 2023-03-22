--  loan schedual
         

(

 select  ls.loan_id ,ls.emi_number ,ls.dpd ,ls.due_date,ls.last_payment_date,ls.payment_status  ,ls.principal_due ,ls.interest_due,
 ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )
 as principal_paid,( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end ) as interest_paid,
 ls.payment_received , 
ls.principal_due +ls.interest_due -ls.payment_received as payment_left,
 ls.total_closing_balance as total_open_balance,ls.total_closing_balance-( case when (ls.principal_due -ls.payment_received) >0 then
 ls.payment_received else  ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )  end )  as total_closing_balance
 from v3_loans vl join loan_schedule ls on vl.id=ls.loan_id   
 where vl.lender_id =1756833 and ls.bill_id is  null 

  order by ls.loan_id,ls.emi_number
  )
  union all
(
select vled.loan_id,vled.emi_number ,vl.dpd,vled.due_date ,vled.payment_date as last_payment_date  ,vled.payment_status ,vled.principal_payment_schedule as pricple_due ,
vled.cumulative_interest_accrued  as interest_due,
vled.payment_amount  -( case when (vled.cumulative_interest_accrued-vled.payment_amount) >0 then vled.payment_amount else vled.cumulative_interest_accrued  end )
 as principal_paid,
( case when (vled.cumulative_interest_accrued-vled.payment_amount) >0 then vled.payment_amount else vled.cumulative_interest_accrued end ) as interest_paid,
vled.payment_amount ,
vled.principal_payment_schedule  +vled.cumulative_interest_accrued -vled.payment_amount as payment_left,
vled.principal_open_balance_schedule as total_open_balance, vled.principal_open_balance_schedule-vled.payment_amount  as total_closing_balance
from v3_loan_emis_data vled join v3_loans vl on vl.id=vled.loan_id 
where vl.product_type ='ruby' and vled.row_status ='active' order by vled.loan_id,vled.emi_number
)

