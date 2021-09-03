/*
Change log - Write here your changes in for form of:
tab - class - change you did
-*-*-*- Routines -*-*-*-
CreateProcessRoutine - the whole file
AdmitProcessRoutine - the whole file
DeleteProcessRoutine - the whole file
MemoryManagerRoutine - the whole file
SOS - added global variables for routines, kernel put and get commands, loaded routines.
-*-*-*- Statistics -*-*-*-
SOS - added statistics variables in the step method and as global variables.
CWSim - added a PrintWriter, processCounter variable, writer calls and functions in the 'X' button.
SOS - added start and stop variables for each statistic, added calls for printing in the writer.
-*-*-*- Variable Partitions -*-*-*-
SOS - changed the partition table into an ArrayList, fixed all instances of array functions to work for ArrayLists.
SOS - constructed the partitionTable in the constructor differently as well as its size.
AdmitProcessRoutine - fixed all instances of array functions to work for ArrayLists.
DeleteProcessRoutine - fixed all instances of array functions to work for ArrayLists.
CreateProcessRoutine - fixed all instances of array functions to work for ArrayLists.
MemoryManagerRoutine - fixed all instances of array functions to work for ArrayLists.
MemoryManagerRoutine - added splitting of partitions in appropriate sized parts for variable partitions block of code.
SOS - memory manager start, partitions, routine check,
-*-*-*- First Fit Memory Manager, Coalescing and Compacting -*-*-*-
DeleteProcessRoutine - added the coalescing block of code
MemoryManagerRoutine - added the compacting and special coalescing blocks of code
-*-*-*- Round Robin Scheduler -*-*-*-
OSSchedulers - added the RR class which is a modified versions of the FCFS scheduler class
SOS - loaded the RR scheduler instead of FCFS
SOS - modified the step method to do multiple checks according to determine if the RR scheduler has to perform an RR interrupt.
-*-*-*- Experiments -*-*-*-
CWSim - enabled user requests
-*-*-*- Known Bugs -*-*-*-
If the processes to be entered are greater than the amount of space in RAM, the program freezes at the memory manager.
*/
