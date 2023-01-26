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
import java.sql.SQLException;

/**
 * Servlet which handles creating a work.
 */
@WebServlet(name = "editwork", value = "/editwork")
public class EditWorkServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int workID = Integer.parseInt(request.getParameter("workID"));
        String title = request.getParameter("work_title");
        String description = convertTextToHtml(request.getParameter("description"));
        String workType = request.getParameter("work_type");

        String destination;
        RequestDispatcher requestDispatcher;
        try {
            if (workType.equals("digital")) {
                String imageFile = request.getParameter("image_url");

                DataHandler.updateDigitalWork(workID, title, description, imageFile);
                destination = "digitalwork.jsp";
            } else if (workType.equals("written")) {
                int wordCount = Integer.parseInt(request.getParameter("word_count"));
                String language = request.getParameter("language");
                int chapterNum = Integer.parseInt(request.getParameter("chapter_num"));
                String textFile = convertTextToHtml(request.getParameter("text_file"));

                DataHandler.updateWrittenWork(workID, title, description, wordCount, language, chapterNum, textFile);
                destination = "writtenwork.jsp";
            } else {
                throw new DBOperationException();
            }

            requestDispatcher = request.getRequestDispatcher(destination);
            request.setAttribute("workID", Integer.toString(workID));
            requestDispatcher.forward(request, response);
        } catch (SQLException | DBOperationException e) {
            e.printStackTrace();
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