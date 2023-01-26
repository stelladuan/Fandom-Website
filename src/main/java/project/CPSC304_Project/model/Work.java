package project.CPSC304_Project.model;

import java.sql.Date;

/**
 * Represents a work published to the site.
 */
public class Work {
    private int id;
    private String title;
    private String description;
    private String author;
    private Date publishDate;
    private String workType;

    public Work(int id, String title, String description, String author, Date publishDate, String workType) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.author = author;
        this.publishDate = publishDate;
        this.workType = workType;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getAuthor() {
        return author;
    }

    public Date getPublishDate() {
        return publishDate;
    }

    public String getWorkType() {
        return workType;
    }
}
