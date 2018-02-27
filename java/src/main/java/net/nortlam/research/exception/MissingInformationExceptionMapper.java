package net.nortlam.research.exception;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;

/**
 * 400: Bad Request
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class MissingInformationExceptionMapper implements ExceptionMapper<MissingInformationException> {

    private static final Logger LOG = Logger.getLogger(MissingInformationExceptionMapper.class.getName());

    @Override
    public Response toResponse(MissingInformationException ex) {
        LOG.log(Level.WARNING, "### Missing Information Exception:{0}", ex.getMessage());
        return Response.status(Response.Status.BAD_REQUEST).build();
    }
}
