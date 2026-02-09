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
    private int attempts;

    @Override
    public void init() throws ServletException {
        targetNumber = new Random().nextInt(100) + 1;
        attempts = 0;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        response.setCharacterEncoding("UTF-8");

        try {
            int guess = Integer.parseInt(request.getParameter("guess"));
            attempts++;

            String message;
            String status;

            if (guess < targetNumber) {
                message = "Your guess is too low!";
                status = "low";
            } else if (guess > targetNumber) {
                message = "Your guess is too high!";
                status = "high";
            } else {
                message = "🎉 Correct! You guessed the number!";
                status = "correct";
                targetNumber = new Random().nextInt(100) + 1;
                attempts = 0;
            }

            if (isAjax) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.write("{\"message\":\"" + message + "\",\"status\":\"" + status + "\",\"attempts\":" + attempts + "}");
                out.flush();
                return;
            }

        } catch (Exception e) {
            if (isAjax) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.write("{\"message\":\"Invalid input. Enter a number.\",\"status\":\"error\",\"attempts\":" + attempts + "}");
                out.flush();
                return;
            }
        }
    }
}

