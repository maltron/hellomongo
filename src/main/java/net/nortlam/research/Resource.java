package net.nortlam.research;

import com.mongodb.MongoException;
import com.mongodb.MongoWriteConcernException;
import com.mongodb.MongoWriteException;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;

import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.NotFoundException;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import net.nortlam.research.setup.MongoProvider;
import net.notlam.research.exception.NoContentException;
import org.bson.Document;
import org.bson.types.ObjectId;

/**
 *
 * @author Mauricio "Maltron" Leal <maltron@gmail.com> */
@Path("/person")
public class Resource {

    private static final Logger LOG = Logger.getLogger(Resource.class.getName());
    
    @EJB
    private MongoProvider provider;
    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response all() throws NoContentException {
        LOG.log(Level.INFO, ">> all()");
        
        Collection<Person> all = new ArrayList<>();
        for(Document document: getCollection().find().sort(
                Sorts.ascending(Person.TAG_FIRST_NAME, Person.TAG_LAST_NAME)))
            all.add(new Person(document));
        
        GenericEntity<Collection<Person>> result = 
                new GenericEntity<Collection<Person>>(all){};
        
        return Response.ok(result).build();
    }
    
    @Path("/{ID}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response fetchByID(@PathParam("ID")String ID) throws NotFoundException {
        Document document = new Document().append("_id",new ObjectId(ID));
        Document found = getCollection().find(document).first();
        LOG.log(Level.INFO, ">>> fetchByID() {0}", found);
        
        if(found == null) 
            throw new NotFoundException("ID "+ID+" not found");
        
        return Response.ok(found.toJson(), MediaType.APPLICATION_JSON).build();
    }
    
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response create(Person person) 
                throws MongoWriteException, 
                        MongoWriteConcernException, MongoException {
        Document document = person.toDocument();
        getCollection().insertOne(document);
        LOG.log(Level.INFO, ">>> create() {0}", document.toJson());
        LOG.log(Level.INFO, ">>> ObjectID: HEX:{0} String:{1}", new Object[] {
            document.getObjectId("_id").toString(),
            document.getObjectId("_id").toHexString()}
        );
            
        // Returns the created ID for this information
        return Response.status(Response.Status.CREATED)
                .entity(document.getObjectId("_id").toHexString())
                .type(MediaType.APPLICATION_JSON).build();
    }
    
    @Path("/{ID}")
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response update(@PathParam("ID") String ID, Person person) 
                                                 throws NotFoundException {
        Document found = getCollection().find(
                new Document().append("_id", new ObjectId(ID))).first();
        if(found == null) throw new NotFoundException("ID "+ID+" not found");
        
        UpdateResult result = getCollection().updateOne(found, 
                                    new Document("$set", person.toDocument()));
        if(result.getModifiedCount() == 0)
            return Response.status(Response.Status.GONE).build();
        
        // Indicates nothing was modified at all
        return Response.status(Response.Status.ACCEPTED).build();
    }
    
    @DELETE @Path("{ID}")
    public Response delete(@PathParam("ID")String ID) 
            throws NotFoundException,
               MongoWriteException, MongoWriteConcernException, MongoException {
        Document found = fetchByObjectId(ID);
        DeleteResult result = getCollection().deleteOne(found);
        
        // Inidicate the content selected was deleted
        if(result.getDeletedCount() == 0)
            return Response.status(Response.Status.GONE).build();
        
        // Although the content was found, nothing was deleted
        return Response.status(Response.Status.ACCEPTED).build();
    }
    
    private Document fetchByObjectId(String ID) throws NotFoundException {
        Document found = getCollection().find(
                new Document().append("_id", new ObjectId(ID))).first();
        if(found == null) throw new NotFoundException("ID: "+ID+" not found");
        
        return found;
    }
    
    private MongoCollection<Document> getCollection() {
        return provider.getDatabase().getCollection(Person.COLLECTION_NAME);
    }
}
