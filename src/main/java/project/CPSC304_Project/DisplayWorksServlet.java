package project.CPSC304_Project;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet which handles creating a work.
 */
@WebServlet(name = "displayworks", value = "/displayworks")
public class DisplayWorksServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        displayWorks(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        displayWorks(request, response);
    }

    private void displayWorks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter = request.getParameter("work_filter");
        if (filter == null) {
            filter = "all";
        }
        String filterType = request.getParameter("filter_type");
        if (filterType == null) {
            filterType = "all";
        }

        ResultSet result;

        try {
            result = DataHandler.getFilteredWorks(filter, filterType);

            String destination = "display_works.jsp";
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(destination);

            request.setAttribute("filtered_works", result);
            request.setAttribute("filter_name", filter);

            requestDispatcher.forward(request, response);
//            response.sendRedirect("display_works.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}