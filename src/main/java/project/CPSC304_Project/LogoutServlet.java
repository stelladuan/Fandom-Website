package project.CPSC304_Project;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet that handles logout requests.
 */
@WebServlet(name = "LogoutServlet", value = "/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("username");
        session.removeAttribute("isModerator");
        session.invalidate();

        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.include(request, response);

        PrintWriter out = response.getWriter();
        out.println("Logged out successfully.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
