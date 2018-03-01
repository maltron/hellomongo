package net.nortlam.research;

import java.io.Serializable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

/**
 *
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
@Path("/ping")
public class PingResource implements Serializable {

    private static final Logger LOG = Logger.getLogger(PingResource.class.getName());

    @GET
    public Response ping() {
//        LOG.log(Level.INFO, ">>> PingResource.ping()");
        return Response.ok().build();
    }
    
}
