import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import project.CPSC304_Project.DataHandler;
import project.CPSC304_Project.exception.DBOperationException;
import project.CPSC304_Project.model.*;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test class for DataHandler.
 */
public class TestDataHandler {

    @BeforeAll
    public static void setupHandler() {
        try {
            DataHandler.connect();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @AfterAll
    public static void destroyHandler() {
        try {
            DataHandler.closeConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testQueryUser_UserExists() {
        try {
            SiteUser user = DataHandler.queryUser("user1", "password");

            assertNotNull(user);

            assertEquals("user1", user.getUsername());
            assertEquals("password", user.getPassword());
            assertEquals("pencilsharpener@gmail.com", user.getEmail());
            assertFalse(user.isModerator());
        } catch (SQLException throwables) {
            throwables.printStackTrace();
            fail();
        }
    }

    @Test
    public void testQueryUser_UserNotExists() {
        try {
            SiteUser user = DataHandler.queryUser("user200", "password");

            assertNull(user);
        } catch (SQLException e) {
            e.printStackTrace();
            fail();
        }
    }

    @Test
    public void testQueryUser_IncorrectPassword() {
        try {
            SiteUser user = DataHandler.queryUser("user1", "passwrd");

            assertNull(user);
        } catch (SQLException e) {
            e.printStackTrace();
            fail();
        }
    }

    @Test
    public void testInsertAndRemove_NewUser() {
        try {
            int rowCount = DataHandler.insertUser("testUser", "testPassword", "testUser@example.com", false);
            assertEquals(1, rowCount);
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            e.printStackTrace();
            fail("Failed to insert data!");
        }

        try {
            int rowCount = DataHandler.deleteUser("testUser");
            assertEquals(1, rowCount);
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }
    }

    @Test
    public void testInsert_UserExists() {
        try {
            DataHandler.insertUser("user1", "newPassword", "newEmail@example.com", false);
            fail("DBOperationException was not thrown!");
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            // expected a violation of Unique integrity constraint (ORA-00001 error)
        }
    }

    @Test
    public void testDelete_UserNotExists() {
        int rowCount = 0;
        try {
            rowCount = DataHandler.deleteUser("user200");
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }

        assertEquals(0, rowCount);  // expected that no such row should be found
    }

    @Test
    public void testGetUserLikes() {
        try {
            List<LikeInfo> likes = DataHandler.getUserLikes("blue123");

            assertEquals(2, likes.size());

            checkLikeInfo(likes.get(0), 1, "The Champion of Harmony", "Lorem ipsum dolor sit amet",
                    "user1", Date.valueOf("2020-05-04"), Date.valueOf("2021-02-10"));
            checkLikeInfo(likes.get(1), 3, "Blue123s Headcanons", "Sed ut perspiciatis",
                    "blue123", Date.valueOf("2021-01-31"), Date.valueOf("2021-02-10"));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }
    }

    @Test
    public void testGetUserNotes() {
        try {
            List<NoteInfo> notes = DataHandler.getUserNotes("blue123");

            assertEquals(1, notes.size());

            checkNoteInfo(notes.get(0), 3, "Blue123s Headcanons", "Sed ut perspiciatis",
                    "blue123", Date.valueOf("2021-01-31"), "I think this is spam...", Date.valueOf("2021-05-23"));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }
    }

    @Test
    public void testGetUserBookmarks_PublicOnly() {
        try {
            List<BookmarkInfo> bookmarks = DataHandler.getUserBookmarks("blue123", true);

            assertEquals(1, bookmarks.size());

            checkBookmarkInfo(bookmarks.get(0), 3, "Blue123s Headcanons", "Sed ut perspiciatis",
                    "blue123", Date.valueOf("2021-01-31"), null, true, Date.valueOf("2020-02-01"));

        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }
    }

    @Test
    public void testGetUserBookmarks_All() {
        try {
            List<BookmarkInfo> bookmarks = DataHandler.getUserBookmarks("blue123", false);

            assertEquals(2, bookmarks.size());

            checkBookmarkInfo(bookmarks.get(0), 2, "No Longer Alone", "consectetuer adipiscing elit",
                    "user1", Date.valueOf("2020-08-13"), "nice stuff", false, Date.valueOf("2020-04-14"));
            checkBookmarkInfo(bookmarks.get(1), 3, "Blue123s Headcanons", "Sed ut perspiciatis",
                    "blue123", Date.valueOf("2021-01-31"), null, true, Date.valueOf("2020-02-01"));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        }
    }


    private void checkLikeInfo(LikeInfo l, int id, String title, String description, String author, Date publishDate, Date likeDate) {
        checkWork(l.getWork(), id, title, description, author, publishDate);
        assertEquals(likeDate, l.getLikeDate());
    }

    private void checkNoteInfo(NoteInfo n, int id, String title, String description, String author, Date publishDate, String note, Date noteDate) {
        checkWork(n.getWork(), id, title, description, author, publishDate);
        assertEquals(note, n.getText());
        assertEquals(noteDate, n.getNoteDate());
    }

    private void checkBookmarkInfo(BookmarkInfo b, int id, String title, String description, String author, Date publishDate, String note, boolean isPublic, Date bookmarkDate) {
        checkWork(b.getWork(), id, title, description, author, publishDate);
        assertEquals(note, b.getNote());
        assertEquals(isPublic, b.isPublic());
        assertEquals(bookmarkDate, b.getBookmarkDate());
    }

    private void checkWork(Work w, int id, String title, String description, String author, Date publishDate) {
        assertEquals(id, w.getId());
        assertEquals(title, w.getTitle());
        assertEquals(description, w.getDescription());
        assertEquals(author, w.getAuthor());
        assertEquals(publishDate, w.getPublishDate());
    }

    @Test
    public void testAddLike_AlreadyExists() {
        try {
            DataHandler.addLike("greatwriter", 1, Date.valueOf("2020-01-01"));
            fail("DBOperationException not thrown!");
        } catch (SQLException throwables) {
            throwables.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            e.printStackTrace();

            // expected duplicate primary key error
        }
    }

    @Test
    public void testAddLike_NotExists() {
        try {
            DataHandler.addLike("greatwriter", 2, Date.valueOf("2021-03-01"));

            List<LikeInfo> newLikes = DataHandler.getUserLikes("greatwriter");

            assertTrue(testLikesContains(newLikes, 2, Date.valueOf("2021-03-01")));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            e.printStackTrace();
            fail("Not expecting DBOperationException!");
        }
    }

    private boolean testLikesContains(List<LikeInfo> newLikes, int workID, Date date) {
        for(LikeInfo like : newLikes) {
            if (like.getWork().getId() == workID && like.getLikeDate().equals(date)) {
                return true;
            }
        }
        return false;
    }

    @Test
    public void testAddNote() {
        try {
            Date date = Date.valueOf("2020-09-12");
            String text = "I keep coming back to this work because it's so great!!!! Love it!!!";
            DataHandler.addNote("greatwriter", 2, date, text);

            List<NoteInfo> newNotes = DataHandler.getUserNotes("greatwriter");

            assertTrue(testNotesContains(newNotes, 2, date, text));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            e.printStackTrace();
            fail("Not expecting DBOperationException!");
        }
    }

    private boolean testNotesContains(List<NoteInfo> newNotes, int workID, Date date, String text) {
        for (NoteInfo note : newNotes) {
            if (note.getWork().getId() == workID && note.getNoteDate().equals(date) && note.getText().equals(text)) {
                return true;
            }
        }
        return false;
    }

    @Test
    public void testAddBookmark() {
        try {
            Date date = Date.valueOf("2020-06-24");
            String note = "Fanworks I absolutely have to revisit";
            DataHandler.addBookmark("greatwriter", 1, date, note, true);

            List<BookmarkInfo> bookmarks = DataHandler.getUserBookmarks("greatwriter", true);

            assertTrue(testBookmarksContains(bookmarks, 1, date, note));
        } catch (SQLException e) {
            e.printStackTrace();
            fail("Not expecting SQLException!");
        } catch (DBOperationException e) {
            e.printStackTrace();
            fail("Not expecting DBOperationException!");
        }
    }

    private boolean testBookmarksContains(List<BookmarkInfo> bookmarks, int workID, Date date, String note) {
        for (BookmarkInfo bookmark : bookmarks) {
            if (bookmark.getWork().getId() == workID && bookmark.getBookmarkDate().equals(date) && bookmark.getNote().equals(note)) {
                return true;
            }
        }

        return false;
    }
}
