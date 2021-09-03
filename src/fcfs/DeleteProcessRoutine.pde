class DeleteProcessRoutine extends Routine {
  //Attributes
  SOS os;
  //Constructors
  DeleteProcessRoutine(String c, String d, SOS os_) {
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
  void endRoutine(ProcessInfo p) 
  {
    os.pi = p;
    endRoutine();
  }
  //Default End Routine
  void endRoutine() {
    os.pi.state = EXITING;
    //Find the partition
    for (int i=0; i<os.partitionTable.size(); i++) 
    {
      if (os.partitionTable.get(i).baseAddress == os.pi.baseAddress) 
      {
        //delete data from that partition
        for (int j=0; j<os.partitionTable.get(i).size; j++) 
        {
          os.PC.RAM[j+os.pi.baseAddress] = '_';
        }  
        //Coalescing Below
        os.partitionTable.get(i).isFree=true;
        //If the previous partition is free and I am within list bounds
        if (os.partitionTable.get(i+1).isFree && i <= os.partitionTable.size())
        {
          //Save the current and the next partitions temporarily
          Partition tempPartition = os.partitionTable.get(i);
          Partition tempPartition2 = os.partitionTable.get(i+1);
          //Remove both
          os.partitionTable.remove(tempPartition);
          os.partitionTable.remove(tempPartition2);
          //Then add to the position of the current partition at its address but with size as big as both partitions
          os.partitionTable.add(i, new Partition(tempPartition.baseAddress, tempPartition.size + tempPartition2.size));
        }
        //If the next partition is free and I am within list bounds
        if (os.partitionTable.get(i-1).isFree && i >= 1) 
        { 
          //Save the current and the previous partitions temporarily
          Partition tempPartition = os.partitionTable.get(i);
          Partition tempPartition2 = os.partitionTable.get(i-1);
          //Remove both
          os.partitionTable.remove(tempPartition);
          os.partitionTable.remove(tempPartition2);
          //Then add to the position of the previous partition at its address but with size as big as both partitions
          os.partitionTable.add(i-1, new Partition(tempPartition2.baseAddress, tempPartition.size + tempPartition2.size));
        } 
        //delete the process from the process table
        os.processTable.remove(os.pi);
        break;
      }
    }
    os.interruptsEnabled = true;
  }
}
