<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Number Guess Game</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
            width: 350px;
        }

        .btn-guess {
            background: #007bff;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-guess:hover {
            background: #0056b3;
        }

        .shake {
            animation: shake 0.3s;
        }

        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
            100% { transform: translateX(0); }
        }

        .correct {
            color: green;
            font-weight: bold;
            font-size: 22px;
        }
    </style>
</head>

<body>

<div class="card">
    <h2>Number Guessing Game</h2>

    <form id="guessForm">
        <input type="number" id="guessInput" placeholder="Enter your guess" required>
        <br><br>
        <button type="submit" id="guessButton" class="btn-guess">Submit Guess</button>
    </form>

    <p id="resultMessage" style="margin-top:15px; font-size:18px;"></p>
</div>

<!-- Confetti library -->
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

<script>
document.getElementById("guessForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const guess = document.getElementById("guessInput").value;
    const result = document.getElementById("resultMessage");
    const button = document.getElementById("guessButton");

    fetch("NumberGuessServlet", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With": "XMLHttpRequest"
        },
        body: "guess=" + guess
    })
    .then(res => res.json())
    .then(data => {
        result.innerHTML = data.message;

        if (data.status !== "correct") {
            button.classList.remove("shake");
            void button.offsetWidth;
            button.classList.add("shake");
        }

        if (data.status === "correct") {
            result.classList.add("correct");
            launchConfetti();
            showPlayAgain();
        }
    });
});

function showPlayAgain() {
    const card = document.querySelector(".card");
    const btn = document.createElement("button");
    btn.textContent = "Play Again";
    btn.className = "btn-guess";
    btn.style.marginTop = "15px";
    btn.onclick = () => window.location.reload();
    card.appendChild(btn);
}

function launchConfetti() {
    const duration = 1500;
    const end = Date.now() + duration;

    (function frame() {
        confetti({ particleCount: 5, spread: 70 });
        if (Date.now() < end) requestAnimationFrame(frame);
    })();
}
</script>

</body>
</html>

