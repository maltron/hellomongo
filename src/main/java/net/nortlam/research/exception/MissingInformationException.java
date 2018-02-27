package net.nortlam.research.exception;

/**
 * There were some missing Information
 * 
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class MissingInformationException extends Exception {

    public MissingInformationException() {
    }

    public MissingInformationException(String message) {
        super(message);
    }

    public MissingInformationException(String message, Throwable cause) {
        super(message, cause);
    }

    public MissingInformationException(Throwable cause) {
        super(cause);
    }

    public MissingInformationException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
