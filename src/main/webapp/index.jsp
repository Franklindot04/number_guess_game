<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Number Guess Game</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: "Segoe UI", system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            color: #f9f9f9;
            background: radial-gradient(circle at top left, #3b5d50 0%, #1f2f28 35%, #0f1713 70%, #050806 100%);
            background-attachment: fixed;
        }

        .overlay {
            position: fixed;
            inset: 0;
            background: radial-gradient(circle at 10% 0%, rgba(255,255,255,0.06) 0%, transparent 40%),
                        radial-gradient(circle at 90% 100%, rgba(0,255,150,0.08) 0%, transparent 45%);
            pointer-events: none;
        }

        .card {
            position: relative;
            z-index: 1;
            background: rgba(10, 18, 14, 0.92);
            border-radius: 18px;
            padding: 32px 40px;
            box-shadow:
                0 18px 45px rgba(0, 0, 0, 0.7),
                0 0 0 1px rgba(255, 255, 255, 0.04);
            max-width: 420px;
            width: 90%;
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .title {
            font-size: 28px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 14px;
            color: #c7d5cf;
            margin-bottom: 24px;
        }

        .glow-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #4ade80;
            box-shadow: 0 0 12px #4ade80;
            display: inline-block;
            margin-right: 8px;
        }

        .input-row {
            display: flex;
            gap: 10px;
            margin-bottom: 18px;
        }

        .input-row input[type="number"] {
            flex: 1;
            padding: 10px 12px;
            border-radius: 10px;
            border: 1px solid rgba(148, 163, 184, 0.5);
            background: rgba(15, 23, 20, 0.9);
            color: #f9fafb;
            font-size: 16px;
            outline: none;
            transition: border 0.2s ease, box-shadow 0.2s ease, transform 0.1s ease;
        }

        .input-row input[type="number"]:focus {
            border-color: #4ade80;
            box-shadow: 0 0 0 1px rgba(74, 222, 128, 0.4);
            transform: translateY(-1px);
        }

        .btn-guess {
            padding: 10px 18px;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #22c55e, #16a34a);
            color: #0b1120;
            font-weight: 600;
            cursor: pointer;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: transform 0.12s ease, box-shadow 0.12s ease, filter 0.12s ease;
            box-shadow: 0 10px 20px rgba(22, 163, 74, 0.45);
        }

        .btn-guess:hover {
            transform: translateY(-1px) scale(1.01);
            filter: brightness(1.05);
        }

        .btn-guess:active {
            transform: translateY(1px) scale(0.99);
            box-shadow: 0 4px 10px rgba(22, 163, 74, 0.35);
        }

        .btn-guess.shake {
            animation: shake 0.35s ease;
        }

        @keyframes shake {
            0%   { transform: translateX(0); }
            20%  { transform: translateX(-4px); }
            40%  { transform: translateX(4px); }
            60%  { transform: translateX(-3px); }
            80%  { transform: translateX(3px); }
            100% { transform: translateX(0); }
        }

        .result {
            min-height: 24px;
            font-size: 15px;
            margin-top: 6px;
        }

        .result.low {
            color: #60a5fa;
        }

        .result.high {
            color: #f97373;
        }

        .result.correct {
            color: #4ade80;
            font-weight: 600;
        }

        .hint {
            margin-top: 18px;
            font-size: 12px;
            color: #9ca3af;
        }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            background: rgba(34, 197, 94, 0.12);
            color: #bbf7d0;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="overlay"></div>

<div class="card">
    <div class="badge">Classic Java Servlet Game</div>
    <div class="title">
        <span class="glow-dot"></span>
        Number Guess
    </div>
    <div class="subtitle">
        Guess the secret number between <strong>1</strong> and <strong>100</strong>.
    </div>

    <form id="guessForm">
        <div class="input-row">
            <input type="number" id="guessInput" min="1" max="100" required placeholder="Enter your guess..." />
            <button type="submit" id="guessButton" class="btn-guess">
                Guess
            </button>
        </div>
    </form>

    <div id="resultMessage" class="result"></div>

    <div class="hint">
        Tip: Trust your instincts, then go one step bolder.
    </div>
</div>

<!-- Confetti library -->
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>

<script>
document.getElementById("guessForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const guess = document.getElementById("guessInput").value;
    const result = document.getElementById("resultMessage");
    const button = document.getElementById("guessButton");

    fetch("guess", {
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

