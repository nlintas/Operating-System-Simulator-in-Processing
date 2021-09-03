Detailed Description:
    The simulation shows the interactions between hardware and an operating system at an abstract level.

    An operating system can be effectively simulated using the appropriate programs and while applying the expected theories. The classes provided have been examined and the following deductions have been made. The Hardware class is a very basic way of representation of a CPU and primary, as well as, secondary memory. The OSIdle class is a routine that represents idle Operating System usage. The OS scheduler is a routine using the First Come First Served (FCFS) algorithm. Partition is a class that can construct partitions and hold their information. Additionally, Process Info holds information about processes/programs. Request is used for testing purposes to automatically insert a program at a given time. The Routine class represents what a routine should behave. The Simple Operating System class contains all software utilized by an OS like loading programs and routines, running the memory manager, process insertion and deletion but also stores valuable information like addresses, requests, the kernel and the status of interrupts. Finally, the CW Simulator class is responsible for running, drawing and providing interactivity for the simulation. It should be noted that just like a real operating system it has been made in order to work coherently as a kernel with its components, routines, hardware and programs. In order, the following concepts are going to be examined: adding routines, statistics, First Fit Memory Manager and variable partitions, Round Robin scheduler and some experiments with observations.
    
    * Programming Language *
    The Processing language is a extremely similar to Java but integrates physics engine, 2d and 3d capabilities.

    * Source Code Versioning *
    1) FCFS - First Come First Served Scheduler
    2) RR - Round Robin Scheduler

Aims:
    • Describe the basic concepts of operating systems
    • Be familiar with the theory behind the design of basic concepts
    • Comprehend key issues in the practical implementation of operating systems
    • Realise the concepts of multi-tasking and time-sharing
    • Perform systems programming (processes) related tasks
    • Solve OS design problems
    • Be able to evaluate and select appropriate algorithms and data structures
    • Enhance students programming skills

How to run:
    - Open the main folder in the Physics Processing IDE and click the run green arrow button.