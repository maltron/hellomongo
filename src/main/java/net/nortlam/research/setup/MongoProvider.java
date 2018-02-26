package net.nortlam.research.setup;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.MongoException;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexModel;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import java.util.Arrays;
import java.util.List;
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
    
    private MongoClient client;
    private String database;
    
    @PostConstruct
    private void init() {
        LOG.log(Level.INFO, ">>> init() Connecting to Database");
        try {
            client = new MongoClient(serverAddress(), credentials(), MongoClientOptions.builder().build());
        } catch(MongoException ex) {
            LOG.log(Level.SEVERE, "### MongoDB: unable to connect: %s", ex.getMessage());
        }
    }
    
    private ServerAddress serverAddress() {
        String hostname = System.getenv("DB_SERVICE_HOSTNAME");
        if(hostname == null) 
            LOG.log(Level.SEVERE, "### MongoDB: variable DB_SERVICE_HOSTNAME is not set");
        
        String portString = System.getenv("DB_SERVICE_PORT");
        if(portString == null)
            LOG.log(Level.SEVERE, "### MongoDB: variable DB_SERVICE_PORT is not set");
        
        int port = 0;
        try {
            port = Integer.parseInt(portString);
        } catch(NumberFormatException ex) {
            LOG.log(Level.SEVERE, "### MongoDB: DB_SERVICE_PORT is not a integer");
        }
        
        return new ServerAddress(hostname, port);
    }
    
    private MongoCredential credentials() {
        String username = System.getenv("DB_USERNAME");
        if(username == null) 
            LOG.log(Level.SEVERE, "### MongoDB: variable DB_USERNAME is not set");
        
        String password = System.getenv("DB_PASSWORD");
        if(password == null) 
            LOG.log(Level.SEVERE, "### MongoDB: variable DB_PASSWORD is not set");
        
        database = System.getenv("DB_DATABASE");
        if(database == null)
            LOG.log(Level.SEVERE, "### MongoDB: variable DB_DATABASE is not set");
        
        return MongoCredential.createCredential(username, database, password.toCharArray());
    }

    @Lock(LockType.READ)
    public MongoDatabase getDatabase() {
        return client.getDatabase(database);
    }    
}
