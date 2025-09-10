SELECT employee.ContactID, Firstname, LastName 
FROM `tc-da-1.adwentureworks_db.contact`  as contact
JOIN `tc-da-1.adwentureworks_db.employee` as employee
ON contact.ContactId = employee.ContactID
