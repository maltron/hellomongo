package net.nortlam.research.setup;

import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexModel;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.ejb.ConcurrencyManagement;
import javax.ejb.ConcurrencyManagementType;
import javax.ejb.Lock;
import javax.ejb.LockType;
import javax.ejb.Singleton;
import net.nortlam.research.Person;

/**
 *
 * @author Mauricio "Maltron" Leal <maltron@gmail.com> */
@Singleton
@ConcurrencyManagement(ConcurrencyManagementType.CONTAINER)
public class MongoProvider {

    private static final Logger LOG = Logger.getLogger(MongoProvider.class.getName());
    
    public static final String MONGODB_HOST = "mongodb";
    public static final int MONGODB_PORT = 27017;
    public static final String MONGODB_DATABASE = "todai";
    public static final String MONGODB_USERNAME = "todai";
    public static final String MONGODB_PASSWORD = "todai";
    
    private MongoClient client;
    
    @PostConstruct
    private void init() {
        LOG.log(Level.INFO, ">>> init() CONNECTING TO MONGO");
        MongoCredential credential = MongoCredential.createCredential(
                MONGODB_USERNAME, MONGODB_DATABASE, MONGODB_PASSWORD.toCharArray());
        ServerAddress address = new ServerAddress(MONGODB_HOST, MONGODB_PORT);
        client = new MongoClient(address, Arrays.asList(credential));
        
        // Create a Index specific for Collection: persons
        getDatabase().getCollection(Person.COLLECTION_NAME)
                .createIndex(Indexes.ascending(
                        Person.TAG_FIRST_NAME, Person.TAG_LAST_NAME),
                        new IndexOptions().unique(true));
    }
    
    @Lock(LockType.READ)
    public MongoDatabase getDatabase() {
        return client.getDatabase(MONGODB_USERNAME);
    }

}
