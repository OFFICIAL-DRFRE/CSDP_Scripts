use centegy_sndpro_uet
go

select 
	p1.prod1 category_code, p1.ldesc category, 
	p2.prod3 sub_category_code, p2.ldesc 'Sub Category',
	p3.PROD5 Brand_code, p3.LDESC 'Brand',
	s.SKU, isNull(s.LDESC, s.sdesc) 'SKU description'
from SKU s 
inner join PROD_LEVEL1 p1 on p1.PROD1=s.PROD1
inner join PROD_LEVEL3 p2 on p2.PROD1=s.PROD1 and p2.PROD2=s.PROD2 and p2.PROD3=s.PROD3
inner join PROD_LEVEL5 p3 on p3.PROD1=s.PROD1 and p3.PROD2 =s.PROD2 and p3.prod3=s.PROD3 and p3.PROD4=s.PROD4 and p3.PROD5=s.PROD5
