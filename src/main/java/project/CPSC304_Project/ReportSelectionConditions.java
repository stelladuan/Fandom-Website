package project.CPSC304_Project;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

/**
 * Represents a group of search conditions used to filter a search for reports in the database.
 */
public class ReportSelectionConditions {
    private int reportID;
    private String reason;
    private String issue;
    private Date minDate;
    private Date maxDate;
    private String username;
    private int workID;

    /**
     * Constructs a ReportSelectionConditions with no restrictions. You should use the setter methods to add restrictions.
     * If more than one restriction is specified, they are combined using logical AND.
     * (caution: for some of the setters, you may not be able to reset a condition after adding it).
     */
    public ReportSelectionConditions() {
        reportID = -1;
        reason = null;
        issue = null;
        minDate = null;
        maxDate = null;
        username = null;
        workID = -1;
    }

    /**
     * Restrict the search to reports with the specified ID.
     * (note: reportID is a primary key, so any such search will return at most 1 report).
     * <br>
     * You can change the report ID to search for, but after first setting a valid value, you cannot remove the condition using this method.
     * @param reportID A specific reportID to search for (a positive integer).
     */
    public void setReportID(int reportID) {
        if (reportID > 0) {
            this.reportID = reportID;
        }
    }

    /**
     * Restrict the search to reports with the specified reason.
     * <br>
     * You can change the reason to search for, but after first setting a valid value, you cannot remove the condition using this method.
     * @param reason Report reason to search for. Valid values: 'Malicious or phishing attempt', 'Work has been posted before',
     *                                              'Work contains spam', 'Tags are unrelated to work', 'Disrespectful or offensive',
     *                                              'Includes private information', 'Targeted harassment', 'Directs hate on a protected group',
     *                                              'Threatening or encouraging harm'
     */
    public void setReason(String reason) {
        if (notNullOrEmpty(reason)) {
            this.reason = reason;
        }
    }

    /**
     * Restrict the search to reports with the specified issue. Every reason corresponds to a specific issue.
     * <br>
     * You can change the issue to search for, but after first setting a valid value, you cannot remove the condition using this method.
     * @param issue Report issue to search for. Valid values: 'Suspicious or spam', 'Abusive or harmful'
     */
    public void setIssue(String issue) {
        if (notNullOrEmpty(issue)) {
            this.issue = issue;
        }
    }

    /**
     * Restrict the search to reports filed on or later than this date.
     * @param minDate Earliest date of reports to search for.
     */
    public void setMinDate(Date minDate) {
        this.minDate = minDate;
    }

    /**
     * Restrict the search to reports filed on or earlier than this date.
     * @param maxDate Latest date of reports to search for.
     */
    public void setMaxDate(Date maxDate) {
        this.maxDate = maxDate;
    }

    /**
     * Restrict the search to reports filed by the user with the given username.
     * @param username Username to search for.
     */
    public void setUsername(String username) {
        if (notNullOrEmpty(username)) {
            this.username = username;
        }
    }

    /**
     * Restrict the search to reports filed about the work with the given ID.
     * @param workID Work ID to search for.
     */
    public void setWorkID(int workID) {
        if (workID > 0) {
            this.workID = workID;
        }
    }

    /**
     * Tests whether a string is null, empty, or whitespace.
     * @param s String to test
     * @return True if the string is not null, empty, or whitespace.
     */
    private boolean notNullOrEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }

    /**
     * Creates and loads the parameters of a prepared statement representing the current selection conditions.
     * @param c Database connection through which to create the statement. Should not be closed.
     * @return A PreparedStatement representing the current selection conditions, which can then be executed.
     * @throws SQLException if the connection is closed or a database access error occurs.
     */
    public PreparedStatement toPreparedStatement(Connection c) throws SQLException {
        assert(!c.isClosed());

        // Create a prepared statement, then set the values separately, to prevent SQL injection
        PreparedStatement statement = c.prepareStatement(generatePreparedStatementSQL());
        setPlaceholders(statement);

        return statement;
    }

    private String generatePreparedStatementSQL() {
        String sql = "SELECT REPORTID, REPORT.REASON, DESCRIPTION, TIMESTAMP, USERNAME, WORKID, ISSUE" +
                " FROM REPORT, RI WHERE REPORT.REASON = RI.REASON";

        if (reportID > 0) {
            sql += " AND REPORT.REPORTID = ?";
        }

        if (reason != null) {
            sql += " AND REPORT.REASON = ?";
        }

        if (issue != null) {
            sql += " AND RI.ISSUE = ?";
        }

        if (minDate != null) {
            sql += " AND REPORT.TIMESTAMP >= ?";
        }

        if (maxDate != null) {
            sql += " AND REPORT.TIMESTAMP <= ?";
        }

        if (username != null) {
            sql += " AND REPORT.USERNAME = ?";
        }

        if (workID > 0) {
            sql += " AND REPORT.WORKID = ?";
        }

        return sql;
    }

    private void setPlaceholders(PreparedStatement statement) throws SQLException {
        int counter = 1;

        if (reportID > 0) {
            statement.setInt(counter, reportID);
            counter++;
        }

        if (reason != null) {
            statement.setString(counter, reason);
            counter++;
        }

        if (issue != null) {
            statement.setString(counter, issue);
            counter++;
        }

        if (minDate != null) {
            statement.setDate(counter, minDate);
            counter++;
        }

        if (maxDate != null) {
            statement.setDate(counter, maxDate);
            counter++;
        }

        if (username != null) {
            statement.setString(counter, username);
            counter++;
        }

        if (workID > 0) {
            statement.setInt(counter, workID);
        }
    }

    /**
     * Creates a description of the current selection conditions, formatted in HTML.
     * @return An HTML string describing the current selection conditions.
     */
    public String toHtml() {
        String s = "<ul>";

        if (reportID > 0) {
            s += "<li>Report ID = " + reportID + "</li>\n";
        }

        if (reason != null) {
            s += "<li>Report reason = \"" + reason + "\"</li>\n";
        }

        if (issue != null) {
            s += "<li>Report issue = \"" + issue + "\"</li>\n";
        }

        if (minDate != null) {
            s += "<li>Report date after \"" + minDate + "\"</li>\n";
        }

        if (maxDate != null) {
            s += "<li>Report date before \"" + maxDate + "\"</li>\n";
        }

        if (username != null) {
            s += "<li>Report submitted by \"" + username + "\"</li>\n";
        }

        if (workID > 0) {
            s += "<li>ID of reported work = " + workID + "</li>\n";
        }

        s += "</ul>";

        return s;
    }
}
