package model;

import java.sql.Timestamp;
import java.util.List;

public class DietPlan {
    private int dietPlanId;
    private String planName;
    private String description;
    private int totalCalories;
    private double totalProtein;
    private double totalCarbs;
    private double totalFat;
    private String planType;
    private String difficultyLevel;
    private int durationDays;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;
    private List<Meal> meals;

    // Default constructor
    public DietPlan() {}

    // Constructor with essential fields
    public DietPlan(String planName, String description, int totalCalories, 
                   double totalProtein, double totalCarbs, double totalFat, 
                   String planType, String difficultyLevel, int durationDays) {
        this.planName = planName;
        this.description = description;
        this.totalCalories = totalCalories;
        this.totalProtein = totalProtein;
        this.totalCarbs = totalCarbs;
        this.totalFat = totalFat;
        this.planType = planType;
        this.difficultyLevel = difficultyLevel;
        this.durationDays = durationDays;
        this.isActive = true;
    }

    // Getters and Setters
    public int getDietPlanId() {
        return dietPlanId;
    }

    public void setDietPlanId(int dietPlanId) {
        this.dietPlanId = dietPlanId;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTotalCalories() {
        return totalCalories;
    }

    public void setTotalCalories(int totalCalories) {
        this.totalCalories = totalCalories;
    }

    public double getTotalProtein() {
        return totalProtein;
    }

    public void setTotalProtein(double totalProtein) {
        this.totalProtein = totalProtein;
    }

    public double getTotalCarbs() {
        return totalCarbs;
    }

    public void setTotalCarbs(double totalCarbs) {
        this.totalCarbs = totalCarbs;
    }

    public double getTotalFat() {
        return totalFat;
    }

    public void setTotalFat(double totalFat) {
        this.totalFat = totalFat;
    }

    public String getPlanType() {
        return planType;
    }

    public void setPlanType(String planType) {
        this.planType = planType;
    }

    public String getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(String difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public List<Meal> getMeals() {
        return meals;
    }

    public void setMeals(List<Meal> meals) {
        this.meals = meals;
    }

    @Override
    public String toString() {
        return "DietPlan{" +
                "dietPlanId=" + dietPlanId +
                ", planName='" + planName + '\'' +
                ", description='" + description + '\'' +
                ", totalCalories=" + totalCalories +
                ", totalProtein=" + totalProtein +
                ", totalCarbs=" + totalCarbs +
                ", totalFat=" + totalFat +
                ", planType='" + planType + '\'' +
                ", difficultyLevel='" + difficultyLevel + '\'' +
                ", durationDays=" + durationDays +
                ", isActive=" + isActive +
                '}';
    }
}
