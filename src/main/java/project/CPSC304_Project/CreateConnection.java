package project.CPSC304_Project;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.SQLException;

/**
 * Listener class which creates and closes the database connection used by this application before initialization
 * and after destruction of all servlets.
 */
public class CreateConnection implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContextListener.super.contextInitialized(sce);

        try {
            DataHandler.connect();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);

        try {
            DataHandler.closeConnection();
        } catch (SQLException e) {
            e.printStackTrace();        // can't do anything about it
        }
    }
}
