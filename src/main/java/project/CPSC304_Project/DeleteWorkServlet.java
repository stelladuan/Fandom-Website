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

@WebServlet(name = "deletework", value = "/deletework")
public class DeleteWorkServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String author = request.getParameter("author");
        Object user = session.getAttribute("username");

        if ((user == null) || (!user.toString().equals(author))) {
            PrintWriter out = response.getWriter();
            out.println("Please log in to a (correct) account to edit this work.");
            return;
        }

        int workID = Integer.parseInt(request.getParameter("work_ID"));

        try {
            DataHandler.deleteWork(workID);
            String destination = "displayworks";
            RequestDispatcher requestDispatcher = request.getRequestDispatcher(destination);
            requestDispatcher.forward(request, response);
        } catch (SQLException | DBOperationException e) {
            e.printStackTrace();
        }
    }
}