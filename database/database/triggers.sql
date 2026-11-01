--triggers.sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER trg_expire_donation
BEFORE INSERT OR UPDATE ON Food_Donation
FOR EACH ROW
BEGIN
   IF :NEW.Expiry_Time <= SYSTIMESTAMP 
      AND :NEW.Status = 'Available' THEN
      :NEW.Status := 'Expired';
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_quantity
BEFORE INSERT OR UPDATE OF Quantity ON Food_Donation
FOR EACH ROW
BEGIN
   IF :NEW.Quantity <= 0 THEN
      RAISE_APPLICATION_ERROR(-20010,'Quantity must be greater than zero');
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_notify_on_approval
AFTER UPDATE OF Status ON Donation_Request
FOR EACH ROW
WHEN (NEW.Status='Approved')
BEGIN
   INSERT INTO Notification
   VALUES (
      seq_notif.NEXTVAL,
      'NGO',
      :NEW.NGO_ID,
      'Request Approved',
      'N',
      SYSTIMESTAMP
   );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_donation_status
AFTER UPDATE OF Status ON Food_Donation
FOR EACH ROW
WHEN (OLD.Status != NEW.Status)
BEGIN
   INSERT INTO Audit_Log
   (Log_ID,Table_Name,Operation,Record_ID,Changed_By,Old_Status,New_Status)
   VALUES
   (seq_log.NEXTVAL,'Food_Donation','UPDATE',
    :NEW.Donation_ID,USER,:OLD.Status,:NEW.Status);
END;
/

CREATE OR REPLACE TRIGGER trg_prevent_active_delete
BEFORE DELETE ON Food_Donation
FOR EACH ROW
BEGIN
   IF :OLD.Status IN ('Requested','Assigned') THEN
      RAISE_APPLICATION_ERROR(-20011,'Cannot delete active donation');
   END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_notify_volunteer
AFTER INSERT ON Pickup
FOR EACH ROW
WHEN (NEW.Volunteer_ID IS NOT NULL)
BEGIN
   INSERT INTO Notification
   VALUES (
      seq_notif.NEXTVAL,
      'Volunteer',
      :NEW.Volunteer_ID,
      'Pickup Assigned',
      'N',
      SYSTIMESTAMP
   );
END;
/

SELECT trigger_name,status
FROM user_triggers
ORDER BY trigger_name;