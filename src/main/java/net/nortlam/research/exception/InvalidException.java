package net.nortlam.research.exception;

/**
 * An invalid operation has been attempted
 * 
 * @author Mauricio "Maltron" Leal <maltron at gmail dot com>
 */
public class InvalidException extends Exception {

    public InvalidException() {
    }

    public InvalidException(String message) {
        super(message);
    }

    public InvalidException(String message, Throwable cause) {
        super(message, cause);
    }

    public InvalidException(Throwable cause) {
        super(cause);
    }

    public InvalidException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
