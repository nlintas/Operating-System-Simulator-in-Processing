//change the step method, duplicate scheduling tab as a new round robin scheduler, 
//get scheduler -> get round robin if you change the name, could leave the name the same. Dont.
//delete the loop which find the smallest load time
//add an integer of a quota time in process info
//then go to the scheduler if there is a process in the queue give it 2 - 4 ticks (assignment)
//step should have an if and an else. If there is no running process and my quota is 0 then make the running process null, make it from running to ready, put it at the end of the queue and start the scheduler
//else -> rest of the code
//if I still have shit else the shit above.
class FCFS extends Routine 
{
  SOS os;

  FCFS(String c, String d, SOS os_) 
  {
    super(c, d);
    os = os_;
  }

  void startRoutine() 
  {
    os.interruptsEnabled = false;
    os.physicalAddress = baseAddress;
  }

  void endRoutine() 
  {
    ProcessInfo found;
    if (os.queue.isEmpty())
    {
      os.runningProcess=null;
    } else 
    { 
      found = os.queue.get(0);
      for (ProcessInfo p : os.queue) 
      {
        if (p.loadTime<found.loadTime) 
        {
          found = p;
        }
      }
      found.state = RUNNING; //also updates it at the process table

      os.queue.remove(found);
      os.runningProcess=found;
    }
    os.interruptsEnabled = true;
  }
}

class RR extends Routine 
{

  SOS os;

  RR(String c, String d, SOS os_) 
  {
    super(c, d);
    os = os_;
  }

  void startRoutine() 
  {
    os.interruptsEnabled = false;
    os.physicalAddress = baseAddress;
  }

  void endRoutine() 
  {
    ProcessInfo found;
    if (os.queue.isEmpty()) 
    {
      os.runningProcess=null;
    } else 
    { 
      found = os.queue.get(0);
      found.state = RUNNING; //also updates it at the process table
      found.time_until_interrupt = 4;
      os.queue.remove(found);
      os.runningProcess=found;
    }
    os.interruptsEnabled = true;
  }
}
