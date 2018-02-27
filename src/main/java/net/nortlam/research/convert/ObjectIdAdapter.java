package net.nortlam.research.convert;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.bind.annotation.adapters.XmlAdapter;
import org.bson.types.ObjectId;

/**
 * It helps JAXB to replace content into ObjectId object
 * 
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class ObjectIdAdapter extends XmlAdapter<String, ObjectId> {

    private static final Logger LOG = Logger.getLogger(ObjectIdAdapter.class.getName());

    public ObjectIdAdapter() {
    }
    
    @Override
    public ObjectId unmarshal(String content) throws Exception {
        LOG.log(Level.INFO, ">>> unmarshall() Content:{0}", content);
        if(content == null) throw new Exception("### ObjectIdAdapter: content is null");
        return new ObjectId(content);
    }

    @Override
    public String marshal(ObjectId objectId) throws Exception {
        LOG.log(Level.INFO, ">>> marshall() Content:{0}", objectId.toString());
        if(objectId == null) throw new Exception("### ObjectIdAdapter: objectId is null");
        return objectId.toString();
    }
}
