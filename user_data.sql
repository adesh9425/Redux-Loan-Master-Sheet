
# The code gives the user details of all the users.

(select  vl.product_type ,vl.sub_product_type ,vud.user_id ,vud.first_name ,vui."identity" as Phone,vud.email
 ,vud.date_of_birth ,vud.gender 
from ( select user_id,loan_id from loan_data_new ldn group by 1,2) ldn join v3_loans vl on vl.id=ldn.loan_id 
 join v3_user_identities vui on vl.user_id =vui.user_id join v3_user_data vud  on vl.user_id =vud.user_id 
 where  vud.row_status ='active' and vui.row_status ='active' 
and vl.lender_id =1756833 order by vl.user_id
)  
union 
(
 select  vl.product_type ,vl.sub_product_type ,vud.user_id ,vud.first_name ,vui."identity" as Phone,vud.email
 ,vud.date_of_birth ,vud.gender 
from v3_loans vl join v3_user_data vud  on vl.user_id =vud.user_id  join v3_user_identities vui on vl.user_id =vui.user_id  
join v3_loan_data vld on vld.loan_id=vl.id where  vud.row_status ='active' and vui.row_status ='active' 
 and vld.lender_id =1756833 and vld. loan_type='drawdown'  and vld.row_status ='active'  order by vl.user_id
)
