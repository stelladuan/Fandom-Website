package project.CPSC304_Project.model;

import java.sql.Date;

/**
 * Represents a note (comment) left by a user on a work.
 */
public class NoteInfo {
    private Work work;
    private String text;
    private Date noteDate;

    public NoteInfo(Work work, String content, Date date) {
        this.work = work;
        text = content;
        this.noteDate = date;
    }

    public Work getWork() {
        return work;
    }

    public String getText() {
        return text;
    }

    public Date getNoteDate() {
        return noteDate;
    }
}
