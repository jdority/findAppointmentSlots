global with sharing class findApptSlotsCallable implements vlocity_cmt.VlocityOpenInterface, Callable {
    
    //Date: 9-19-2022
    //Description:  Retrieves FSL appointment slots for a Service Appointment 
    //Service Appt Id for testing 08p4x0000026RW9AAM    
    //https://salesforce.stackexchange.com/questions/350135/system-jsonexception-type-cannot-be-serialized-cant-serialize-getslots-result
    //
    
    
    //Upgrade VlocittyOpenInterface to Callable  https://docs.google.com/document/d/1EwQXl3nHKL1krlzryj7wW5XN_XQ_r-40voqqPFmC8Jg/edit 
 	public Object call(String action, Map<String, Object> args) {

     Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
     Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
     Map<String,Object> options = (Map<String,Object>)args.get('options');
        
     return invokeMethod(action, inputMap, outputMap, options);
   }

    
    global boolean invokeMethod(String methodName, Map<String, object> input, Map<String, object> output, Map<String, object> options){
        boolean result=true;
        
        try{
            if(methodName.equalsIgnoreCase('getApptSlots')){
                getApptSlots(input,output,options);
      
            }else{
                output.put('result','');
            }
            
        }catch(Exception e)
        {return false;
        }
        return result;
    }
    
    public void getApptSlots (Map<String, object> input, Map<String, object> output, Map<String, object> options){
        String saId=(String)input.get('saId');
        
        ServiceAppointment sa = [SELECT Id, EarliestStartTime, DueDate FROM ServiceAppointment 
                                 WHERE Id= :saId];
        Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c 
                                 WHERE Name='Emergency' LIMIT 1].Id;
        Id operatingHoursId   = [SELECT id FROM OperatingHours 
                                 WHERE name='Gold Appointments Calendar' LIMIT 1].Id;
        //System.debug('Queries Completed.');
        
        Timezone tz = UserInfo.getTimeZone();
        List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, operatingHoursId, tz, false);
        
        //Some standard objects can't be serialized. You need to manually copy it to something that can be serialized.
        List<Map<String, Object>> results = new List<Map<String, Object>>();                
        for(FSL.AppointmentBookingSlot slot: slots) {

            Map<String, Object> entry = new Map<String, Object>();
            entry.put('grade', slot.grade);
            entry.put('startTime', slot.interval.start);
            entry.put('endTime', slot.interval.finish);
            
            results.add(entry);
        }
        
      	output.put('result', results);
         
    }
}