SELECT * FROM portfolia.nasville;
#Standardize Data Format
Alter table portfolia.nashville
add saleconvertdate date;

set sql_safe_updates=0;
update portfolia.nashville
set saleconvertdate = str_to_date(saledate,'%M %d ,%Y');

select *,saleconvertdate from portfolia.nashville;

#populate address property data

select c.propertyaddress,d.propertyaddress,c.parcelid,d.parcelid,ifnull(c.propertyaddress,d.propertyaddress)
from portfolia.nashville c 
join portfolia.nashville d
on c.parcelid=d.parcelid and c.uniqueid<>d.uniqueid
where (c.propertyaddress is null or trim(c.propertyaddress) ="" )
and (d.propertyaddress is not  null and trim(d.propertyaddress)<>"");

create index idx_parcel on portfolia.nashville(parcelid(50));
set sql_safe_updates=0;
update portfolia.nashville c
join portfolia.nashville d
on c.parcelid = d.parcelid
and c.uniqueid <> d.uniqueid
set c.propertyaddress = d.propertyaddress
where (c.propertyaddress is null or TRIM(c.propertyaddress) = '')
and (d.propertyaddress is not null or TRIM(d.propertyaddress) <> '');

select * from portfolia.nashville;

#Breaking address into individual columns(Address, city, state)
select propertyaddress 
from portfolia.nashville;

select
substring(propertyaddress,1,locate(',',propertyaddress)-1) as address,
substring(propertyaddress,locate(',',propertyaddress)+1,length(propertyaddress)) as address
from portfolia.nashville;

alter table portfolia.nashville
add propertyaddresssplit varchar(255);
set sql_safe_updates=0;
update portfolia.nashville 
set propertyaddresssplit=substring(propertyaddress,1,locate(',',propertyaddress)-1) ;

alter table portfolia.nashville
add propertyaddresscity varchar(255);
set sql_safe_updates=0;
update portfolia.nashville
set propertyaddresscity=substring(propertyaddress,locate(',',propertyaddress)+1,length(propertyaddress));

select * from portfolia.nashville;


select substring_index(owneraddress,',',1) as address,
trim(substring_index(substring_index(owneraddress,',',2),',',-1)) as city,
trim(substring_index(owneraddress,',',-1)) as state
from portfolia.nashville;

alter table portfolia.nashville
add owneraddresss varchar(300);
set sql_safe_updates=0;
update portfolia.nashville
set owneraddresss=substring_index(owneraddress,',',1);

alter table portfolia.nashville
add ownercity varchar(300);
set sql_safe_updates=0;
update portfolia.nashville
set ownercity=trim(substring_index(substring_index(owneraddress,',',2),',',-1));

alter table portfolia.nashville
add ownerstate varchar(300);
set sql_safe_updates=0;
update portfolia.nashville
set ownerstate=trim(substring_index(owneraddress,',',-1));

select* from portfolia.nashville;

select distinct(soldasvacant),count(SoldAsVacant)
from portfolia.nashville
group by SoldAsVacant
order by 2;

select soldasvacant,
case when soldasvacant = "y" then "yes"
	 when soldasvacant ="n" then "no"
     else soldasvacant
end
from portfolia.nashville;

update portfolia.nashville
set soldasvacant=
case when soldasvacant = "y" then "yes"
	 when soldasvacant ="n" then "no"
     else soldasvacant
end;


#Remove Duplicates
delete from portfolia.nashville
where UniqueID in(
select uniqueid from(
select UniqueID,row_number() over(partition by propertyaddress,
								               parcelid,
                                               saledate,
                                               saleprice,
                                               LegalReference
                                   ) as row_num
from portfolia.nashville
)t
where row_num>1
);


#Delete unsued columns
select * from portfolia.nashville;

alter table portfolia.nashville
drop column acreage,
drop column ownername;
											   


                              
     















