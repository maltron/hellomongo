/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package net.nortlam.research.exception;

import java.util.logging.Logger;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

/**
 * Code: 204: NO CONTENT
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
@Provider
public class NoContentExceptionMapper implements ExceptionMapper<NoContentException> {

    private static final Logger LOG = Logger.getLogger(NoContentExceptionMapper.class.getName());

    @Override
    public Response toResponse(NoContentException ex) {
        return Response.status(Response.Status.NO_CONTENT).build();
    }

    

}
