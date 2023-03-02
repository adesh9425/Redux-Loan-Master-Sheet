
-- dpd

with ls_n as(
 select  id,ls.loan_id ,ls.emi_number ,ls.dpd ,ls.due_date,ls.last_payment_date,ls.payment_status  ,ls.principal_due ,ls.interest_due,
 ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )
 as principal_paid,( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end ) as interest_paid,
 (case when ls.payment_received>0 then ls.payment_received else null end  ) payment_received , 
ls.principal_due +ls.interest_due -ls.payment_received as payment_left,
 ls.total_closing_balance as total_open_balance,ls.total_closing_balance-( case when (ls.principal_due -ls.payment_received) >0 then
 ls.payment_received else  ls.payment_received -( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end )  end )  as total_closing_balance
 from loan_schedule ls 
 where    ls.bill_id is  null 
),
 lsd as (
select distinct max(id) filter(where payment_received is not null)over(partition by loan_id) as id, loan_id,sum (principal_due) over(partition by loan_id) as Total_principal_due,
sum(principal_paid) over(partition by loan_id) as Total_principal_paid ,
sum(interest_paid) over(partition by loan_id) as Total_interest_paid,max(last_payment_date) over(partition by loan_id) as last_payment_date ,
max(due_date) filter(where last_payment_date is not null) over(partition by loan_id) as due_date,
sum(payment_left) over(partition by loan_id) as loan_balance,
sum(payment_received) over (partition by loan_id) as payment_received,
sum(interest_due) filter(where payment_received is null and due_date <=now()::date ) over(partition by loan_id) as interset_due,
max(emi_number) filter(where last_payment_date is not null) over(partition by loan_id) as last_paid_emi
from  ls_n 
), 
lsd2 as (
select distinct  min(id) filter(where emi_number=1) over(partition by loan_id) as id , loan_id,sum (principal_due) over(partition by loan_id) as Total_principal_due,
sum(principal_paid) over(partition by loan_id) as Total_principal_paid ,
sum(interest_paid) over(partition by loan_id) as Total_interest_paid ,
min(due_date) filter(where emi_number=1) over(partition by loan_id) as due_date ,
sum(payment_received) over (partition by loan_id) as payment_received,
min(last_payment_date) filter(where emi_number=1) over(partition by loan_id) as last_payment_date,
sum(payment_left) over(partition by loan_id) as loan_balance,
sum(interest_due) filter(where last_payment_date is null and  due_date <=now()::date ) over(partition by loan_id) as interset_due
from  ls_n 

)


(select   Now()::date,vl.product_type ,lsd.loan_id,vl.loan_status ,vl.dpd ,lsd.due_date ,lsd.last_payment_date as last_payment_date,
 lsd.Total_principal_due,lsd.Total_principal_paid,lsd.Total_interest_paid,lsd.payment_received,
 ls.total_closing_balance-ls.payment_received +( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end ) 
 as Principal_Balance_Unpaid_Schedule
 ,lsd.interset_due
  , (case  when fe.unpaid_fee is null then 0 else fe.unpaid_fee end ) as unpaid_fee ,lsd.loan_balance,
  last_paid_emi
  from  loan_schedule ls
  join lsd on lsd.id=ls.id
    join v3_loans vl  on vl.id=ls.loan_id 
  
left join (select user_id,sum(gross_amount) as unpaid_fee from fee where fee_status='UNPAID' group by user_id  ) fe on vl.user_id =fe.user_id
    where vl.lender_id =1756833  and ls.bill_id is null   order by lsd.loan_id
  ) 
    
    
union 
(
select   Now()::date,vl.product_type ,lsd2.loan_id,vl.loan_status ,vl.dpd ,lsd2.due_date ,lsd2.last_payment_date as last_payment_date,
 lsd2.Total_principal_due,lsd2.Total_principal_paid,lsd2.Total_interest_paid,lsd2.payment_received,
 ls.total_closing_balance-ls.payment_received +( case when (ls.interest_due-ls.payment_received) >0 then ls.payment_received else ls.interest_due  end ) 
 as Principal_Balance_Unpaid_Schedule
 ,lsd2.interset_due,
  (case  when fe.unpaid_fee is null then 0 else fe.unpaid_fee end ) as unpaid_fee ,lsd2.loan_balance,null as last_paid_emi
  from  loan_schedule ls
  join lsd2 on lsd2.id=ls.id
    join v3_loans vl  on vl.id=ls.loan_id 

  
left join (select user_id,sum(gross_amount) as unpaid_fee from fee where fee_status='UNPAID' group by user_id  ) fe on vl.user_id =fe.user_id
    where vl.lender_id =1756833  and ls.bill_id is null and ls.last_payment_date is null and ls.emi_number=1 
    order by lsd2.loan_id
  )

