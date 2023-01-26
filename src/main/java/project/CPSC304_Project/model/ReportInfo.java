package project.CPSC304_Project.model;

import java.sql.Date;

/**
 * Represents a report filed by a user on a work.
 */
public class ReportInfo {
    private int reportID;
    private String reason;
    private String issue;
    private String description;
    private Date date;
    private String user;    // (user who submitted the report)
    private int reportedWorkID;

    public ReportInfo(int reportID, String reason, String issue, String description, Date date, String user, int reportedWorkID) {
        this.reportID = reportID;
        this.reason = reason;
        this.issue = issue;
        this.description = description;
        this.date = date;
        this.user = user;
        this.reportedWorkID = reportedWorkID;
    }

    public int getReportID() {
        return reportID;
    }

    public String getReason() {
        return reason;
    }

    public String getIssue() {
        return issue;
    }

    public String getDescription() {
        return description;
    }

    public Date getDate() {
        return date;
    }

    public String getUser() {
        return user;
    }

    public int getReportedWorkID() {
        return reportedWorkID;
    }
}
