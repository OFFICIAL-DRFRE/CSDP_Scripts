use centegy_sndpro_uet
select distinct 
	d.distributor,d.name,s.ldesc Channel, 
	count(p.town+p.distributor+P.locality+P.slocality+P.pop) over(partition by p.distributor, p.sub_element) as  'total by channel'
from pop p 
inner join sub_element s on s.sub_element=p.SUB_ELEMENT 
inner join DISTRIBUTOR d on d.COMPANY=p.COMPANY and d.DISTRIBUTOR=p.DISTRIBUTOR
where ACTIVE=1 and p.DISTRIBUTOR in ( select distributor from CASHMEMO where DOC_DATE between '20230801' and '20230930' )
order by 2, 3
