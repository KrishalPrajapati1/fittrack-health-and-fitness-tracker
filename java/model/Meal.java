package model;

import java.sql.Time;
import java.sql.Timestamp;

public class Meal {
    private int mealId;
    private int dietPlanId;
    private String mealName;
    private String mealType;
    private int calories;
    private double protein;
    private double carbs;
    private double fat;
    private Time mealTime;
    private String instructions;
    private String ingredients;
    private int preparationTime;
    private String servingSize;
    private Timestamp createdAt;

    // Default constructor
    public Meal() {}

    // Constructor with essential fields
    public Meal(int dietPlanId, String mealName, String mealType, int calories, 
               double protein, double carbs, double fat) {
        this.dietPlanId = dietPlanId;
        this.mealName = mealName;
        this.mealType = mealType;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
        this.servingSize = "1 serving";
    }

    // Constructor with all fields
    public Meal(int dietPlanId, String mealName, String mealType, int calories, 
               double protein, double carbs, double fat, Time mealTime, 
               String instructions, String ingredients, int preparationTime, String servingSize) {
        this.dietPlanId = dietPlanId;
        this.mealName = mealName;
        this.mealType = mealType;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
        this.mealTime = mealTime;
        this.instructions = instructions;
        this.ingredients = ingredients;
        this.preparationTime = preparationTime;
        this.servingSize = servingSize;
    }

    // Getters and Setters
    public int getMealId() {
        return mealId;
    }

    public void setMealId(int mealId) {
        this.mealId = mealId;
    }

    public int getDietPlanId() {
        return dietPlanId;
    }

    public void setDietPlanId(int dietPlanId) {
        this.dietPlanId = dietPlanId;
    }

    public String getMealName() {
        return mealName;
    }

    public void setMealName(String mealName) {
        this.mealName = mealName;
    }

    public String getMealType() {
        return mealType;
    }

    public void setMealType(String mealType) {
        this.mealType = mealType;
    }

    public int getCalories() {
        return calories;
    }

    public void setCalories(int calories) {
        this.calories = calories;
    }

    public double getProtein() {
        return protein;
    }

    public void setProtein(double protein) {
        this.protein = protein;
    }

    public double getCarbs() {
        return carbs;
    }

    public void setCarbs(double carbs) {
        this.carbs = carbs;
    }

    public double getFat() {
        return fat;
    }

    public void setFat(double fat) {
        this.fat = fat;
    }

    public Time getMealTime() {
        return mealTime;
    }

    public void setMealTime(Time mealTime) {
        this.mealTime = mealTime;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public int getPreparationTime() {
        return preparationTime;
    }

    public void setPreparationTime(int preparationTime) {
        this.preparationTime = preparationTime;
    }

    public String getServingSize() {
        return servingSize;
    }

    public void setServingSize(String servingSize) {
        this.servingSize = servingSize;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Meal{" +
                "mealId=" + mealId +
                ", dietPlanId=" + dietPlanId +
                ", mealName='" + mealName + '\'' +
                ", mealType='" + mealType + '\'' +
                ", calories=" + calories +
                ", protein=" + protein +
                ", carbs=" + carbs +
                ", fat=" + fat +
                ", mealTime=" + mealTime +
                ", preparationTime=" + preparationTime +
                ", servingSize='" + servingSize + '\'' +
                '}';
    }
}
