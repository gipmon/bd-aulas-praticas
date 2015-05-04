use AdventureWorks2012;

--10_1_1

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

Select * from Production.WorkOrder;

--10_1_2

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

select * from Production.WorkOrder where WorkOrderID=1234;

--10_1_3

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

select * from Production.WorkOrder
where WorkOrderID between 10000 and 10010

select * from Production.WorkOrder
where WorkOrderID between 1 and 72591

--10_1_4

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

select * from Production.WorkOrder
where StartDate='2003-06-25'

--10_1_5

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

select * from Production.WorkOrder 
where ProductID = 757

--10_1_6

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

drop index IX_WorkOrder_ProductID on Production.WorkOrder

create index IX_WorkOrder_ProductIDCovering on Production.WorkOrder (ProductID)
include (StartDate)

select WorkOrderID, StartDate from Production.WorkOrder
where ProductID=757

select WorkOrderID, StartDate from Production.WorkOrder
where ProductID=945

select WorkOrderID, StartDate from Production.WorkOrder
where ProductID=945 and StartDate='2002-01-04'

--10_1_7

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

drop index IX_WorkOrder_ProductIDCovering on Production.WorkOrder

create index IX_WorkOrder_ProductID on Production.WorkOrder (ProductID)
create index IX_WorkOrder_StartDate on Production.WorkOrder (StartDate)

select WorkOrderID, StartDate From Production.WorkOrder
where ProductID=945 and StartDate = '2002-01-04'

--10_1_8

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

drop index IX_WorkOrder_ProductIDCovering on Production.WorkOrder

create index IX_WorkOrder_ProductIDStartDate on Production.WorkOrder(ProductID, StartDate)

select WorkOrderID, StartDate From Production.WorkOrder
where ProductID=945 and StartDate = '2002-01-04'

