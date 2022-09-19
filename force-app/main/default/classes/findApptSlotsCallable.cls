global with sharing class findApptSlotsCallable implements vlocity_cmt.VlocityOpenInterface {
    
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
        ABS[] results = new ABS[0];
        for(FSL.AppointmentBookingSlot slot: slots) {
            results.add(new ABS(slot.grade, slot.interval));
        }
        
        String absAsJSON = JSON.serialize(results);
        //System.debug('Returned ' + slots.size() + ' appointment slots');
        //for(integer i=0; i<slots.size(); i++){
        
        //    system.debug('Slot:'+i+' Start: '+slots[i].Interval.Start+' Finish:'+ slots[i].Interval.Finish+' Grade: '+slots[i].Grade);
        //}
        
        System.debug('JSON: ' + absAsJSON);
        
      	output.put('result',results);
         
    }

    //Some standard objects can't be serialized. You need to manually copy it to something that can be serialized.
    class ABS {
        public Decimal grade;
        public DateTime startTime, endTime;
        ABS(Decimal grade, FSL.TimeInterval interval) {
            this.grade = grade;
            this.startTime = interval.start;
            this.endTime = interval.finish;
        }
    }
}