package net.nortlam.research.convert;

import java.io.Serializable;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.nortlam.research.model.Person;

import org.bson.Document;
import org.bson.types.ObjectId;

/**
 * A support class to help converting between some objects and Mongo native objects 
 * 
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class MongoConverter implements Serializable {

    private static final Logger LOG = Logger.getLogger(MongoConverter.class.getName());
    
    public static Document toDocument(Person person) {
        Document document = new Document()
                .append(Person.TAG_FIRST_NAME, person.getFirstName())
                .append(Person.TAG_LAST_NAME, person.getLastName());
        
        // Is there any ID available for this Person
        if(person.getID() != null)
            document.append(Person.TAG_ID, person.getID());
        
        return document;
    }
    
    public static Person fromDocument(Document document) {
        Person person = new Person();
        
        ObjectId ID = document.getObjectId(Person.TAG_ID);
        if(ID != null) person.setID(ID);
        
        String firstName = document.getString(Person.TAG_FIRST_NAME);
        if(firstName != null) person.setFirstName(firstName);
        
        String lastName = document.getString(Person.TAG_LAST_NAME);
        if(lastName != null) person.setLastName(lastName);
        
        return person;
    }
}
