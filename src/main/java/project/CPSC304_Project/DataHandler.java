package project.CPSC304_Project;

import oracle.jdbc.proxy.annotation.Pre;
import project.CPSC304_Project.exception.DBOperationException;
import project.CPSC304_Project.model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * A class that handles connecting to and querying the database.
 *
 * It contains static methods to query the database, which act through a single Connection belonging to this class.
 * The connection should be established when the application servlets are initialized, and closed after all servlets are destroyed.
 *
 * We have chosen to use a single connection to improve the speed of fetching information from the database. Since our
 * website runs locally, and we expect to send it one request at a time, we do not expect concurrency-related issues
 * related to this implementation to arise.
 */
public class DataHandler {
    // TODO: THIS VERSION OF THE STRING IS FOR SSH TUNNELLING THROUGH INTELLIJ
    private static final String ORACLE_URL = "jdbc:oracle:thin:@localhost:1522:stu";
    private static final String USERNAME = "ora_zifgu";     // use your own login info
    private static final String PASSWORD = "a39585740";

    private static Connection connection = null;

    /**
     * Establishes a connection to the database that should remain open until closeConnection() is called.
     * You should connect before calling any of2 the other methods.
     * @throws SQLException if a database access error occurs
     */
    public static void connect() throws SQLException {
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

            connection = DriverManager.getConnection(ORACLE_URL, USERNAME, PASSWORD);
            connection.setAutoCommit(false);

            System.out.println("Connected to database...");
            System.out.println(connection);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Returns the internal connection for access by other pages. See DataHandler class for explanation of the safety
     * of a single connection.
     * @return The static internal connection used by the DataHandler. DO NOT CLOSE THIS CONNECTION WHEN YOU ARE FINISHED
     *          WITH IT. IT IS NEEDED BY OTHER PAGES.
     */
    public static Connection getConnection() {
        return connection;
    }

    /**
     * Performs rollback on the connection. Call it when insert/update/delete statements cause an error before they can be committed.
     */
    private static void rollbackConnection() {
        if (connection != null) {
            try {
                connection.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Returns the information of the user with the given credentials.
     * @param username Username to search for
     * @param password Password corresponding to username
     * @return a SiteUser object containing the user's data (if username and password matches) or null (if no match)
     * @throws SQLException
     */
    public static SiteUser queryUser(String username, String password) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("SELECT * FROM SITEUSER WHERE USERNAME = ? AND PASSWORD = ?");
        statement.setString(1, username);
        statement.setString(2, password);

        ResultSet rs = statement.executeQuery();

        SiteUser foundUser = null;

        if (rs.next()) {
            String uname = rs.getString(1);
            String pass = rs.getString(2);
            String email = rs.getString(3);
            boolean moderator = rs.getInt(4) == 1;

            foundUser = new SiteUser(uname, pass, email, moderator);
        }

        rs.close();
        statement.close();

        return foundUser;
    }

    /**
     * Inserts a user in the database.
     * @param username Username to insert (<= 20 chars)
     * @param password Password to insert (<= 20 chars)
     * @param email Email to insert (<= 256 chars)
     * @param isModerator True if the new user is a moderator
     * @return The number of rows modified by the insert statement (expected 1)
     * @throws DBOperationException if, when trying to insert the data specifically, an error (such as duplicate key error) occurs
     * @throws SQLException if a different database error occurs
     */
    public static int insertUser(String username, String password, String email, boolean isModerator) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO SITEUSER(USERNAME, PASSWORD, EMAILADDRESS, ISMODERATOR)" +
                " VALUES (?, ?, ?, ?)");

        statement.setString(1, username);
        statement.setString(2, password);
        statement.setString(3, email);
        statement.setInt(4, isModerator ? 1 : 0);

        int rowsAffected = executeInsert(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Deletes a user from the database.
     * @param username Username of the user to delete
     * @return The number of rows modified by the delete statement (expected 1)
     * @throws SQLException
     */
    public static int deleteUser(String username) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("DELETE FROM SITEUSER WHERE USERNAME = ?");

        statement.setString(1, username);

        int rowsAffected = executeDelete(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Inserts a work in the database.
     * @param title Work title to insert (<= 256 chars)
     * @param description Work description to insert (<= 1250 chars)
     * @param author Author's username to insert (<= 256 chars)
     * @param workType Type of work to insert (== 7 chars)
     * @return The number of rows modified by the insert statement (expected 1)
     * @throws DBOperationException if, when trying to insert the data specifically, an error (such as duplicate key error) occurs
     * @throws SQLException if a different database error occurs
     */
    public static int insertWork(String title, String description, String author, String workType) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement insertStatement = connection.prepareStatement("INSERT INTO WORK(WORKID, TITLE, DESCRIPTION, AUTHOR, TIMESTAMP, WORKTYPE)" +
                " VALUES (DEFAULT, ?, ?, ?, ?, ?)");

        insertStatement.setString(1, title);
        insertStatement.setString(2, description);
        insertStatement.setString(3, author);
        long unconvertedDate = System.currentTimeMillis();
        java.sql.Date convertedDate = new java.sql.Date(unconvertedDate);
        insertStatement.setDate(4, convertedDate);
        insertStatement.setString(5, workType);

        executeInsert(insertStatement);
        insertStatement.close();

        PreparedStatement selectStatement = connection.prepareStatement("SELECT WORKID " +
                "FROM WORK " +
                "WHERE WORKID = (SELECT MAX(WORKID) FROM WORK)");

        ResultSet result = selectStatement.executeQuery();
        result.next();
        int currentWorkID = result.getInt(1);
        selectStatement.close();

        return currentWorkID;
    }

    /**
     * Inserts a digital work in the database.
     * @param title Work title to insert (<= 256 chars)
     * @param description Work description to insert (<= 1250 chars)
     * @param author Author's username to insert (<= 256 chars)
     * @param workType Type of work to insert (== 7 chars)
     * @param imageFile URL of the image to insert (<= 256 chars)
     * @return The number of rows modified by the insert statement (expected 1)
     * @throws DBOperationException if, when trying to insert the data specifically, an error (such as duplicate key error) occurs
     * @throws SQLException if a different database error occurs
     */
    public static int insertDigitalWork(String title, String description, String author, String workType, String imageFile) throws SQLException, DBOperationException {
        assert(connection != null);
        int workID = insertWork(title, description, author, workType);

        PreparedStatement insertStatement = connection.prepareStatement("INSERT INTO DIGITALWORK(WORKID, IMAGEFILE)" +
                " VALUES (?, ?)");

        insertStatement.setInt(1, workID);
        insertStatement.setString(2, imageFile);

        int affectedRows = executeInsert(insertStatement);
        insertStatement.close();

        return workID;
    }

    /**
     * Inserts a written work in the database.
     * @param title Work title to insert (<= 256 chars)
     * @param description Work description to insert (<= 1250 chars)
     * @param author Author's username to insert (<= 256 chars)
     * @param workType Type of work to insert (== 7 chars)
     * @param wordCount Word count of the work to insert (<= 21 chars)
     * @param language Language the work is written in to insert (<= 25 chars)
     * @param textFile Content of the work to insert (<= 4000 chars)
     * @return The number of rows modified by the insert statement (expected 1)
     * @throws DBOperationException if, when trying to insert the data specifically, an error (such as duplicate key error) occurs
     * @throws SQLException if a different database error occurs
     */
    public static int insertWrittenWork(String title, String description, String author, String workType,
                                        int wordCount, String language, String textFile) throws SQLException, DBOperationException {
        assert(connection != null);
        int workID = insertWork(title, description, author, workType);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO WRITTENWORK(WORKID, CHAPTERCOUNT, WORDCOUNT, LANGUAGE)" +
                " VALUES (?, ?, ?, ?)");

        statement.setInt(1, workID);
        statement.setInt(2, 0);
        statement.setInt(3, 0);
        statement.setString(4, language);

        executeInsert(statement);
        statement.close();

        insertChapter(workID, 1, textFile, wordCount);

        return workID;
    }

    /**
     * Inserts a written work in the database.
     * @param workID ID of Work to add a Chapter to (<= 256 chars)
     * @param chapterNumber Chapter number to create a chapter for (<= 1250 chars)
     * @param textFile Content of the work to insert (<= 4000 chars)
     * @param wordCount Word count of the work to insert (<= 21 chars)
     * @return The number of rows modified by the insert statement (expected 1)
     * @throws DBOperationException if, when trying to insert the data specifically, an error (such as duplicate key error) occurs
     * @throws SQLException if a different database error occurs
     */
    public static int insertChapter(int workID, int chapterNumber, String textFile, int wordCount) throws SQLException, DBOperationException {
        assert(connection != null);
        PreparedStatement statement = connection.prepareStatement("INSERT INTO CHAPTER(WORKID, CHAPTERNUMBER, TEXTFILE)" +
                " VALUES (?, ?, ?)");

        statement.setInt(1, workID);
        statement.setInt(2, chapterNumber);
        statement.setString(3, textFile);

        executeInsert(statement);
        statement.close();

        PreparedStatement totalWordCountQuery = connection.prepareStatement("SELECT WORDCOUNT FROM WRITTENWORK WHERE WORKID = " + workID);
        ResultSet result = totalWordCountQuery.executeQuery();
        if (!result.next()) {
            throw new DBOperationException();
        }
        int totalWordCount = result.getInt(1);
        int newWordCount = wordCount + totalWordCount;

        insertWCRT(newWordCount);

        PreparedStatement newWordCountQuery = connection.prepareStatement("UPDATE WRITTENWORK " +
                "SET WORDCOUNT = " + newWordCount + ", CHAPTERCOUNT = (CHAPTERCOUNT + 1) " +
                "WHERE WORKID = " + workID);

        executeInsert(newWordCountQuery);
        newWordCountQuery.close();

        return workID;
    }

    private static int insertWCRT(int wordCount) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement checkIfWCRTWorks = connection.prepareStatement("SELECT WORDCOUNT " +
                "FROM WCRT " +
                "WHERE WORDCOUNT = " + wordCount);

        ResultSet result = checkIfWCRTWorks.executeQuery();

        if (!result.next()) {
            PreparedStatement insertStatement = connection.prepareStatement("INSERT INTO WCRT(WORDCOUNT, READINGTIME)" +
                    " VALUES (?, ?)");

            insertStatement.setInt(1, wordCount);
            insertStatement.setInt(2, calculateReadingTime(wordCount));

            executeInsert(insertStatement);
            insertStatement.close();
        }

        return wordCount;
    }

    private static int calculateReadingTime(int wordCount) {
        int readingTime = wordCount / 300;

        if (readingTime < 5) {
            readingTime = 5;
        }

        return readingTime;
    }

    public static ResultSet getFilteredWorks(String filter, String filterType) throws SQLException {
        assert(connection != null);
        String query;

        switch (filterType) {
            case "fandom":
                query = "SELECT * FROM WORK " +
                        "WHERE WORKID IN ( " +
                        "SELECT WORKID " +
                        "FROM BELONGSTO " +
                        "WHERE FANDOMNAME = '" + filter + "')";
                break;

            case "relationship":
                query = "SELECT * FROM WORK " +
                        "WHERE WORKID IN ( " +
                        "SELECT WORKID " +
                        "FROM INVOLVES " +
                        "WHERE PAIRING = '" + filter + "')";
                break;

            case "character":
                String[] id = filter.split(" \\(");
                String name = id[0];
                String fandom = id[1].substring(0, id[1].length() - 1);

                System.out.println(name);
                System.out.println(fandom);


                query = "SELECT * FROM WORK " +
                        "WHERE WORKID IN ( " +
                        "SELECT WORKID " +
                        "FROM CONTAINS " +
                        "WHERE CHARACTERNAME = '" + name + "' AND FANDOMNAME = '" + fandom + "')";
                break;

            case "author":
                query = "SELECT * FROM WORK " +
                        "WHERE AUTHOR = '" + filter + "'";
                break;

            default:
                query = "SELECT * FROM WORK";
                break;
        }

        query = query + " ORDER BY TIMESTAMP DESC";

        PreparedStatement statement = connection.prepareStatement(query);
        return statement.executeQuery();
    }

    public static ResultSet getWork(int workID, String workType) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement;
        ResultSet result;
        if (workType.equals("digital")) {
            statement = connection.prepareStatement("SELECT WORK.WORKID, TITLE, DESCRIPTION, AUTHOR, WORKTYPE, IMAGEFILE " +
                    "FROM WORK, DIGITALWORK " +
                    "WHERE WORK.WORKID = " + workID + " AND WORK.WORKID = DIGITALWORK.WORKID");
            result = statement.executeQuery();
        } else if (workType.equals("written")) {
            statement = connection.prepareStatement("SELECT WORK.WORKID, TITLE, DESCRIPTION, AUTHOR, WORKTYPE, WORDCOUNT, LANGUAGE, CHAPTERCOUNT " +
                    "FROM WORK, WRITTENWORK " +
                    "WHERE WORK.WORKID = " + workID + " AND WORK.WORKID = WRITTENWORK.WORKID");
            result = statement.executeQuery();
        } else {
            throw new DBOperationException();
        }

        return result;
    }

    public static ResultSet getAllChapters(int workID) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("SELECT CHAPTERNUMBER, TEXTFILE " +
                "FROM CHAPTER " +
                "WHERE WORKID = " + workID);
        return statement.executeQuery();
    }

    public static boolean checkIfChapterExists(int workID, int chapterNum) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("SELECT CHAPTERNUMBER FROM CHAPTER " +
                "WHERE WORKID = ? AND CHAPTERNUMBER = ?");

        statement.setInt(1, workID);
        statement.setInt(2, chapterNum);

        ResultSet result = statement.executeQuery();
        boolean isTrue = result.next();
        result.close();
        statement.close();

        return isTrue;
    }

    public static int updateWork(int workID, String title, String description) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement insertStatement = connection.prepareStatement("UPDATE WORK " +
                "SET TITLE = ?, DESCRIPTION = ? " +
                "WHERE WORKID = ?");

        insertStatement.setString(1, title);
        insertStatement.setString(2, description);
        insertStatement.setInt(3, workID);

        executeInsert(insertStatement);
        insertStatement.close();

        return workID;
    }

    public static int updateDigitalWork(int workID, String title, String description, String imageFile) throws SQLException, DBOperationException {
        assert(connection != null);
        updateWork(workID, title, description);

        PreparedStatement insertStatement = connection.prepareStatement("UPDATE DIGITALWORK " +
                "SET IMAGEFILE = ? " +
                "WHERE WORKID = ?");

        insertStatement.setString(1, imageFile);
        insertStatement.setInt(2, workID);

        executeInsert(insertStatement);
        insertStatement.close();

        return workID;
    }

    public static int updateWrittenWork(int workID, String title, String description, int wordCount, String language, int chapterNum, String textFile) throws SQLException, DBOperationException {
        assert(connection != null);
        updateWork(workID, title, description);
        updateChapter(workID, chapterNum, textFile);
        insertWCRT(wordCount);

        PreparedStatement statement = connection.prepareStatement("UPDATE WRITTENWORK " +
                "SET WORDCOUNT = ?, LANGUAGE = ? " +
                "WHERE WORKID = ?");

        statement.setInt(1, wordCount);
        statement.setString(2, language);
        statement.setInt(3, workID);

        executeInsert(statement);
        statement.close();

        return workID;
    }

    public static int updateChapter(int workID, int chapterNumber, String textFile) throws SQLException, DBOperationException {
        assert(connection != null);
        PreparedStatement statement = connection.prepareStatement("UPDATE CHAPTER " +
                "SET TEXTFILE = ? " +
                "WHERE WORKID = ? AND CHAPTERNUMBER = ?");

        statement.setString(1, textFile);
        statement.setInt(2, workID);
        statement.setInt(3, chapterNumber);

        executeInsert(statement);
        statement.close();

        return workID;
    }

    public static int deleteWork(int workID) throws SQLException, DBOperationException {
        assert(connection != null);
        String query = "DELETE FROM WORK WHERE WORKID = " + workID;
        PreparedStatement statement = connection.prepareStatement(query);
        int affectedRows = executeDelete(statement);
        statement.close();

        return affectedRows;
    }

    public static ResultSet getFandoms() throws SQLException {
        assert(connection != null);

        String query = "SELECT * FROM FANDOM";
        PreparedStatement statement = connection.prepareStatement(query);
        return statement.executeQuery();
    }

    public static ResultSet getRelationships() throws SQLException {
        assert(connection != null);

        String query = "SELECT PAIRINGNAME FROM RELATIONSHIP";
        PreparedStatement statement = connection.prepareStatement(query);
        return statement.executeQuery();
    }

    public static ResultSet getCharacters() throws SQLException {
        assert(connection != null);

        String query = "SELECT * FROM CHARACTER";
        PreparedStatement statement = connection.prepareStatement(query);
        return statement.executeQuery();
    }
    /**
     * Returns all likes of the given user.
     * @param username Username to search for.
     * @return A list of the user's likes (this list is never null).
     * @throws SQLException if a database error occurs.
     */
    public static List<LikeInfo> getUserLikes(String username) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement(
                "SELECT WORK.WORKID, WORK.TITLE, WORK.DESCRIPTION, WORK.AUTHOR, WORK.TIMESTAMP, LIKES.TIMESTAMP, WORK.WORKTYPE FROM WORK " +
                    "INNER JOIN LIKES ON LIKES.WORKID = WORK.WORKID " +
                    "WHERE LIKES.USERNAME = ?");

        statement.setString(1, username);

        ResultSet rs = statement.executeQuery();

        List<LikeInfo> likedByUser = new ArrayList<>();
        while (rs.next()) {
            int workID = rs.getInt(1);
            String title = rs.getString(2);
            String description = rs.getString(3);
            String author = rs.getString(4);
            Date pubDate = rs.getDate(5);
            Date likeDate = rs.getDate(6);
            String workType = rs.getString(7);

            LikeInfo likeInfo = new LikeInfo(new Work(workID, title, description, author, pubDate, workType), likeDate);
            likedByUser.add(likeInfo);
        }

        rs.close();
        statement.close();

        return likedByUser;
    }

    /**
     * Returns all notes (comments) of the given user.
     * @param username Username to search for.
     * @return A list of the user's comments (this list is never null).
     * @throws SQLException if a database error occurs.
     */
    public static List<NoteInfo> getUserNotes(String username) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement(
                "SELECT WORK.WORKID, WORK.TITLE, WORK.DESCRIPTION, WORK.AUTHOR, WORK.TIMESTAMP, NOTE.TEXTCONTENT, NOTE.TIMESTAMP, WORK.WORKTYPE FROM WORK " +
                        "INNER JOIN NOTE ON NOTE.WORKID = WORK.WORKID " +
                        "WHERE NOTE.USERNAME = ?");

        statement.setString(1, username);

        ResultSet rs = statement.executeQuery();

        List<NoteInfo> userNotes = new ArrayList<>();
        while (rs.next()) {
            int work = rs.getInt(1);
            String title = rs.getString(2);
            String description = rs.getString(3);
            String author = rs.getString(4);
            Date pubDate = rs.getDate(5);
            String noteContent = rs.getString(6);
            Date noteDate = rs.getDate(7);
            String workType = rs.getString(8);

            NoteInfo noteInfo = new NoteInfo(new Work(work, title, description, author, pubDate, workType), noteContent, noteDate);
            userNotes.add(noteInfo);
        }

        rs.close();
        statement.close();

        return userNotes;
    }

    /**
     * Returns all bookmarks of the given user, with optional filtering for bookmarks visible to the public.
     * @param username Username to search for.
     * @param publicOnly True if the returned list should contain only public bookmarks.
     * @return A list of the user's bookmarks matching the search criteria (this list is never null).
     * @throws SQLException if a database error occurs.
     */
    public static List<BookmarkInfo> getUserBookmarks(String username, boolean publicOnly) throws SQLException{
        assert(connection != null);

        String filterPublic = publicOnly ? " AND B.ISPUBLIC = 1" : "";

        PreparedStatement statement = connection.prepareStatement(
                "SELECT W.WORKID, W.TITLE, W.DESCRIPTION, W.AUTHOR, W.TIMESTAMP, B.NOTE, B.ISPUBLIC, B.TIMESTAMP, W.WORKTYPE FROM WORK W " +
                        "JOIN BOOKMARK B on W.WORKID = B.WORKID " +
                        "WHERE B.USERNAME = ?" + filterPublic);

        statement.setString(1, username);

        ResultSet rs = statement.executeQuery();

        List<BookmarkInfo> userNotes = new ArrayList<>();
        while (rs.next()) {
            int work = rs.getInt(1);
            String title = rs.getString(2);
            String description = rs.getString(3);
            String author = rs.getString(4);
            Date pubDate = rs.getDate(5);
            String text = rs.getString(6);
            boolean isPublic = rs.getInt(7) == 1;
            Date date = rs.getDate(8);
            String workType = rs.getString(9);

            BookmarkInfo bookmarkInfo = new BookmarkInfo(new Work(work, title, description, author, pubDate, workType), text, isPublic, date);
            userNotes.add(bookmarkInfo);
        }

        rs.close();
        statement.close();

        return userNotes;
    }

    /**
     * Records that a user liked a work.
     * @param username Username to insert (must be a valid, existing user)
     * @param workID Work ID to insert (must be a valid, existing work)
     * @param date Date on which the work was liked.
     * @return The number of rows affected by the insert operation (expected 1)
     * @throws DBOperationException if an error occurs while trying to insert the data (such as duplicate key error, or parent key not found)
     * @throws SQLException if a database error occurs at any other point
     */
    public static int addLike(String username, int workID, Date date) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO LIKES(username, workid, timestamp) " +
                "VALUES (?, ?, ?)");

        statement.setString(1, username);
        statement.setInt(2, workID);
        statement.setDate(3, date);

        int rowsAffected = executeInsert(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Records a note (comment) left by a user on a work.
     * @param username Username to insert (must be a valid, existing user)
     * @param workID Work ID to insert (must be a valid, existing work)
     * @param date Date on which the note was posted.
     * @param text Text of the note (<= 4000 characters)
     * @return The number of rows affected by the insert operation (expected 1)
     * @throws DBOperationException  if an error occurs while trying to insert the data (such as duplicate key error, or parent key not found)
     * @throws SQLException if a database error occurs at any other point
     */
    public static int addNote(String username, int workID, Date date, String text) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO NOTE(USERNAME, WORKID, TIMESTAMP, TEXTCONTENT) " +
                "VALUES (?, ?, ?, ?)");

        statement.setString(1, username);
        statement.setInt(2, workID);
        statement.setDate(3, date);
        statement.setString(4, text);

        int rowsAffected = executeInsert(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Records that a user bookmarked a work.
     * @param username Username to insert (must be a valid, existing user)
     * @param workID Work ID to insert (must be a valid, existing work)
     * @param date Date on which the bookmark was saved.
     * @param note Text of the bookmark (optional,<= 256 characters)
     * @param isPublic True if the new bookmark should be visible to the public.
     * @return The number of rows affected by the insert operation (expected 1)
     * @throws DBOperationException  if an error occurs while trying to insert the data (such as duplicate key error, or parent key not found)
     * @throws SQLException if a database error occurs at any other point
     */
    public static int addBookmark(String username, int workID, Date date, String note, boolean isPublic) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO BOOKMARK(USERNAME, WORKID, TIMESTAMP, NOTE, ISPUBLIC) " +
                "VALUES (?, ?, ?, ?, ?)");

        statement.setString(1, username);
        statement.setInt(2, workID);
        statement.setDate(3, date);
        statement.setString(4, note);
        statement.setInt(5, isPublic ? 1 : 0);

        int rowsAffected = executeInsert(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Records that a user reported a work.
     * @param username Username of the report author (must be a valid, existing user)
     * @param workID Work ID of the work being reported (must be a valid, existing work)
     * @param date Date on which the report was filed.
     * @param description Text of the report (optional, <= 1250 characters)
     * @param reason A string describing the reason for the report. Valid values: 'Malicious or phishing attempt', 'Work has been posted before',
     *                                                    'Work contains spam', 'Tags are unrelated to work', 'Disrespectful or offensive',
     *                                                    'Includes private information', 'Targeted harassment', 'Directs hate on a protected group',
     *                                                    'Threatening or encouraging harm'
     * @return The number of rows affected by the insert operation (expected 1)
     * @throws DBOperationException  if an error occurs while trying to insert the data (such as duplicate key error, or parent key not found)
     * @throws SQLException if a database error occurs at any other point
     */
    public static int addReport(String username, int workID, Date date, String description, String reason) throws SQLException, DBOperationException {
        assert(connection != null);

        PreparedStatement statement = connection.prepareStatement("INSERT INTO REPORT(USERNAME, WORKID, TIMESTAMP, DESCRIPTION, REASON) " +
                "VALUES (?, ?, ?, ?, ?)");

        statement.setString(1, username);
        statement.setInt(2, workID);
        statement.setDate(3, date);
        statement.setString(4, description);
        statement.setString(5, reason);

        int rowsAffected = executeInsert(statement);
        statement.close();

        return rowsAffected;
    }

    private static int executeInsert(PreparedStatement statement) throws DBOperationException {
        int rowsAffected = 0;
        try {
            rowsAffected = statement.executeUpdate();
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            rollbackConnection();

            throw new DBOperationException();
        }

        return rowsAffected;
    }

    /**
     * Searches over all reports in the database, filtered by the given search conditions.
     * @param conditions Object representing the search conditions to apply.
     * @return A list of all reports matching the search conditions. (this list is never null)
     * @throws SQLException if a database error occurs.
     */
    public static List<ReportInfo> getReports(ReportSelectionConditions conditions) throws SQLException {
        assert(connection != null);

        PreparedStatement statement = conditions.toPreparedStatement(connection);

        ResultSet rs = statement.executeQuery();

        List<ReportInfo> reports = new ArrayList<>();

        while (rs.next()) {
            int reportID = rs.getInt(1);
            String reason = rs.getString(2);
            String description = rs.getString(3);
            Date date = rs.getDate(4);
            String username = rs.getString(5);
            int workID = rs.getInt(6);
            String issue = rs.getString(7);

            reports.add(new ReportInfo(reportID, reason, issue, description, date, username, workID));
        }

        return reports;
    }

    /**
     * Approves a report, i.e. deletes the work being reported. (This will delete all reports, likes, notes, etc that involve that work).
     * @param reportID ID of report to approve.
     * @return The number of rows affected by the delete operation (expected 1)
     * @throws SQLException if a database error occurs
     */
    public static int approveReport(int reportID) throws SQLException {
        PreparedStatement statement = connection.prepareStatement("DELETE FROM WORK WHERE WORK.WORKID = (" +
                "SELECT REPORT.WORKID FROM REPORT WHERE REPORTID = ?)");

        statement.setInt(1, reportID);

        int rowsAffected = executeDelete(statement);
        statement.close();

        return rowsAffected;
    }

    /**
     * Denies a report. The report alone will be deleted from the database.
     * @param reportID ID of report to delete.
     * @return The number of rows affected by the delete operation (expected 1)
     * @throws SQLException if a database error occurs
     */
    public static int denyReport(int reportID) throws SQLException {
        PreparedStatement statement = connection.prepareStatement("DELETE FROM REPORT WHERE REPORTID = ?");

        statement.setInt(1, reportID);

        int rowsAffected = executeDelete(statement);
        statement.close();

        return rowsAffected;
    }

    private static int executeDelete(PreparedStatement statement) {
        int rowsAffected = 0;
        try {
            rowsAffected = statement.executeUpdate();
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            rollbackConnection();

            rowsAffected = 0;
        }

        return rowsAffected;
    }

    /**
     * Closes the connection. You should call this method only after you finish using the DataHandler.
     * @throws SQLException if a database error occurs, or the connection was already closed.
     */
    public static void closeConnection() throws SQLException {
        if (connection != null) {
            connection.rollback();      // abandon uncommitted changes
            connection.close();
            connection = null;

            System.out.println("Closed database connection...");
            System.out.println(connection);
        }
    }
}
