class AdmitProcessRoutine extends Routine {
  //Attributes
  SOS os;
  //Constructors
  AdmitProcessRoutine(String c, String d, SOS os_) {
    super(c, d);
    os = os_;
  }
  //Methods
  void startRoutine() 
  {
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
  void endRoutine()
  {
    if (os.pi!=null) 
    {
      os.pi.state = READY;
      os.queue.add(os.pi);
      if (os.runningProcess==null) 
      {
        os.kernel.get("Scheduler").startRoutine();
      }
    }
    os.interruptsEnabled = true;
  }
}
