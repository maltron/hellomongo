package net.nortlam.research.model;

import java.io.Serializable;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import net.nortlam.research.exception.InvalidException;
import org.bson.types.ObjectId;

/**
 *
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
@XmlRootElement(name="person")
@XmlAccessorType(XmlAccessType.FIELD)
public class Person implements Serializable {

    private static final Logger LOG = Logger.getLogger(Person.class.getName());
    
    public static final String COLLECTION_NAME = "people";
    
    public static final String TAG_ID = "_id";
    @XmlElement(name = TAG_ID, nillable = true, required = false)
    private ObjectId ID;    
    
    public static final String TAG_FIRST_NAME = "firstName";
    @XmlElement(name = TAG_FIRST_NAME, nillable = false, required = true, type = String.class)
    private String firstName;
    
    public static final String TAG_LAST_NAME = "lastName";
    @XmlElement(name = TAG_LAST_NAME, nillable = false, required = true, type = String.class)
    private String lastName;

    public Person() {
    }

    public Person(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
    
    public ObjectId getID() {
        return ID;
    }
    
    public void setID(ObjectId ID) {
        this.ID = ID;
    }
    
    public void setID(String hexString) throws InvalidException {
        if(hexString == null) throw new InvalidException("ID value is null");
        if(!ObjectId.isValid(hexString))
            throw new InvalidException("ID value is not valid: "+hexString);
        
        this.ID = new ObjectId(hexString);
    }
    
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 17 * hash + Objects.hashCode(this.ID);
        hash = 17 * hash + Objects.hashCode(this.firstName);
        hash = 17 * hash + Objects.hashCode(this.lastName);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Person other = (Person) obj;
        if (!Objects.equals(this.ID, other.ID)) {
            return false;
        }        
        if (!Objects.equals(this.firstName, other.firstName)) {
            return false;
        }
        if (!Objects.equals(this.lastName, other.lastName)) {
            return false;
        }
        return true;
    }
    
    public JsonObject toJSON() {
        JsonObjectBuilder builder = Json.createObjectBuilder();
        if(this.ID != null) builder.add(TAG_ID, this.ID.toHexString());
        builder.add(TAG_FIRST_NAME, this.firstName);
        builder.add(TAG_LAST_NAME, this.lastName);
        
        return builder.build();
    }
    
    @Override
    public String toString() {
        return toJSON().toString();
    }
}
