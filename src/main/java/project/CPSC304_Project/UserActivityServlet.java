package project.CPSC304_Project;

import project.CPSC304_Project.model.BookmarkInfo;
import project.CPSC304_Project.model.LikeInfo;
import project.CPSC304_Project.model.NoteInfo;
import project.CPSC304_Project.model.Work;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet which handles displaying user activity (likes, notes, and bookmarks).
 */
@WebServlet(name = "UserActivityServlet", value = "/UserActivityServlet")
public class UserActivityServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("search_username");
        String activity = request.getParameter("activity_type");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String thisUser = null;
        HttpSession session = request.getSession();
        if (session.getAttribute("username") != null) {
            thisUser = session.getAttribute("username").toString();
        }

        if (username != null && activity != null) {

            out.println("<!DOCTYPE html>\n" +
                        "<html>\n" +
                        "<head>\n" +
                        "    <title>Search results</title>\n" +
                        "    <style>" +
                        "       th, td {" +
                        "           border-bottom: 1px solid;" +
                        "       }\n" +
                        "    </style>\n" +
                        "</head>\n" +
                        "<body>");

            out.println("<h1>View " + activity + " of user " + username + ":</h1>");

            switch (activity) {
                case "Likes":
                    showLikes(username, out);
                    break;
                case "Notes":
                    showNotes(username, out);
                    break;
                case "Bookmarks":
                    // If you're searching for your own bookmarks, show the private ones as well.
                    if (thisUser != null && thisUser.equals(username)) {
                        showBookmarks(thisUser, out, false);
                    } else {
                        showBookmarks(username, out, true);
                    }
                    break;
            }

            out.println("<br> <br> <a href=\"user_activity.jsp\">Search again</a>\n" +
                        "</body>\n" +
                        "</html>");
        }
    }

    private void showLikes(String username, PrintWriter out) {
        try {
            List<LikeInfo> likes = DataHandler.getUserLikes(username);

            if (likes.size() > 0) {
                out.println("<table>");

                for(LikeInfo like : likes) {
                    showLike(like, username, out);
                }

                out.println("</table>");
            } else {
                out.println(username + " has not liked any works.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void showLike(LikeInfo like, String username, PrintWriter out) {
        out.println("<tr> <td>");
        showWork(like.getWork(), out);
        out.println("Liked by <b>" + username + "</b> on: " + like.getLikeDate());
        out.println("</td> </tr>");
    }

    private void showNotes(String username, PrintWriter out) {
        try {
            List<NoteInfo> notes = DataHandler.getUserNotes(username);

            if (notes.size() > 0) {
                out.println("<table>");

                for(NoteInfo note : notes) {
                    showNote(note, username, out);
                }

                out.println("</table>");
            } else {
                out.println(username + " has not left notes on any works.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void showNote(NoteInfo note, String username, PrintWriter out) {
        out.println("<tr> <td>");
        showWork(note.getWork(), out);
        out.println("<b>" + username + "</b> said on " + note.getNoteDate() + ":<br>" +
                "<blockquote> " + note.getText() + "</blockquote>");
        out.println("</td> </tr>");
    }

    private void showBookmarks(String username, PrintWriter out, boolean publicOnly) {
        try {
            List<BookmarkInfo> bookmarks = DataHandler.getUserBookmarks(username, publicOnly);

            if (bookmarks.size() > 0) {
                out.println("<table>");

                for(BookmarkInfo bookmark : bookmarks) {
                    showBookmark(bookmark, username, out);
                }

                out.println("</table>");
            } else {
                out.println(username + " has no public bookmarks.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    private void showBookmark(BookmarkInfo bookmark, String username, PrintWriter out) {
        out.println("<tr> <td>");
        showWork(bookmark.getWork(), out);
        out.println(
                "Bookmarked by <b>" + username + "</b> on " + bookmark.getBookmarkDate() +
                        (bookmark.getNote() == null ? "" : ":<br> <blockquote>" + bookmark.getNote() + "</blockquote>"));
        out.println("</td> </tr>");
    }

    private void showWork(Work work, PrintWriter out) {
        out.println("<p><form action=\"" + work.getWorkType() + "work.jsp\" method=\"get\">" +
                "WorkID #<input type=\"submit\" name=\"workID\" value=\"" + work.getId() + "\"></form>\n" +
                "<b><" + work.getTitle() + "></b> by <b>" + work.getAuthor() + "</b>\n" +
                "<p>Posted on " + work.getPublishDate() + "</p>\n" +
                "<blockquote>" + work.getDescription() + "</blockquote>\n" +
                "<br>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
