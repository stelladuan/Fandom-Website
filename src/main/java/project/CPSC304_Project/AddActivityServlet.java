package project.CPSC304_Project;

import project.CPSC304_Project.exception.DBOperationException;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet(name = "AddActivityServlet", value = "/AddActivityServlet")
public class AddActivityServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String username;
        if (session.getAttribute("username") != null) {
            username = session.getAttribute("username").toString();
        } else {
            sendBackMessage("Please log in to interact with this work.", request, response);
            return;
        }

        int workID;
        try {
            workID = Integer.parseInt(request.getParameter("workID"));
        } catch (NumberFormatException e) {
            sendBackMessage("Sorry, the requested work was not found.", request, response);
            return;
        }

        Date currentDate = new Date(new java.util.Date().getTime());

        String activityType = request.getParameter("activityType");
        if (activityType != null) {
            try {
                switch (activityType) {
                    case "Like":
                        addLike(username, workID, currentDate, request, response);
                        break;
                    case "Note":
                        addNote(username, workID, currentDate, request, response);
                        break;
                    case "Bookmark":
                        addBookmark(username, workID, currentDate, request, response);
                        break;
                    case "Report":
                        addReport(username, workID, currentDate, request, response);
                        break;
                }
            } catch (SQLException | DBOperationException e) {
                sendBackMessage("Sorry, something went wrong. Please try again later.", request, response);
            }
        }
    }

    private void addLike(String username, int workID, Date date, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, SQLException {
        try {
            DataHandler.addLike(username, workID, date);
            sendBackMessage("Thank you for leaving a like!", request, response);
        } catch (DBOperationException e) {
            e.printStackTrace();
            sendBackMessage("We think you have already left a like on this work.", request, response);
        }
    }

    private void addNote(String username, int workID, Date date, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, SQLException, DBOperationException {
        String text = request.getParameter("noteText");
        if (text == null) {
            sendBackMessage("Could not post your note because it contains no text.", request, response);
            return;
        }

        DataHandler.addNote(username, workID, date, text);
        sendBackMessage("Thank you for leaving a note!", request, response);
    }

    private void addBookmark(String username, int workID, Date date, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, SQLException, DBOperationException {
        String note = request.getParameter("bookmarkText");
        boolean isPublic = request.getParameter("isPublic") != null;

        DataHandler.addBookmark(username, workID, date, note, isPublic);
        sendBackMessage("Thank you for bookmarking!", request, response);
    }

    private void addReport(String username, int workID, Date date, HttpServletRequest request, HttpServletResponse response ) throws IOException, ServletException, SQLException, DBOperationException {
        String description = request.getParameter("reportDescription");
        String reason = request.getParameter("reportReason");

        if (reason == null) {
            sendBackMessage("Could not submit your report because it needs a reason", request, response);
            return;
        }

        DataHandler.addReport(username, workID, date, description, reason);
        sendBackMessage("Your report has been submitted.", request, response);
    }

    // Currently just a simple feedback message
    private void sendBackMessage(String message, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // TODO: Supposed to send the user back to the page they came from, displaying the message string afterward.
        //      It doesn't work because GET request parameters are not included. We have enough information to brute force it if needed (workID) but do we want to?
        //      Since the request parameters are preserved, could we somehow feed the existing parameters back to the work display pages?
//        String isWrittenWork = request.getParameter("isWrittenWork");
//        RequestDispatcher dispatcher;
//        if (isWrittenWork == null) {
//            dispatcher = request.getRequestDispatcher("/works/display_filters.jsp"); // TODO: CHECK PATH
//        } else if (isWrittenWork.equals("true")) {
//            dispatcher = request.getRequestDispatcher("/works/digitalwork.jsp"); // TODO: CHECK PATH
//        } else {
//            dispatcher = request.getRequestDispatcher("/works/writtenwork.jsp"); // TODO: CHECK PATH
//        }
//        dispatcher.include(request, response);

        PrintWriter out = response.getWriter();
        out.println(message);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
