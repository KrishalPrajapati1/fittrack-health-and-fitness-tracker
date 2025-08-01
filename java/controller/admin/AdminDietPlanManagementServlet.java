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
import java.net.URLEncoder;
import model.DietPlan;
import model.Meal;

@WebServlet("/admin/diet-plan-management")
public class AdminDietPlanManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || (!"admin".equals(session.getAttribute("userType")) && 
                               !"admin".equals(session.getAttribute("role")))) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                viewDietPlanDetails(request, response);
            } else if ("edit".equals(action)) {
                editDietPlan(request, response);
            } else if ("add".equals(action)) {
                showAddDietPlanForm(request, response);
            } else {
                viewAllDietPlans(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/diet-plan-management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/admin/diet-plan-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || (!"admin".equals(session.getAttribute("userType")) && 
                               !"admin".equals(session.getAttribute("role")))) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String success = null;
        String error = null;

        try {
            if ("add".equals(action)) {
                success = addDietPlan(request);
            } else if ("update".equals(action)) {
                success = updateDietPlan(request);
            } else if ("delete".equals(action)) {
                success = deleteDietPlan(request);
            } else if ("add_meal".equals(action)) {
                success = addMealToPlan(request);
            } else if ("update_meal".equals(action)) {
                success = updateMeal(request);
            } else if ("delete_meal".equals(action)) {
                success = deleteMeal(request);
            } else {
                error = "Unknown action: " + action;
            }
        } catch (SQLException e) {
            error = "Database error: " + e.getMessage();
            e.printStackTrace();
        } catch (NumberFormatException e) {
            error = "Invalid number format: " + e.getMessage();
        } catch (Exception e) {
            error = "Unexpected error: " + e.getMessage();
            e.printStackTrace();
        }

        // Handle redirects properly based on action type
        try {
            if ("update".equals(action)) {
                // For update action, redirect back to edit page
                String dietPlanId = request.getParameter("diet_plan_id");
                if (dietPlanId != null) {
                    if (error != null) {
                        response.sendRedirect("diet-plan-management?action=edit&planId=" + dietPlanId + "&error=" + URLEncoder.encode(error, "UTF-8"));
                    } else if (success != null) {
                        response.sendRedirect("diet-plan-management?action=edit&planId=" + dietPlanId + "&success=" + URLEncoder.encode(success, "UTF-8"));
                    } else {
                        response.sendRedirect("diet-plan-management?action=edit&planId=" + dietPlanId);
                    }
                } else {
                    response.sendRedirect("diet-plan-management");
                }
            } else if ("add_meal".equals(action) || "delete_meal".equals(action)) {
                // For meal actions, redirect back to diet plan details view
                String dietPlanId = request.getParameter("diet_plan_id");
                if (dietPlanId == null) {
                    dietPlanId = request.getParameter("planId");
                }
                if (dietPlanId != null) {
                    if (error != null) {
                        response.sendRedirect("diet-plan-management?action=view&planId=" + dietPlanId + "&error=" + URLEncoder.encode(error, "UTF-8"));
                    } else if (success != null) {
                        response.sendRedirect("diet-plan-management?action=view&planId=" + dietPlanId + "&success=" + URLEncoder.encode(success, "UTF-8"));
                    } else {
                        response.sendRedirect("diet-plan-management?action=view&planId=" + dietPlanId);
                    }
                } else {
                    response.sendRedirect("diet-plan-management");
                }
            } else {
                // For other actions (add, delete), redirect to main diet plan management page
                if (error != null) {
                    response.sendRedirect("diet-plan-management?error=" + URLEncoder.encode(error, "UTF-8"));
                } else if (success != null) {
                    response.sendRedirect("diet-plan-management?success=" + URLEncoder.encode(success, "UTF-8"));
                } else {
                    response.sendRedirect("diet-plan-management");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("diet-plan-management");
        }
    }
    
    private void viewAllDietPlans(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        List<DietPlan> dietPlans = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM diet_plans ORDER BY diet_plan_id DESC")) {
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    DietPlan plan = mapResultSetToDietPlan(rs);
                    dietPlans.add(plan);
                }
            }
        }
        
        // Check for success/error messages from URL parameters
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        
        request.setAttribute("dietPlans", dietPlans);
        request.getRequestDispatcher("/admin/diet-plan-management.jsp").forward(request, response);
    }

    private void viewDietPlanDetails(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String planIdStr = request.getParameter("planId");
        if (planIdStr == null) {
            response.sendRedirect("diet-plan-management");
            return;
        }

        int planId = Integer.parseInt(planIdStr);
        DietPlan dietPlan = null;
        List<Meal> meals = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Get diet plan details
            String planSql = "SELECT * FROM diet_plans WHERE diet_plan_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(planSql)) {
                pstmt.setInt(1, planId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        dietPlan = mapResultSetToDietPlan(rs);
                    }
                }
            }

            if (dietPlan == null) {
                request.setAttribute("error", "Diet plan not found");
                response.sendRedirect("diet-plan-management");
                return;
            }

            // Get meals for this plan
            String mealsSql = "SELECT * FROM meals WHERE diet_plan_id = ? ORDER BY meal_type, meal_time";
            try (PreparedStatement pstmt = conn.prepareStatement(mealsSql)) {
                pstmt.setInt(1, planId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Meal meal = mapResultSetToMeal(rs);
                        meals.add(meal);
                    }
                }
            }
        }

        // Check for success/error messages from URL parameters
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        request.setAttribute("dietPlan", dietPlan);
        request.setAttribute("meals", meals);
        request.getRequestDispatcher("/admin/diet-plans-details.jsp").forward(request, response);
    }

    private void editDietPlan(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String planIdStr = request.getParameter("planId");
        if (planIdStr == null) {
            response.sendRedirect("diet-plan-management");
            return;
        }

        int planId = Integer.parseInt(planIdStr);
        DietPlan dietPlan = null;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM diet_plans WHERE diet_plan_id = ?")) {
            
            pstmt.setInt(1, planId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dietPlan = mapResultSetToDietPlan(rs);
                }
            }
        }

        if (dietPlan == null) {
            request.setAttribute("error", "Diet plan not found");
            response.sendRedirect("diet-plan-management");
            return;
        }

        // Check for success/error messages from URL parameters
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        request.setAttribute("dietPlan", dietPlan);
        request.getRequestDispatcher("/admin/edit-diet-plans.jsp").forward(request, response);
    }

    private void showAddDietPlanForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check for success/error messages from URL parameters
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        
        request.getRequestDispatcher("/admin/add-diet-plan.jsp").forward(request, response);
    }

    private String addDietPlan(HttpServletRequest request) throws SQLException {
        String planName = request.getParameter("plan_name");
        String description = request.getParameter("description");
        String planType = request.getParameter("plan_type");
        String difficultyLevel = request.getParameter("difficulty_level");
        
        // Validate required fields
        if (planName == null || planName.trim().isEmpty()) {
            throw new IllegalArgumentException("Plan name is required");
        }
        if (planType == null || planType.trim().isEmpty()) {
            throw new IllegalArgumentException("Plan type is required");
        }
        if (difficultyLevel == null || difficultyLevel.trim().isEmpty()) {
            throw new IllegalArgumentException("Difficulty level is required");
        }
        
        int totalCalories = Integer.parseInt(request.getParameter("total_calories"));
        double totalProtein = Double.parseDouble(request.getParameter("total_protein"));
        double totalCarbs = Double.parseDouble(request.getParameter("total_carbs"));
        double totalFat = Double.parseDouble(request.getParameter("total_fat"));
        int durationDays = Integer.parseInt(request.getParameter("duration_days"));

        String sql = "INSERT INTO diet_plans (plan_name, description, total_calories, total_protein, " +
                    "total_carbs, total_fat, plan_type, difficulty_level, duration_days, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, planName);
            pstmt.setString(2, description);
            pstmt.setInt(3, totalCalories);
            pstmt.setDouble(4, totalProtein);
            pstmt.setDouble(5, totalCarbs);
            pstmt.setDouble(6, totalFat);
            pstmt.setString(7, planType);
            pstmt.setString(8, difficultyLevel);
            pstmt.setInt(9, durationDays);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return "Diet plan '" + planName + "' added successfully!";
            } else {
                throw new SQLException("Failed to add diet plan");
            }
        }
    }

    private String updateDietPlan(HttpServletRequest request) throws SQLException {
        String planIdStr = request.getParameter("diet_plan_id");
        if (planIdStr == null || planIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Diet plan ID is required");
        }
        
        int planId = Integer.parseInt(planIdStr);
        String planName = request.getParameter("plan_name");
        String description = request.getParameter("description");
        String planType = request.getParameter("plan_type");
        String difficultyLevel = request.getParameter("difficulty_level");
        
        // Validate required fields
        if (planName == null || planName.trim().isEmpty()) {
            throw new IllegalArgumentException("Plan name is required");
        }
        if (planType == null || planType.trim().isEmpty()) {
            throw new IllegalArgumentException("Plan type is required");
        }
        if (difficultyLevel == null || difficultyLevel.trim().isEmpty()) {
            throw new IllegalArgumentException("Difficulty level is required");
        }
        
        int totalCalories = Integer.parseInt(request.getParameter("total_calories"));
        double totalProtein = Double.parseDouble(request.getParameter("total_protein"));
        double totalCarbs = Double.parseDouble(request.getParameter("total_carbs"));
        double totalFat = Double.parseDouble(request.getParameter("total_fat"));
        int durationDays = Integer.parseInt(request.getParameter("duration_days"));

        String sql = "UPDATE diet_plans SET plan_name=?, description=?, total_calories=?, " +
                    "total_protein=?, total_carbs=?, total_fat=?, plan_type=?, " +
                    "difficulty_level=?, duration_days=?, updated_at=CURRENT_TIMESTAMP " +
                    "WHERE diet_plan_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, planName);
            pstmt.setString(2, description);
            pstmt.setInt(3, totalCalories);
            pstmt.setDouble(4, totalProtein);
            pstmt.setDouble(5, totalCarbs);
            pstmt.setDouble(6, totalFat);
            pstmt.setString(7, planType);
            pstmt.setString(8, difficultyLevel);
            pstmt.setInt(9, durationDays);
            pstmt.setInt(10, planId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return "Diet plan '" + planName + "' updated successfully!";
            } else {
                throw new SQLException("Diet plan not found or no changes made");
            }
        }
    }

    private String deleteDietPlan(HttpServletRequest request) throws SQLException {
        String planIdStr = request.getParameter("diet_plan_id");
        if (planIdStr == null || planIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Diet plan ID is required");
        }
        
        int planId = Integer.parseInt(planIdStr);
        String planName = null;

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // First, get the plan name for the success message
                String getNameSql = "SELECT plan_name FROM diet_plans WHERE diet_plan_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(getNameSql)) {
                    pstmt.setInt(1, planId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            planName = rs.getString("plan_name");
                        }
                    }
                }
                
                // Delete all meals associated with this plan
                String deleteMealsSql = "DELETE FROM meals WHERE diet_plan_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(deleteMealsSql)) {
                    pstmt.setInt(1, planId);
                    pstmt.executeUpdate();
                }

                // Then delete the diet plan
                String deletePlanSql = "DELETE FROM diet_plans WHERE diet_plan_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(deletePlanSql)) {
                    pstmt.setInt(1, planId);
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        conn.commit();
                        return "Diet plan '" + (planName != null ? planName : "ID " + planId) + "' deleted successfully!";
                    } else {
                        conn.rollback();
                        throw new SQLException("Diet plan not found");
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private String addMealToPlan(HttpServletRequest request) throws SQLException {
        String dietPlanIdStr = request.getParameter("diet_plan_id");
        if (dietPlanIdStr == null || dietPlanIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Diet plan ID is required");
        }
        
        int dietPlanId = Integer.parseInt(dietPlanIdStr);
        String mealName = request.getParameter("meal_name");
        String mealType = request.getParameter("meal_type");
        
        if (mealName == null || mealName.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal name is required");
        }
        if (mealType == null || mealType.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal type is required");
        }
        
        int calories = Integer.parseInt(request.getParameter("calories"));
        double protein = Double.parseDouble(request.getParameter("protein"));
        double carbs = Double.parseDouble(request.getParameter("carbs"));
        double fat = Double.parseDouble(request.getParameter("fat"));
        String mealTime = request.getParameter("meal_time");
        String instructions = request.getParameter("instructions");
        String ingredients = request.getParameter("ingredients");
        String preparationTimeStr = request.getParameter("preparation_time");
        String servingSize = request.getParameter("serving_size");

        int preparationTime = 0;
        if (preparationTimeStr != null && !preparationTimeStr.trim().isEmpty()) {
            preparationTime = Integer.parseInt(preparationTimeStr);
        }

        String sql = "INSERT INTO meals (diet_plan_id, meal_name, meal_type, calories, protein, " +
                    "carbs, fat, meal_time, instructions, ingredients, preparation_time, serving_size) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, dietPlanId);
            pstmt.setString(2, mealName);
            pstmt.setString(3, mealType);
            pstmt.setInt(4, calories);
            pstmt.setDouble(5, protein);
            pstmt.setDouble(6, carbs);
            pstmt.setDouble(7, fat);
            
            // Handle meal_time - convert String to Time if provided
            if (mealTime != null && !mealTime.trim().isEmpty()) {
                try {
                    // If mealTime is in HH:mm format, add seconds
                    if (mealTime.matches("\\d{2}:\\d{2}")) {
                        mealTime += ":00";
                    }
                    pstmt.setTime(8, Time.valueOf(mealTime));
                } catch (IllegalArgumentException e) {
                    pstmt.setNull(8, java.sql.Types.TIME);
                }
            } else {
                pstmt.setNull(8, java.sql.Types.TIME);
            }
            
            pstmt.setString(9, instructions);
            pstmt.setString(10, ingredients);
            pstmt.setInt(11, preparationTime);
            pstmt.setString(12, servingSize);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return "Meal '" + mealName + "' added successfully!";
            } else {
                throw new SQLException("Failed to add meal");
            }
        }
    }

    private String updateMeal(HttpServletRequest request) throws SQLException {
        String mealIdStr = request.getParameter("meal_id");
        if (mealIdStr == null || mealIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal ID is required");
        }
        
        int mealId = Integer.parseInt(mealIdStr);
        String mealName = request.getParameter("meal_name");
        String mealType = request.getParameter("meal_type");
        
        if (mealName == null || mealName.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal name is required");
        }
        if (mealType == null || mealType.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal type is required");
        }
        
        int calories = Integer.parseInt(request.getParameter("calories"));
        double protein = Double.parseDouble(request.getParameter("protein"));
        double carbs = Double.parseDouble(request.getParameter("carbs"));
        double fat = Double.parseDouble(request.getParameter("fat"));
        String mealTime = request.getParameter("meal_time");
        String instructions = request.getParameter("instructions");
        String ingredients = request.getParameter("ingredients");
        String preparationTimeStr = request.getParameter("preparation_time");
        String servingSize = request.getParameter("serving_size");

        int preparationTime = 0;
        if (preparationTimeStr != null && !preparationTimeStr.trim().isEmpty()) {
            preparationTime = Integer.parseInt(preparationTimeStr);
        }

        String sql = "UPDATE meals SET meal_name=?, meal_type=?, calories=?, protein=?, " +
                    "carbs=?, fat=?, meal_time=?, instructions=?, ingredients=?, " +
                    "preparation_time=?, serving_size=? WHERE meal_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, mealName);
            pstmt.setString(2, mealType);
            pstmt.setInt(3, calories);
            pstmt.setDouble(4, protein);
            pstmt.setDouble(5, carbs);
            pstmt.setDouble(6, fat);
            
            // Handle meal_time - convert String to Time if provided
            if (mealTime != null && !mealTime.trim().isEmpty()) {
                try {
                    // If mealTime is in HH:mm format, add seconds
                    if (mealTime.matches("\\d{2}:\\d{2}")) {
                        mealTime += ":00";
                    }
                    pstmt.setTime(7, Time.valueOf(mealTime));
                } catch (IllegalArgumentException e) {
                    pstmt.setNull(7, java.sql.Types.TIME);
                }
            } else {
                pstmt.setNull(7, java.sql.Types.TIME);
            }
            
            pstmt.setString(8, instructions);
            pstmt.setString(9, ingredients);
            pstmt.setInt(10, preparationTime);
            pstmt.setString(11, servingSize);
            pstmt.setInt(12, mealId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return "Meal '" + mealName + "' updated successfully!";
            } else {
                throw new SQLException("Meal not found or no changes made");
            }
        }
    }

    private String deleteMeal(HttpServletRequest request) throws SQLException {
        String mealIdStr = request.getParameter("meal_id");
        if (mealIdStr == null || mealIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Meal ID is required");
        }
        
        int mealId = Integer.parseInt(mealIdStr);
        String mealName = null;

        // First, get the meal name for the success message
        String getNameSql = "SELECT meal_name FROM meals WHERE meal_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(getNameSql)) {
            
            pstmt.setInt(1, mealId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    mealName = rs.getString("meal_name");
                }
            }
        }

        String sql = "DELETE FROM meals WHERE meal_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, mealId);
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                return "Meal '" + (mealName != null ? mealName : "ID " + mealId) + "' deleted successfully!";
            } else {
                throw new SQLException("Meal not found");
            }
        }
    }

    private DietPlan mapResultSetToDietPlan(ResultSet rs) throws SQLException {
        DietPlan plan = new DietPlan();
        plan.setDietPlanId(rs.getInt("diet_plan_id"));
        plan.setPlanName(rs.getString("plan_name"));
        plan.setDescription(rs.getString("description"));
        plan.setTotalCalories(rs.getInt("total_calories"));
        plan.setTotalProtein(rs.getDouble("total_protein"));
        plan.setTotalCarbs(rs.getDouble("total_carbs"));
        plan.setTotalFat(rs.getDouble("total_fat"));
        plan.setPlanType(rs.getString("plan_type"));
        plan.setDifficultyLevel(rs.getString("difficulty_level"));
        plan.setDurationDays(rs.getInt("duration_days"));
        
        // Handle timestamps safely - use the correct method names from DietPlan class
        try {
            plan.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            try {
                plan.setCreatedAt(rs.getTimestamp("created_date"));
            } catch (SQLException e2) {
                // Column doesn't exist, ignore
            }
        }
        
        try {
            plan.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        try {
            plan.setActive(rs.getBoolean("is_active"));
        } catch (SQLException e) {
            // Column doesn't exist, default to true
            plan.setActive(true);
        }
        
        return plan;
    }

    private Meal mapResultSetToMeal(ResultSet rs) throws SQLException {
        Meal meal = new Meal();
        meal.setMealId(rs.getInt("meal_id"));
        meal.setDietPlanId(rs.getInt("diet_plan_id"));
        meal.setMealName(rs.getString("meal_name"));
        meal.setMealType(rs.getString("meal_type"));
        meal.setCalories(rs.getInt("calories"));
        meal.setProtein(rs.getDouble("protein"));
        meal.setCarbs(rs.getDouble("carbs"));
        meal.setFat(rs.getDouble("fat"));
        
        // Handle meal_time - get it as Time object from database
        try {
            meal.setMealTime(rs.getTime("meal_time"));
        } catch (SQLException e) {
            // Column doesn't exist or is null, ignore
        }
        
        meal.setInstructions(rs.getString("instructions"));
        meal.setIngredients(rs.getString("ingredients"));
        meal.setPreparationTime(rs.getInt("preparation_time"));
        meal.setServingSize(rs.getString("serving_size"));
        
        // Handle timestamps safely
        try {
            meal.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        return meal;
    }
}
