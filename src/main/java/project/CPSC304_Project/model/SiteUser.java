package project.CPSC304_Project.model;

/**
 * Represents a user of the site.
 */
public class SiteUser {
    private String username;
    private String password;
    private String email;
    private boolean moderator;

    public SiteUser(String username, String password, String email, boolean isModerator) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.moderator = isModerator;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public boolean isModerator() {
        return moderator;
    }
}
