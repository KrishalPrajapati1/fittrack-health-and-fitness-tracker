package controller.admin;

import util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/workout-management")
public class AdminWorkoutManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || (!"admin".equals(session.getAttribute("userType")) && !"admin".equals(session.getAttribute("role")))) {
            response.sendRedirect("../login.jsp");
            return;
        }
        List<Map<String, Object>> workouts = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM workouts ORDER BY workout_id DESC")) {
            while (rs.next()) {
                Map<String, Object> w = new HashMap<>();
                w.put("workout_id", rs.getInt("workout_id"));
                w.put("name", rs.getString("name"));
                w.put("type", rs.getString("type"));
                w.put("duration", rs.getInt("duration"));
                w.put("calories_burned", rs.getInt("calories_burned"));
                w.put("description", rs.getString("description"));
                workouts.add(w);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Failed to load workouts: " + e.getMessage());
        }
        request.setAttribute("workouts", workouts);
        request.getRequestDispatcher("/admin/workout-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || (!"admin".equals(session.getAttribute("userType")) && !"admin".equals(session.getAttribute("role")))) {
            response.sendRedirect("../login.jsp");
            return;
        }
        String action = request.getParameter("action");
        String error = null, success = null;
        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String type = request.getParameter("type");
                int duration = Integer.parseInt(request.getParameter("duration"));
                int calories = Integer.parseInt(request.getParameter("calories_burned"));
                String desc = request.getParameter("description");
                String sql = "INSERT INTO workouts (name, type, duration, calories_burned, description) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, type);
                    ps.setInt(3, duration);
                    ps.setInt(4, calories);
                    ps.setString(5, desc);
                    ps.executeUpdate();
                    success = "Workout added successfully.";
                }
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("workout_id"));
                String name = request.getParameter("name");
                String type = request.getParameter("type");
                int duration = Integer.parseInt(request.getParameter("duration"));
                int calories = Integer.parseInt(request.getParameter("calories_burned"));
                String desc = request.getParameter("description");
                String sql = "UPDATE workouts SET name=?, type=?, duration=?, calories_burned=?, description=? WHERE workout_id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, type);
                    ps.setInt(3, duration);
                    ps.setInt(4, calories);
                    ps.setString(5, desc);
                    ps.setInt(6, id);
                    ps.executeUpdate();
                    success = "Workout updated successfully.";
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("workout_id"));
                String sql = "DELETE FROM workouts WHERE workout_id=?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    success = "Workout deleted successfully.";
                }
            }
        } catch (Exception e) {
            error = "Operation failed: " + e.getMessage();
        }
        if (error != null) request.setAttribute("error", error);
        if (success != null) request.setAttribute("success", success);
        doGet(request, response);
    }
}