/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.notlam.research.exception;

import com.mongodb.MongoWriteConcernException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

/**
 * @return Code 503: Service Unavailable
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
@Provider
public class MongoWriteConcernExceptionMapper implements ExceptionMapper<MongoWriteConcernException> {

    private static final Logger LOG = Logger.getLogger(MongoWriteConcernExceptionMapper.class.getName());

    @Override
    public Response toResponse(MongoWriteConcernException ex) {
        LOG.log(Level.WARNING, "### MONGO WRITE CONCERN EXCEPTION:{0}", ex.getMessage());
        return Response.status(Response.Status.SERVICE_UNAVAILABLE).build();
    }


}
