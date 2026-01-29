package com.studentapp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

public class NumberGuessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private int targetNumber;

    // Getter needed for your test
    public int getTargetNumber() {
        return targetNumber;
    }

    @Override
    public void init() throws ServletException {
        targetNumber = new Random().nextInt(100) + 1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Number Guessing Game</h1>");
        out.println("<form action='guess' method='post'>");
        out.println("Guess a number between 1 and 100: <input type='text' name='guess' />");
        out.println("<input type='submit' value='Submit' />");
        out.println("</form>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        try {
            int guess = Integer.parseInt(request.getParameter("guess"));
            if (guess < targetNumber) {
                out.println("<h2>Your guess is too low. Try again!</h2>");
            } else if (guess > targetNumber) {
                out.println("<h2>Your guess is too high. Try again!</h2>");
            } else {
                out.println("<h2>Congratulations! You guessed the number!</h2>");
                targetNumber = new Random().nextInt(100) + 1; // Reset game
            }
        } catch (NumberFormatException e) {
            out.println("<h2>Invalid input. Please enter a valid number.</h2>");
        }
        out.println("<a href='guess'>Play Again</a>");
    }
}

