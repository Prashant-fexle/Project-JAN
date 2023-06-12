/**
*
*  Purpose          :   Class to Handle triggers related to Class__c Object.
*
*  Created Date     :   03/04/2022
*
*  Created By       :   Prashant Saraswat
*
*  Version          :   V_1.0 
*
**/





public class ClassTriggerHandler {
    
    
    
    Public static void CountOfNumberofClasses(List<Class__c> newClasses, Map<id, Class__c> mapOfOldClassesWithIds) {
        set<id> SchoolIds = new Set<id>();
        for(Class__c cl: newCLasses) {
            if(mapOfOldClassesWithIds != NUll && mapOfOldClassesWithIds.values().size() >0) {
                if(mapOfOldClassesWithIds.get(cl.Id).School__c != cl.School__c) {
                    SchoolIds.add(cl.School__c);
                    SchoolIds.add(mapOfOldClassesWithIds.get(cl.Id).School__c);
                }
            }
            else {
                if(cl.School__c != NULL) {
                    SchoolIds.add(cl.School__c);
                }
            }
            
        }
        Map<id, Integer> mapOfSchoolIdsWithNumberOfClasses = new Map<id, Integer>();
        if(SchoolIds.size() > 0) 
        {
            for(Class__c cls: [SELECT id, School__c FROM Class__c WHERE School__c In :SchoolIds])
            {
                if(!mapOfSchoolIdsWithNumberOfClasses.containsKey(cls.School__c))
                {
                    mapOfSchoolIdsWithNumberOfClasses.put(cls.School__c, 1);
                }
                else
                {
                    
                    mapOfSchoolIdsWithNumberOfClasses.put(cls.School__c,(mapOfSchoolIdsWithNumberOfClasses.get(cls.School__c) + 1));
                }
                
            }
             List<School__c> listOfSchoolsToBeUpdated = new List<School__c>();
        for(id scId :mapOfSchoolIdsWithNumberOfClasses.keySet()) {
            School__c sc = new School__c();
            sc.id = scId;
            sc.Number_of_Classes__c = mapOfSchoolIdsWithNumberOfClasses.get(scId);
            listOfSchoolsToBeUpdated.add(sc);
        }
        Utilities.BypassAllTriggers = true;
        update listOfSchoolsToBeUpdated;
        Utilities.BypassAllTriggers = false;
        }

    }
    
    
    
}