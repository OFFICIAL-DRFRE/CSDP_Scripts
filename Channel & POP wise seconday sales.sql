use Centegy_SnDPro_UET
go

Declare @datefr date ='01-Jan-2021'
Declare @dateto date ='31-Jul-2023'

select 
	T.ldesc Territory, 
	year(c.doc_date) 'Year', 
	Month(c.DOC_DATE)'Month',
	S.LDESC 'SKU Name' ,
	SE.LDESC 'Channel Type',
	pt.ldesc 'POP Type',
	count( distinct cm.distributor+cm.town+cm.locality+cm.slocality+cm.pop) 'Unique POP count',
	sum(c.AMOUNT*1.15) GSV,
	isNull(sum(sdd.discount+sdd.GST),0) discount,
	Cast(sum( ((C.QTY1*s.sell_factor1)+(QTY2*s.sell_factor2)+(QTY3*s.sell_factor3))) as int) 'Sales - pcs',
	sum( ((C.QTY1*s.sell_factor1)+(QTY2*s.sell_factor2)+(QTY3*s.sell_factor3)) ) / s.SELL_FACTOR1 'Sales - Cs',
	sum( ((C.QTY1*s.sell_factor1)+(QTY2*s.sell_factor2)+(QTY3*s.sell_factor3)))/1000000.0 * s.SELL_WEIGHT3 'Sales - Tons'
from CASHMEMO_DETAIL c
	inner join sku s on s.sku = c.sku
	inner join CASHMEMO cm on cm.DISTRIBUTOR=c.DISTRIBUTOR and cm.DOC_NO=c.DOC_NO
	inner join pop p on p.DISTRIBUTOR+p.town+p.locality+p.slocality+p.pop = cm.distributor+cm.TOWN+cm.LOCALITY+cm.SLOCALITY+cm.pop
	left join SCHEME_DISCOUNT_DETAIL sdd on sdd.sku=c.SKU and sdd.DOC_NO=c.DOC_NO and sdd.DISTRIBUTOR=c.DISTRIBUTOR
	inner join SUB_ELEMENT SE on p.SUB_ELEMENT=SE.SUB_ELEMENT and p.COMPANY=se.COMPANY
	inner join distributor d on d.distributor=c.distributor
	inner join town t on t.town =d.TOWN
	inner join POP_TYPE pt on pt.POPTYPE=p.POPTYPE
where 
	cm.sub_document in ('01','02','03','04') and cm.document ='CM'  and c.DOC_DATE between @datefr and @dateto
group by T.ldesc, year(c.DOC_DATE), Month(c.DOC_DATE),s.LDESC, SE.LDESC, s.SELL_FACTOR1, s.SELL_WEIGHT3,pt.ldesc 
order by year,Month, t.ldesc
