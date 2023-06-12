/**
*
*  Purpose          :   Class to Handle triggers related to Student__c Object.
*
*  Created Date     :   4/04/2022
*
*  Created By       :   Prashant Saraswat
*
*  Version          :   V_1.0 
*
**/

public without sharing class StudentTriggerHandler {
    
    
    public static void CalculateNumberOfStudents(List<Student__c> newOrUpdatedStudents) {
        
        set<id> ClassIds = new Set<id>();
        for(Student__c st: newOrUPdatedStudents) {
            if(st.Class__c != Null) {
               ClassIds.add(st.Class__c);
            }
        }
        set<id> SchoolIds = new Set<id>();
        
        for(Class__c cl: [SELECT id, School__c FROM Class__c WHERE id in :ClassIds]) {
            if(cl.School__c!=NULL) {
                SchoolIds.add(cl.School__c);
            }
        }
        map<id, Integer> mapOfSchoolIdsWithNumberOfStudents = new map<id, Integer>();
        for(Student__c st: [SELECT id, Class__r.School__c FROM Student__c WHERE Class__r.School__c in:SchoolIds]) {
            if(!mapOfSchoolIdsWithNumberOfStudents.containsKey(st.Class__r.School__c))
                {
                    mapOfSchoolIdsWithNumberOfStudents.put(st.Class__r.School__c, 1);
                }
                else
                {
                   
                    mapOfSchoolIdsWithNumberOfStudents.put(st.Class__r.School__c,(mapOfSchoolIdsWithNumberOfStudents.get(st.Class__r.School__c) + 1));
                }
        }
        List<School__c> listOfSchoolsToBeUpdated = new List<School__c>();
        for(id scId :mapOfSchoolIdsWithNumberOfStudents.keySet()) {
            School__c sc = new School__c();
            sc.id = scId;
            sc.Number_of_Students__c = mapOfSchoolIdsWithNumberOfStudents.get(scId);
            listOfSchoolsToBeUpdated.add(sc);
        }
        Utilities.BypassAllTriggers = true;
        update listOfSchoolsToBeUpdated;
        Utilities.BypassAllTriggers = false;
    }
}
    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    