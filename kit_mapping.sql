
-- Kit mapping query v3_loan_data

with users_kit_time as (
(select user_id ,kit_number ,min(created_at) as created_at ,max(updated_at) as updated_at  from v3_user_cards vuc 
 group by 1,2 )
union 
(select vuc.user_id ,kit_number ,updated_at  as created_at, now() as updated_at  from v3_user_cards vuc join 
(select user_id ,max(created_at)  as created_at  from v3_user_cards vuc group by 1 ) kk on kk.user_id=vuc.user_id and vuc.created_at =kk.created_at 
)
),

ldn as (
select user_id,loan_id from loan_data_new ldn where lender_id=1756833 group by 1,2
)
,
 user_kit_map as(
select vld.user_id,vckn.kit_number ,date_trunc('month',agreement_date) as dt,sum(product_price) as card_spend,count(*) as txn_cnt
from v3_loan_data   vld  join users_kit_time ukt on ukt.user_id=vld.user_id join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',agreement_date)  >= date_trunc('month', ukt.created_at) and date_trunc('day',agreement_date) <date_trunc('month',  ukt.updated_at)
where vld.row_status ='active' and vld.lender_id =1756833 and vld.product_status ='Confirmed'
and vld.loan_type ='Card Txn' group by 1,2,3 order by 3,2,1),

user_kit_map2 as(
select vl.user_id, vckn.kit_number ,date_trunc('month',txn_time) as dt,sum(amount) as card_spend,count(*) as txn_cnt
from card_transaction ct  join loan_data ld on ld.id=ct.loan_id  join v3_loans vl on vl.id=ld.loan_id   
join users_kit_time ukt on ukt.user_id=vl.user_id
join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',txn_time)  >= date_trunc('month', ukt.created_at) and date_trunc('day',txn_time) <date_trunc('month',  ukt.updated_at)

where ct.status ='CONFIRMED' and vl.lender_id =1756833
 group by 1,2,3 order by 3,2,1
),

alpha as ((select ukm.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map ukm join v3_card_kit_numbers vckn 
on ukm.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,4)
union 
(select ukm2.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map2 ukm2 join v3_card_kit_numbers vckn 
on ukm2.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,4)
)

select provider,	card_name,	status,	user_id,	kit_number,	dt	,card_spend	,txn_cnt
from alpha order by 1,2,7,4,5 


select * from v3_loan_data vld 


-- Kit mapping query  2

with users_kit_time as (
(select vuc.user_id  ,kit_number ,min(created_at) as created_at ,max(updated_at) as updated_at  from v3_user_cards vuc 
 group by 1,2 )
union 
(select vuc.user_id ,kit_number ,updated_at  as created_at, now() as updated_at  from v3_user_cards vuc join 
(select user_id,max(created_at)  as created_at  from v3_user_cards vuc  group by 1 ) kk 
on kk.user_id=vuc.user_id
and vuc.created_at =kk.created_at 
)
),
 user_kit_map as(
select vld.user_id ,vckn.kit_number ,date_trunc('month',agreement_date) as dt,sum(product_price) as card_spend,count(*) as txn_cnt
from v3_loan_data   vld join users_kit_time ukt on ukt.user_id=vld.user_id join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',agreement_date)  >= date_trunc('month', ukt.created_at) and date_trunc('day',agreement_date) <date_trunc('month',  ukt.updated_at)
where vld.row_status ='active' and vld.lender_id =1756833
and vld.loan_type ='Card Txn' group by 1,3,2 order by 3,2,1),

user_kit_map2 as(
select vl.user_id , vckn.kit_number ,date_trunc('month',post_date) as dt,
sum(CASE WHEN name = 'card_transaction' THEN amount )   as card_spend,
count(*) as txn_cnt
from ledger_trigger_event lte join(select user_id,loan_id from loan_data_new ldn where lender_id =1756833 group by 1,2)  ldn
on ldn.loan_id =lte.loan_id  join users_kit_time ukt on ukt.user_id=ldn.user_id
join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',post_date)  >= date_trunc('month', ukt.created_at) and date_trunc('day',post_date) <date_trunc('month',  ukt.updated_at)
 where lte.name in ('card_transaction','transaction_refund')
group by 1,3,2 order by 3,2,1
),

alpha as ((select ukm.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map ukm join v3_card_kit_numbers vckn 
on ukm.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,3)
union 
(select ukm2.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map2 ukm2 join v3_card_kit_numbers vckn 
on ukm2.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,3)
)


select provider,card_name,status,user_id,loan_id,kit_number,dt,	card_spend	,txn_cnt
from alpha where user_id=1721139 order by 1,2,7,4,5

--  daily bais 


-- Kit mapping query v3_loan_data

with users_kit_time as (
(select user_id ,kit_number ,min(created_at) as created_at ,max(updated_at) as updated_at  from v3_user_cards vuc 
 group by 1,2 )
union 
(select vuc.user_id ,kit_number ,updated_at  as created_at, now() as updated_at  from v3_user_cards vuc join 
(select user_id ,max(created_at)  as created_at  from v3_user_cards vuc group by 1 ) kk on kk.user_id=vuc.user_id and vuc.created_at =kk.created_at 
)
),

ldn as (
select user_id,loan_id from loan_data_new ldn where lender_id=1756833 group by 1,2
)
,
 user_kit_map as(
select vld.user_id,vckn.kit_number ,date_trunc('day',agreement_date) as dt,sum(product_price) as card_spend,count(*) as txn_cnt
from v3_loan_data   vld  join users_kit_time ukt on ukt.user_id=vld.user_id join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',agreement_date)  >= date_trunc('month', ukt.created_at) and date_trunc('day',agreement_date) <date_trunc('month',  ukt.updated_at)
where vld.row_status ='active' and vld.lender_id =1756833 and vld.product_status ='Confirmed'
and vld.loan_type ='Card Txn' group by 1,2,3 order by 3,2,1),

user_kit_map2 as(
select vl.user_id, vckn.kit_number ,date_trunc('day',txn_time) as dt,sum(amount) as card_spend,count(*) as txn_cnt
from card_transaction ct  join loan_data ld on ld.id=ct.loan_id  join v3_loans vl on vl.id=ld.loan_id   
join users_kit_time ukt on ukt.user_id=vl.user_id
join v3_card_kit_numbers vckn 
on vckn.kit_number =ukt.kit_number and date_trunc('day',txn_time)  >= date_trunc('month', ukt.created_at) and date_trunc('day',txn_time) <date_trunc('month',  ukt.updated_at)

where ct.status ='CONFIRMED' and vl.lender_id =1756833
 group by 1,2,3 order by 3,2,1
),

alpha as ((select ukm.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map ukm join v3_card_kit_numbers vckn 
on ukm.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,4)
union 
(select ukm2.*,vckn.provider ,vckn.status,vcn."name" as card_name from user_kit_map2 ukm2 join v3_card_kit_numbers vckn 
on ukm2.kit_number=vckn.kit_number join v3_card_names vcn on vcn.id=vckn.card_name_id  order by 1,4)
)

select provider,	card_name,	status,user_id,	kit_number,	dt	,card_spend	,txn_cnt
from alpha order by 6,1,2,4

