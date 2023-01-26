package project.CPSC304_Project.model;

import java.sql.Date;

/**
 * Represents a like left by a user on a work.
 */
public class LikeInfo {
    private Work work;
    private Date likeDate;

    public LikeInfo(Work work, Date date) {
        this.work = work;
        this.likeDate = date;
    }

    public Work getWork() {
        return work;
    }

    public Date getLikeDate() {
        return likeDate;
    }
}
