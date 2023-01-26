package project.CPSC304_Project;

import project.CPSC304_Project.exception.DBOperationException;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet which handles signing up new users.
 */
@WebServlet(name = "SignUpServlet", value = "/SignUpServlet")
public class SignUpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        if (username != null && password != null && email != null) {
            boolean couldInsert = true;
            try {
                DataHandler.insertUser(username, password, email, false);
            } catch (DBOperationException | SQLException e) {
                couldInsert = false;
            }

            PrintWriter writer = response.getWriter();
            if (couldInsert) {
                writer.println("<p>Successfully created your account! Please log in:");

                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.include(request, response);
          } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("sign_up.jsp");
                dispatcher.include(request, response);

                writer.println("<p>Sorry, your account could not be created. This is most likely because someone already has" +
                        " an account with the same username or email address. </p>");
            }
        }
    }
}
