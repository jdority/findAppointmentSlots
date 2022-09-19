
# findAppointmentSlots

//Description:  Retrieves appointment slots for a Service Appointment 

APEX Notes:
If you receive: to fix "Apex class needs to implement System.Callable" from the integration procedure try setting the following value in Omni Interaction Configuration:   RollbackIPChanges= true 

Otherwise make sure your class supports both Open Interface and Callable See the following:
 https://docs.google.com/document/d/1EwQXl3nHKL1krlzryj7wW5XN_XQ_r-40voqqPFmC8Jg/edit?usp=sharing 


 Integration Procedure as a Rest Endpoint
 To call integration procedure as a REST endpoint - See the following: https://confluence.internal.salesforce.com/pages/viewpage.action?spaceKey=SISCAT&title=Integration+-+Calling+Vlocity+APIs+Externally


 example postman URL https://eversourcesfspoc22-demo.my.salesforce.com/services/apexrest/vlocity_cmt/v1/integrationprocedure/Appointment_FSL