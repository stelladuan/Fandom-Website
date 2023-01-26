package project.CPSC304_Project;

import project.CPSC304_Project.exception.DBOperationException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet which handles creating a work.
 */
@WebServlet(name = "creatework", value = "/creatework")
public class CreateWorkServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String author;
        if (session.getAttribute("username") != null) {
            author = session.getAttribute("username").toString();
        } else {
            PrintWriter out = response.getWriter();
            out.println("Please log in to interact with this work.");
            return;
        }

        String title = request.getParameter("work_title");
        String description = request.getParameter("description");
        if (description.equals("")) {
            description = null;
        } else {
            description = convertTextToHtml(description);
        }
        String workType = request.getParameter("work_type");

        try {
            String destination;
            RequestDispatcher requestDispatcher;
            int workID;

            if (workType.equals("written")) {
                int wordCount = Integer.parseInt(request.getParameter("word_count"));
                String language = request.getParameter("language");
                String textFile = convertTextToHtml(request.getParameter("text_file"));

                workID = DataHandler.insertWrittenWork(title, description, author, workType, wordCount, language, textFile);
                destination = "writtenwork.jsp";
            } else if (workType.equals("digital")) {
                String imageFile = request.getParameter("image_url");

                workID = DataHandler.insertDigitalWork(title, description, author, workType, imageFile);
                destination = "digitalwork.jsp";
            } else {
                throw new DBOperationException();
            }

            requestDispatcher = request.getRequestDispatcher(destination);
            request.setAttribute("workID", Integer.toString(workID));
            requestDispatcher.forward(request, response);

        } catch (SQLException | DBOperationException e) {
            e.printStackTrace();
            PrintWriter out = response.getWriter();
            out.println("Something went wrong - please try again later.");
        }
    }

    private String convertTextToHtml(String text) {
        StringBuilder newTextFile = new StringBuilder();
        for (char character : text.toCharArray()) {
            switch (character) {
                case '\n':
                    newTextFile.append("<br>");
                    break;
                case '"':
                    newTextFile.append("&quot;");
                    break;
                case '&':
                    newTextFile.append("&amp;");
                    break;
                default:
                    newTextFile.append(character);
            }
        }

        return newTextFile.toString();
    }
}