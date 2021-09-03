class MemoryManagerRoutine extends Routine {
  //Attributes
  SOS os;
  int processLength;
  int result;
  Partition currentPartition;
  Partition nextPartition;
  Partition beforePartition;
  Partition afterPartition;
  //Constructors
  MemoryManagerRoutine(String c, String d, SOS os_) {
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
  int endRoutine(int plength) {
    processLength = plength;
    endRoutine();
    return result;
  }
  //Default End Routine
  void endRoutine() {
    result =-1; //-1 did not find a partition
    for (int i=0; i<os.partitionTable.size(); i++) 
    {
      //If the current partition is free and its size is equal to the process to be inserted
      if (os.partitionTable.get(i).isFree && os.partitionTable.get(i).size == processLength) 
      { 
        //Send back the partition position and stop searching
        result = i;
        break;
      } 
      //Splitting of partitions in appropriate sized parts below.
      if (os.partitionTable.get(i).isFree && os.partitionTable.get(i).size > processLength)
      {
        //Save as new current and next partition temporarily
        currentPartition = new Partition(os.partitionTable.get(i).baseAddress, processLength);
        nextPartition = new Partition(os.partitionTable.get(i).baseAddress + currentPartition.size, os.partitionTable.get(i).size - processLength);
        //set the current one at the current position
        os.partitionTable.set(i, currentPartition);
        //Add to the partition table at the next position the next partition
        os.partitionTable.add(i+1, nextPartition);
        //Send back the partition position and stop searching
        result = i;
        break;
      }
    }

    //Compaction
    //If I havent found a partition
    if (result == -1) 
    {
      //Traverse the partition table, except the last position
      for (int i = 0; i < os.partitionTable.size() - 1; i++) 
      {
        //If the the current partition is free
        if (os.partitionTable.get(i).isFree) 
        {
          //Store the first and second partition
          beforePartition = os.partitionTable.get(i);
          afterPartition = os.partitionTable.get(i+1);
          //Traverse for as long as the second partition
          for (int j=0; j<afterPartition.size; j++) 
          {
            //Change the partition base address and set the after partition to empty
            os.PC.RAM[beforePartition.baseAddress+j] = os.PC.RAM[afterPartition.baseAddress + j];
            os.PC.RAM[afterPartition.baseAddress + j] = '_';
          }
          //Traverse for the amount of processes
          for (int j = 0; (j < os.processTable.size()); j++) 
          {
            //if the process base address is the same as the second's partition
            if (os.processTable.get(j).baseAddress == afterPartition.baseAddress) 
            {
              //then get the current processes base address and make it to be the same with the first's partition
              os.processTable.get(j).baseAddress = beforePartition.baseAddress;
              break;
            }
          }
          //Set the partition found to have the first's partition's base address and the second one's size
          os.partitionTable.set(i, new Partition(beforePartition.baseAddress, afterPartition.size));
          //Set the next partition from the one found to have the first's partition's base address + the seconds one's size and the first one's size
          os.partitionTable.set(i+1, new Partition(beforePartition.baseAddress + afterPartition.size, beforePartition.size));
          //Set the partition to be occupied
          os.partitionTable.get(i).isFree = false;
          //Coalescing has to happen immediatelly after
          if (i < os.partitionTable.size() - 2 && os.partitionTable.get(i+2).isFree) 
          {
            //Get the partition thats one after the current position of the loop
            beforePartition = os.partitionTable.get(i+1);
            //Get the partition thats two after the current position of the loop
            afterPartition = os.partitionTable.get(i+2);
            //Remove the spartition that is 2 steps later in the loop
            os.partitionTable.remove(i+2);
            //Set at the next position in the partition table a new partition to have the previous partitions base address and the size to be the 
            //summation of the two partitions.
            os.partitionTable.set(i+1, new Partition(beforePartition.baseAddress, beforePartition.size + afterPartition.size));
          }
        }
      }

      result =-1; //-1 did not find a partition
      //Find a free partition for the purposes of placing a program.
      for (int i=0; i<os.partitionTable.size(); i++) 
      {
        //If the current partition is free and its size is equal to the process to be inserted
        if (os.partitionTable.get(i).isFree && os.partitionTable.get(i).size == processLength) 
        { 
          //Send back the partition position and stop searching
          result = i;
          break;
        } 
        //If the current partition is free and its size is greater than the process to be inserted
        if (os.partitionTable.get(i).isFree && os.partitionTable.get(i).size > processLength)
        {
          //Save as new current and next partition temporarily
          currentPartition = new Partition(os.partitionTable.get(i).baseAddress, processLength);
          nextPartition = new Partition(os.partitionTable.get(i).baseAddress + currentPartition.size, os.partitionTable.get(i).size - processLength);
          //set the current one at position i
          os.partitionTable.set(i, currentPartition);
          //Add to the partition table at the next position the next partition
          os.partitionTable.add(i+1, nextPartition);
          //Send back the partition position and stop searching
          result = i;
          break;
        }
      }
      os.interruptsEnabled = true;
    }
  }
}
