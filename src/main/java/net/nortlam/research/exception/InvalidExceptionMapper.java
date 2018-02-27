package net.nortlam.research.exception;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;

/**
 * @return Code 409: Conflict
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class InvalidExceptionMapper implements ExceptionMapper<InvalidException> {

    private static final Logger LOG = Logger.getLogger(InvalidExceptionMapper.class.getName());

    public InvalidExceptionMapper() {
    }

    @Override
    public Response toResponse(InvalidException ex) {
        LOG.log(Level.WARNING, "### INVALID EXCEPTION:{0}", ex.getMessage());
        return Response.status(Response.Status.CONFLICT).build();
    }
}
