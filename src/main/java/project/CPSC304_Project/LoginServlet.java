package project.CPSC304_Project;

import project.CPSC304_Project.model.SiteUser;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet that handles login requests.
 */
@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            SiteUser foundUser = null;
            try {
                foundUser = DataHandler.queryUser(username, password);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (foundUser != null) {
                boolean isModerator = foundUser.isModerator();

                request.getSession().setAttribute("username", username);
                request.getSession().setAttribute("isModerator", isModerator);

                RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
                dispatcher.forward(request, response);
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.include(request, response);

                PrintWriter writer = response.getWriter();

                writer.println("<p>Your username or password was incorrect.</p>");
            }
        }
    }
}
