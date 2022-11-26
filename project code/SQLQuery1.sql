select * from project.dbo.data1;

select * from project.dbo.data2;

-- number of rows into our dataset

select count(*) from project..data1
select count(*) from project..data2

-- dataset for jharkhand and bihar

select * from project..data1 where State in ('Jharkhand','Bihar')

--population of india

select sum(population) as population from project..data2

--avg growth

select state,avg(growth)*100 avg_growth from project..data1 group by State;

--avg sex ratio

select state,round(avg(Sex_Ratio),0) avg_sex_ratio from project..data1 group by State order by avg_sex_ratio desc;

--avg literacy rate 


select state,round(avg(literacy),0) avg_literacy_ratio from project..data1
group by State having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest growth ratio


select top 3 state,avg(growth)*100 avg_growth from project..data1 group by State order by avg_growth desc;


-- bottom 3 state showing lowest sex ratio

select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by State order by avg_sex_ratio asc;

-- top and bottom 3 states in literacy state

drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
topstates float

)

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1
group by state order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstates desc;




drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
bottomstates float

)

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstates asc;

-- union operator

select * from (
select top 3 * from #topstates order by #topstates.topstates desc)a

union


select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstates asc)b;

--states starting with letter a and b

select distinct state from project..data1 where lower(state) like 'a%' or lower(state) like 'b%'

-- joining both table 

select a.district,a.state,a.Sex_Ratio,b.population from project..data1 a inner join project..data2 b on a.district = b.district

-- total males and females

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district) c) d
group by d.state;




