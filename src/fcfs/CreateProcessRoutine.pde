class CreateProcessRoutine extends Routine {
  //Attributes
  SOS os;
  //Constructors
  CreateProcessRoutine(String c, String d, SOS os_) {
    super(c, d);
    os = os_;
  }
  //Methods
  void startRoutine() {
    os.interruptsEnabled = false;
    os.physicalAddress = baseAddress;
    os.state = description;
  }
  //End Routine with Parameters
  ProcessInfo endRoutine(int iprocess, String p_process)
  {
    os.i = iprocess;
    os.p = p_process;
    endRoutine();
    return os.pi;
  }
  //Default End Routine
  void endRoutine() 
  {
    os.pi = new ProcessInfo(os.partitionTable.get(os.i).baseAddress, os.p.length(), os.PC.clock);
    os.processTable.add(os.pi);
    //Puts process in cells with the last partition
    for (int j=0; j<os.p.length(); j++) 
    {
      os.PC.RAM[j+os.partitionTable.get(os.i).baseAddress] = os.p.charAt(j);
    }  
    os.partitionTable.get(os.i).isFree = false; 
    os.interruptsEnabled = true;
  }
}
