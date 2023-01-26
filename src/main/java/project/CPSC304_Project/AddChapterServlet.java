package project.CPSC304_Project;

import project.CPSC304_Project.exception.DBOperationException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "addchapter", value = "/addchapter")
public class AddChapterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int workID = Integer.parseInt(request.getParameter("workID"));
        int chapterCount = Integer.parseInt(request.getParameter("chapter_count"));
        String textFile = convertTextToHtml(request.getParameter("text_file"));
        int wordCount = Integer.parseInt(request.getParameter("word_count"));

        try {
            DataHandler.insertChapter(workID, chapterCount, textFile, wordCount);
            String destination = "writtenwork.jsp";
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(destination);
            request.setAttribute("workID", Integer.toString(workID));
            request.setAttribute("chapter_num", Integer.toString(chapterCount));
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
