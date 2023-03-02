--  loan schedual
         
 (select  ls.loan_id ,ls.emi_number ,ls.dpd ,ls.due_date,ls.last_payment_date,ls.payment_status  ,ls.principal_due ,ls.interest_due,
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
  union 
  (
  select vled.loan_id ,vled.emi_number ,vled.dpd ,vled.due_date,ls.payment_date,vled.payment_status  ,ls.principal_due ,ls.interest_due,
 ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )
 as principal_paid,( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end ) as interest_paid,
 ls.payment_received , 
ls.principal_due +ls.interest_due -ls.payment_received as payment_left,
 ls.total_closing_balance as total_open_balance,ls.total_closing_balance-( case when (ls.principal_due -ls.payment_received) >0 then
 ls.payment_received else  ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )  end )  as total_closing_balance
  
  from v3_loan_emis_data vled join v3_loans vl on vl.id=vled.loan_id 
  where loan_id=4812002 and vled.row_status ='active'
  )
  
