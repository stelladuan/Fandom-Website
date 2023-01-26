package project.CPSC304_Project.model;

import java.sql.Date;

/**
 * Represents a bookmark created by a user on a work.
 */
public class BookmarkInfo {
    private Work work;

    private String note;
    private boolean isPublic;
    private Date bookmarkDate;

    public BookmarkInfo(Work work, String note, boolean isPublic, Date date) {
        this.work = work;
        this.note = note;
        this.isPublic = isPublic;
        this.bookmarkDate = date;
    }

    public Work getWork() {
        return work;
    }

    public String getNote() {
        return note;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public Date getBookmarkDate() {
        return bookmarkDate;
    }
}
