use Centegy_SnDPro_UET
go

Declare @seqid int = 591
Declare @DTcode varchar(10) = 'TEST001'

select 
	right(value, 20),
	* 
from memory_variable_Detail 
where SEQ_ID = @seqid
select 
	right(variable_value, 30), 
	* 
from memory_variable 
where seq_id=@seqid and variable_name = 'where_sum' and variable_value like '%'+@DTcode+'%'

update memory_variable_Detail 
	set Value = value+'~~'+@DTcode 
where not exists ( select 1 from memory_variable_Detail where SEQ_ID = @seqid and value like '%'+@DTcode+'%')
	and SEQ_ID=@seqid and ColumnName='Distributor'

update memory_variable 
	set variable_value=REPLACE( variable_value, ')) )', ','''+@DTcode+''')) )') 
where not exists (select 1 from  memory_variable where seq_id=@seqid and variable_name = 'where_sum' and variable_value like '%'+@DTcode+'%')
	and variable_name='where_sum' and seq_id=@seqid


