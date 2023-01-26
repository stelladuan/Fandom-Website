package project.CPSC304_Project;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Servlet which processes moderator requests to approve/deny a report.
 */
@WebServlet(name = "ProcessReportServlet", value = "/ProcessReportServlet")
public class ProcessReportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportAction = request.getParameter("reportAction");
        if (reportAction == null) return;

        int reportID;
        try {
            reportID = Integer.parseInt(request.getParameter("reportID"));
        } catch (NumberFormatException e) {
            return; // stop processing, invalid reportID
        }

        try {
            if (reportAction.equals("Approve")) {
                DataHandler.approveReport(reportID);
                sendBackMessage("Report Approved. The reported work has been deleted.", response);
            } else if (reportAction.equals("Deny")) {
                DataHandler.denyReport(reportID);
                sendBackMessage("Report Denied. The report has been deleted.", response);
            }
        } catch (SQLException e) {
            e.printStackTrace();  // nothing we can do
            sendBackMessage("Something went wrong when trying to process this report. Please try again.", response);
        }
    }

    private void sendBackMessage(String message, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();

        out.println(message);
    }
}
