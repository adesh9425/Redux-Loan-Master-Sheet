


with ldn as (
select * from (
select product_type,user_id,loan_id,bill_dt, sum( case when gross_principal is not null  then gross_principal else 0 end) over(partition by loan_id,bill_id order by bill_dt ) as gross_principal ,
sum( case when principal is not null  then principal else 0 end) over(partition by loan_id,bill_id order by bill_dt ) as principal,
sum(case when refund_sum is not null then refund_sum else 0 end) over(partition by loan_id,bill_id order by bill_dt ) as refund_sum  ,
sum(case when prepayment is not null then prepayment else 0 end) over(partition by loan_id,bill_id order by bill_dt) as prepayment ,
sum(case when txn_amt is not null then txn_amt else 0 end) over(partition by loan_id,bill_id  ) as card_txn ,
rank() over(partition by loan_id,bill_id order by bill_dt) as rnk
from loan_data_new ldn 

) ldn where rnk=1

)

select vl.product_type  ,vl.sub_product_type as loan_type,vl.loan_status,vl.lender_id  , vl.user_id ,vl.id, ldn.card_txn,
        vl.tenure_in_months as EMI_option,(ldn.principal*vl.downpayment_percent)/100 as downpayment , ldn.principal ,ldn.gross_principal ,ldn.refund_sum,
        lmv2.min_balance as Min_Value_for_drawdown,
        lmv.max_balance as Max_value_for_drawdown,
        vl.rc_rate_of_interest_monthly as  Rate_of_interest, vl.interest_type ,vl.amortization_date as loan_date
from ( select ldn.loan_id,sum(card_txn) as card_txn,sum(ldn.principal) as principal,sum(gross_principal)as gross_principal,sum(refund_sum) as refund_sum,
sum(prepayment) as prepayment 
from  ldn group by ldn.loan_id ) ldn  join v3_loans vl on ldn.loan_id =vl.id 
join loan_max_view lmv on lmv.loan_id =vl.id 
left join loan_min_view lmv2 on lmv2.loan_id =vl.id
where vl.lender_id =1756833      order by vl.id



--ruby 
select vl.product_type  ,vl.sub_product_type as loan_type,vld.loan_type ,vld.rc_loan_status,vld.lender_id  , vl.user_id ,vl.id as loan_id , 
        vld.emi_plan  as EMI_option,vld.down_payment  as downpayment , vld.net_product_price  ,vld.product_price as gross_principal ,vld.rc_refund_amount ,
        vld.min_amount_for_drawdown  as Min_Value_for_drawdown,
        vld.closing_amount_for_drawdown  as Max_value_for_drawdown,
        vld.interest_rate /12 as  Rate_of_interest, vl.interest_type ,vld.agreement_date  as loan_date
from v3_loan_data vld join v3_loans vl on vl.id=vld.loan_id 
where vld.lender_id =1756833 and loan_type='drawdown' and vld.row_status ='active' 
--  subvention_amount

select  view_tags->'Tenure Details'->>'subvention_amount' as subvention_amount  ,* from v3_user_data vud join v3_loans vl on vl.user_id =vud.user_id 
where  vl.lender_id=1756833
and row_status ='active' 
and vl.amortization_date is not null and view_tags->'Tenure Details'->>'subvention_amount' is not null
order by vl.user_id ;
