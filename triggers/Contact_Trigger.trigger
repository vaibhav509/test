trigger Contact_Trigger on Contact (after insert,before Delete, after Undelete,after Delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            contactTrigger_Handler.afterInsert(Trigger.new);
            
        }
        if(Trigger.isUndelete){
            contactTrigger_Handler.afterUndelete(Trigger.new);
        }
        if(Trigger.isDelete){
            contactTrigger_Handler.afterDelete(Trigger.old);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            contactTrigger_Handler.beforeDelete(Trigger.old);
        }
    }
}