class SOS {
  Hardware PC;
  int physicalAddress;
  int currentAddress;
  ArrayList<Partition> partitionTable;
  ArrayList<ProcessInfo>processTable;
  ArrayList<ProcessInfo> queue;
  ArrayList<Integer>requests;
  ProcessInfo runningProcess;
  ProcessInfo tempPI;
  int tempPartitionIndex;
  String tempProcess;
  String state; //text explaining what is happening
  boolean interruptsEnabled;
  HashMap<String, Routine> kernel;
  //Holds the memory manager partition
  int memoryManagerPartition;
  //Holds a new ProcessInfo
  int i;
  String p;
  //Holds a ProcessInfo Index
  int piIndex;
  //Holds the newly created process
  ProcessInfo pi;
  //Holds the time a new process is created for every process
  float timeOfNewProcess;
  //For Statistics
  //Load Time
  int startLoad;
  int stopLoad;
  //Turnaround Time
  int startTurn;
  int stopTurn;
  //Response Time with guard.
  int startResponse;
  int stopResponse;
  //Averages for Process Statistics
  float turnSum = 0;
  float loadSum = 0;
  float responseSum = 0;
  //Idle Time
  int idleTime = 0;
  //Context Switch Time
  int totalRoutineUtil = 0;
  //Process Utilisation Time
  int totalProcessUtil = 0;

  SOS(Hardware h) {
    PC = h;
    requests = new ArrayList<Integer>();
    kernel = new HashMap<String, Routine>();
    kernel.put("Idle", new Idle("-1", "IDLE", this) );
    kernel.put("Scheduler", new FCFS("++2", "FCFS scheduler", this) );
    //Run the routines
    kernel.put("MemoryManager", new MemoryManagerRoutine("+++3", "MemoryManager", this));
    kernel.put("CreateProcess", new CreateProcessRoutine("++++4", "CreateProcess", this));
    kernel.put("AdmitProcess", new AdmitProcessRoutine("++++5", "AdmitProcess", this));
    kernel.put("DeleteProcess", new DeleteProcessRoutine("++++6", "DeleteProcess", this));
    interruptsEnabled = true;
    state = kernel.get("Idle").description;

    //Set memory partitions
    partitionTable = new ArrayList<Partition>();
    //calculate the total code length of the os
    int osCodeLength =0;
    for (Routine r : kernel.values()) {
      osCodeLength += r.code.length();
    }

    //create the OS partitions and load the os programs
    //b is a memmory address that dictates where to stop.

    int b =0;
    b = loadOSRoutine(kernel.get("Idle"), b);
    b = loadOSRoutine(kernel.get("Scheduler"), b);
    //Load My Routines
    b = loadOSRoutine(kernel.get("MemoryManager"), b);
    b = loadOSRoutine(kernel.get("CreateProcess"), b);
    b = loadOSRoutine(kernel.get("AdmitProcess"), b);
    b = loadOSRoutine(kernel.get("DeleteProcess"), b);

    //Creating the user partition
    partitionTable.add(new Partition(b, (PC.RAM.length-osCodeLength)));

    //Set process Table
    processTable = new ArrayList<ProcessInfo>();
    queue = new ArrayList<ProcessInfo>();
    physicalAddress = kernel.get("Idle").baseAddress;
    currentAddress = physicalAddress;
    runningProcess=null;
  }//END OF CONSTRUCTOR

  int loadOSRoutine(Routine r, int ba)
  {
    Partition tempPartition = new Partition(ba, r.code.length());
    r.baseAddress = ba;
    partitionTable.add(tempPartition);
    for (int j=0; j<r.code.length(); j++)
    {
      PC.RAM[ba+j] = r.code.charAt(j);
    }
    tempPartition.isFree=false;
    return ba+r.code.length();
  }


  void loadProgram(int p)
  {
    //Load time start
    startLoad = PC.clock;
    if (interruptsEnabled)
    {
      if (runningProcess != null)
      {
        runningProcess.state = READY;
        queue.add(runningProcess);
        runningProcess=null;
      }
      tempProcess = PC.HDD.get(p)+"hhhsss";

      kernel.get("MemoryManager").startRoutine();
    } else
    {
      requests.add(p);
    }
  }

  void step() {
    if (interruptsEnabled && !requests.isEmpty()) {
      if (runningProcess != null) {
        runningProcess.state = READY;
        queue.add(runningProcess);
        runningProcess=null;
      }
      loadProgram(requests.get(0));
      requests.remove(0);
    }
      currentAddress = physicalAddress;
      println("curr address is "+currentAddress);
      PC.fetchInstruction(currentAddress);
      char c = PC.executeInstruction();
      println("fetched "+c);
      if (c=='*') {
        //Count as process time.
        totalProcessUtil++;
        state="Executing user process "+runningProcess.PID;
        runningProcess.counter++;
        if (runningProcess.counter == 0) {
          //Stop response time and calculate the sum for the average.
          stopResponse = PC.clock;
          //writer.println("Response Time: " + (stopResponse - startResponse) + " seconds for process -> " + p + " with id " + pi.PID);
          responseSum += stopResponse - startResponse;
        }
        physicalAddress = runningProcess.baseAddress+runningProcess.counter;
      } else if (c=='$') {
        //Count as process time.
        totalProcessUtil++;
        state="Exiting user process "+runningProcess.PID;
        runningProcess.state = EXITING;
        kernel.get("DeleteProcess").startRoutine();
      } else if ( c=='@') {
        runningProcess.counter++;
        //Count as process time.
        totalProcessUtil++;
        //physicalAddress = runningProcess.baseAddress+runningProcess.counter;
        state="Blocking user process "+runningProcess.PID;
        runningProcess.state = BLOCKED;
        runningProcess.blockTime = PC.clock;
        runningProcess = null;
        kernel.get("Scheduler").startRoutine();
      } else if (c=='+') {
        physicalAddress++;
      }
      //Idle time initial symbol and addition here.
      else if (c=='-') {
        physicalAddress++;
        //Count as idle time.
        idleTime++;
      }
      //add the idle time here.
      else if (c==kernel.get("Idle").command) {
        state=kernel.get("Idle").description;
        //Count as idle time.
        idleTime++;
        kernel.get("Idle").endRoutine();
      }
      //Scheduler is called here
      else if (c==kernel.get("Scheduler").command)
      {
        //Count as routine time.
        totalRoutineUtil++;
        kernel.get("Scheduler").endRoutine();

        //If there is a running process
        if (runningProcess!=null)
        {
          physicalAddress = runningProcess.baseAddress+runningProcess.counter;
          state="Finished scheduling. Selected user process "+runningProcess.PID;
        } else
        {
          //go to idle
          state="Finished scheduling. No user process found. Going to idle";
          kernel.get("Idle").startRoutine();
        }
      }
      //Check for Routines
      else if (c==kernel.get("MemoryManager").command) {
        //Count as routine time.
        totalRoutineUtil++;
        piIndex = ((MemoryManagerRoutine)kernel.get("MemoryManager")).endRoutine(tempProcess.length());
        if (piIndex != -1) {
          kernel.get("CreateProcess").startRoutine();
        }
      } else if (c==kernel.get("CreateProcess").command) {
        //Count as routine time.
        totalRoutineUtil++;
        tempPI = ((CreateProcessRoutine)kernel.get("CreateProcess")).endRoutine(piIndex, tempProcess );
        //Start response time.
        startResponse = PC.clock;
        kernel.get("AdmitProcess").startRoutine();
      } else if (c==kernel.get("AdmitProcess").command) {
        //Count as routine time.
        totalRoutineUtil++;
        ((AdmitProcessRoutine)kernel.get("AdmitProcess")).endRoutine(tempPI);
        //Start turn around time.
        startTurn = PC.clock;
        //Stop load time, and add it to the sum for the average.
        stopLoad = PC.clock;
        //writer.println("Load Time: " + (stopLoad - startLoad) + " seconds for process -> " + p + " with id " + pi.PID);
        loadSum += stopLoad - startLoad;
      } else if (c==kernel.get("DeleteProcess").command) {
        //Count as routine time.
        totalRoutineUtil++;
        ((DeleteProcessRoutine)kernel.get("DeleteProcess")).endRoutine(runningProcess);
        //Stop turn around time, and add it to the sum for the average.
        stopTurn = PC.clock;
        writer.println("TurnAround Time: " + (stopTurn - startTurn) + " seconds for process -> " + p + " with id " + pi.PID);
        kernel.get("Scheduler").startRoutine();
        turnSum += stopTurn - startTurn;
      }
  }
}
