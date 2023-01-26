package project.CPSC304_Project;

import project.CPSC304_Project.model.ReportInfo;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet which displays a filtered list of reports according to the selection conditions.
 * The list also allows moderators to approve reports (deleting the reported work) or deny reports (deleting the report).
 */
@WebServlet(name = "ShowReportsServlet", value = "/ShowReportsServlet")
public class ShowReportsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ReportSelectionConditions selectionConditions = new ReportSelectionConditions();

        selectionConditions.setReason(request.getParameter("reason"));
        selectionConditions.setIssue(request.getParameter("issue"));
        selectionConditions.setUsername(request.getParameter("username"));

        if (request.getParameter("reportID") != null) {
            try {
                selectionConditions.setReportID(Integer.parseInt(request.getParameter("reportID")));
            } catch (NumberFormatException ignored) {}
        }

        if (request.getParameter("workID") != null) {
            try {
                selectionConditions.setWorkID(Integer.parseInt(request.getParameter("workID")));
            } catch (NumberFormatException ignored) {}
        }

        if (request.getParameter("maxDate") != null) {
            try {
                selectionConditions.setMaxDate(Date.valueOf(request.getParameter("maxDate")));
            } catch (IllegalArgumentException ignored) {}
        }
        if (request.getParameter("minDate") != null) {
            try {
                selectionConditions.setMinDate(Date.valueOf(request.getParameter("minDate")));
            } catch (IllegalArgumentException ignored) {}
        }

        try {
            List<ReportInfo> reports = DataHandler.getReports(selectionConditions);
            showReports(reports, selectionConditions, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void showReports(List<ReportInfo> reports, ReportSelectionConditions conditions, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                "    <title>Search results</title>\n" +
                "    <style>" +
                "    table { width: 100%; }\n" +
                "    th, td {" +
                        "  padding: 20px;" +
                        "  border-bottom: 1px solid;" +
                "       }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body>");

        out.println("<b>Search conditions:</b> <br>");
        out.println(conditions.toHtml());

        if (reports.size() > 0) {
            out.println("<table>");

            out.println("<tr>\n" +
                    "    <th>Report ID</th>\n" +
                    "    <th>Date</th>\n" +
                    "    <th>Reported work</th>\n" +
                    "    <th>User</th>\n" +
                    "    <th>Issue</th>\n" +
                    "    <th>Reason</th>\n" +
                    "    <th>Description</th>\n" +
                    "    <th>Action</th>\n" +
                    "  </tr>");

            for (ReportInfo report : reports) {
                out.println("<tr>\n" +
                        "    <td>" + report.getReportID() + "</td>\n" +
                        "    <td>" + report.getDate() + "</td>\n" +
                        "    <td>" + report.getReportedWorkID() + "</td>\n" +
                        "    <td>" + report.getUser() + "</td>\n" +
                        "    <td>" + report.getIssue() + "</td>\n" +
                        "    <td>" + report.getReason() + "</td>\n" +
                        "    <td>" + report.getDescription() + "</td>\n" +
                        "    <td>\n" +
                        "      <form action=\"ProcessReportServlet\" method=\"post\">\n" +
                        "        <input type=\"hidden\" name=\"reportID\" value=\"" + report.getReportID() + "\"/>\n" +
                        "        <button name=\"reportAction\" type=\"submit\" value=\"Approve\">Approve</button>\n" +
                        "        <button name=\"reportAction\" type=\"submit\" value=\"Deny\">Deny</button>\n" +
                        "      </form>\n" +
                        "    </td>" +
                        "    </tr>");
            }
            out.println("</table>\n");
        } else {
            out.println("No reports were found that matched the search conditions.");
        }

        out.println("<br> <br> <a href=\"view_reports.jsp\">Search again</a>" +
                "</body>\n" +
                "</html>");
    }
}
