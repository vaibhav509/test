public class contactTrigger_Handler {
    public static void afterInsert(List<Contact> newList){
        ContactRelationship(newList);
        countOfContactAtInsertDelete(newList);
    }
    public static void beforeDelete(List<Contact> oldList){
        contactRelationshipDelete(oldList);
    }
    public static void afterUndelete(List<Contact> newList){
        contactRelationshipUndelete(newList);
    } 
    public static void afterDelete(List<Contact> oldList){
       // countOfContactAfterDelete(oldList);
        countOfContactAtInsertDelete(oldList);
    }
    public static void ContactRelationship(List<Contact> newList){
        
        List<Contact_Relationship__c> conRelList = new List<Contact_Relationship__c>();
        Integer i=1;
        for(Contact con: newList){
            if(con.Contact_Relationship__c==true){
            Contact_Relationship__c newConRel = new Contact_Relationship__c();
            newConRel.Name = 'ContactRelationship'+i;
            newConRel.Contact__c = con.Id;
            i=i+1;
            conRelList.add(newConRel);
        }
        }
        if(conRelList!=null && conRelList.size()>0){
        insert conRelList;
        }
    }
    
    public static void contactRelationshipDelete(List<Contact> oldList){
        set<id> conId = new set<id>();
        for(contact conn: oldList){
            conId.add(conn.Id);
        }
        
        List<Contact_Relationship__c> conRel = [Select id from Contact_Relationship__c where Contact__c IN :conId];
        if(conRel!=null  && conRel.size()>0){
        delete conRel;
        }
        
        
    }
    
    public static void contactRelationshipUndelete(List<Contact> newList){
        set<id> conIds = new set<id>();
        for(Contact con: newList){
            conIds.add(con.Id);
        }
        List <Contact_Relationship__c> conRel = [Select id,Name from Contact_Relationship__c where isDeleted =True and Contact__c IN :conIds ALL ROWS];
        
        undelete conRel;
        
       
    }
    
    public static void countOfContactAtInsertDelete(List<Contact> newOldList){
        set<id> conIds = new set<id>();
        for(contact con : newOldList){
            conIds.add(con.AccountId);
        }
        List<account> accListNew = new List<account>();
        list<account> accList =[Select id,(Select id from contacts),Count_of_Contacts__c from account where id IN :conIds];
        for(account acc: accList){
            acc.Count_of_Contacts__c = acc.contacts.size();
            accListNew.add(acc);
        }
        if(accListNew!=null && accListNew.size()>0){
        update accListNew;
        }
    }
    
    /*public static void countOfContactAfterDelete(List<Contact> oldList){
        set<id> conIds = new set<id>();
        for(contact con : oldList){
            conIds.add(con.AccountId);
        }
        
        List<account> accListNew = new List<account>();
        List<account> accList = [Select id,(select id from contacts),Count_of_Contacts__c from account where id IN :conIds];
        for(account acc :accList){
            acc.Count_of_Contacts__c = acc.contacts.size();
            accListNew.add(acc);
        }
        update accListNew;
    }*/
}