package net.nortlam.research;

import org.bson.Document;

/**
 *
 * @author Mauricio "Maltron" Leal <maltron@gmail.com> */
public class Person extends Document {
    
    public static final String TAG_FIRST_NAME = "firstName";
    
    public static final String TAG_LAST_NAME = "lastName";

    public Person() {
    }
    
    public Person(Document document) {
        append(TAG_FIRST_NAME, document.get(TAG_FIRST_NAME));
        append(TAG_LAST_NAME, document.get(TAG_LAST_NAME));
    }
    
    public String getFirstName() {
        return getString(TAG_FIRST_NAME);
    }

    public void setFirstName(String firstName) {
        put(TAG_FIRST_NAME, firstName);
    }

    public String getLastName() {
        return getString(TAG_LAST_NAME);
    }

    public void setLastName(String lastName) {
        put(TAG_LAST_NAME, lastName);
    }

    @Override
    public String toString() {
        return toJson();
    }
}