public class findAppointmentSlots {
    
    //Date: 9-17-2022
    //Description:  Retrieves appointment slots for a Service Appointment 
    //Service Appt Id for testing 08p4x0000026RW9AAM    
    //https://salesforce.stackexchange.com/questions/350135/system-jsonexception-type-cannot-be-serialized-cant-serialize-getslots-result
    
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
    
    public static String getAppointmentSlots(String saId) { 
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
        
        return absAsJSON;	
        
    } 
}
