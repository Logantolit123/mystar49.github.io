<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Game Mashup: Roblox, Minecraft & Fortnite!</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Game Mashup</h1>
  <p>Play school-friendly mini-games inspired by Roblox, Minecraft, and Fortnite!</p>
  <div id="menu">
    <button onclick="startGame('roblox')">Roblox Obby</button>
    <button onclick="startGame('minecraft')">Minecraft Builder</button>
    <button onclick="startGame('fortnite')">Fortnite Aim Trainer</button>
  </div>
  <div id="game-container"></div>
  <button id="back-btn" onclick="showMenu()" style="display:none;">Back to Menu</button>
  <script src="game.js"></script>
</body>
</html>body {
  font-family: 'Segoe UI', Arial, sans-serif;
  background: #212121;
  color: #fff;
  margin: 0;
  padding: 0;
  text-align: center;
}

h1 {
  color: #ffd700;
  margin: 1em 0 0.5em 0;
}

#menu {
  margin: 2em 0;
}

button {
  background: #333;
  color: #fff;
  border: none;
  padding: 1em 2em;
  margin: 1em;
  font-size: 1.2em;
  border-radius: 0.5em;
  cursor: pointer;
  transition: background 0.2s;
}

button:hover {
  background: #444;
}

#game-container {
  min-height: 300px;
  margin-top: 2em;
}
function showMenu() {
    document.getElementById('menu').style.display = '';
    document.getElementById('game-container').innerHTML = '';
    document.getElementById('back-btn').style.display = 'none';
    document.onkeydown = null;
    document.onkeyup = null;
  
  function startGame(type) {
    document.getElementById('menu').style.display = 'none';
    document.getElementById('back-btn').style.display = '';
    if (type === 'roblox') robloxObby();
    else if (
  }type === 'minecraft') minecraftBuilder();
    else if (type === 'fortnite') fortniteAimTrainer();
  }
  
  // Roblox Obby Mini-Game
  function robloxObby() {
    const container = document.getElementById('game-container');
    container.innerHTML = `
      <h2>Roblox Obby</h2>
      <canvas id="obby-canvas" width="400" height="300" style="background:#d3faff;border-radius:10px;"></canvas>
      <p>Use arrow keys to jump across platforms!</p>
      <p id="obby-status"></p>
    `;
  
    const canvas = document.getElementById('obby-canvas');
    const ctx = canvas.getContext('2d');
    const platforms = [
      {x:20, y:260, w:80, h:20},
      {x:120, y:220, w:80, h:20},
      {x:220, y:180, w:80, h:20},
      {x:320, y:140, w:60, h:20},
    ];
    let player = {x:40, y:240, w:20, h:20, dx:0, dy:0, onGround:false};
    let goal = {x:360, y:120, w:30, h:20};
    let keys = {};
    let gameOver = false;
  
    function draw() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      // Platforms
      ctx.fillStyle = "#8bc34a";
      for (let p of platforms) ctx.fillRect(p.x, p.y, p.w, p.h);
      // Goal
      ctx.fillStyle = "#ffeb3b";
      ctx.fillRect(goal.x, goal.y, goal.w, goal.h);
      // Player
      ctx.fillStyle = "#2196f3";
      ctx.fillRect(player.x, player.y, player.w, player.h);
    }
  
    function update() {
      if (gameOver) return;
      player.dx = 0;
      if (keys['ArrowLeft']) player.dx = -3;
      if (keys['ArrowRight']) player.dx = 3;
      player.dy += 0.5; // gravity
  
      player.x += player.dx;
      player.y += player.dy;
  
      // Collisions
      player.onGround = false;
      for (let p of platforms) {
        if (player.x < p.x + p.w && player.x + player.w > p.x &&
          player.y < p.y + p.h && player.y + player.h > p.y) {
          if (player.dy > 0) {
            player.y = p.y - player.h;
            player.dy = 0;
            player.onGround = true;
          }
        }
      }
      // Win?
      if (player.x < goal.x + goal.w && player.x + player.w > goal.x &&
        player.y < goal.y + goal.h && player.y + player.h > goal.y) {
        document.getElementById('obby-status').textContent = "You Win!";
        gameOver = true;
      }
      // Out-of-bounds (lose)
      if (player.y > canvas.height) {
        document.getElementById('obby-status').textContent = "You Fell! Try Again.";
        gameOver = true;
      }
      draw();
      if (!gameOver) requestAnimationFrame(update);
    }
  
    document.onkeydown = (e) => {
      keys[e.key] = true;
      if (e.key === 'ArrowUp' && player.onGround) player.dy = -9;
    };
    document.onkeyup = (e) => keys[e.key] = false;
  
    draw();
    update();
  }
  
  // Minecraft Mini Builder
  function minecraftBuilder() {
    const container = document.getElementById('game-container');
    container.innerHTML = `
      <h2>Minecraft Builder</h2>
      <canvas id="mc-canvas" width="400" height="300" style="background:#aee571;border-radius:10px;"></canvas>
      <p>Click to place/remove blocks!</p>
    `;
  
    const canvas = document.getElementById('mc-canvas');
    const ctx = canvas.getContext('2d');
    const grid = Array(10).fill().map(()=>Array(13).fill(0));
  
    function draw() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      for (let y=0; y<10; y++) {
        for (let x=0; x<13; x++) {
          if (grid[y][x]) {
            ctx.fillStyle = "#795548";
            ctx.fillRect(x*30, y*30, 28, 28);
          }
          ctx.strokeStyle = "#fff";
          ctx.strokeRect(x*30, y*30, 30, 30);
        }
      }
    }
  
    canvas.onclick = function(e) {
      const rect = canvas.getBoundingClientRect();
      const x = Math.floor((e.clientX - rect.left) / 30);
      const y = Math.floor((e.clientY - rect.top) / 30);
      if (y >= 0 && y < 10 && x >= 0 && x < 13) {
        grid[y][x] = grid[y][x] ? 0 : 1;
        draw();
      }
    };
    draw();
  }
  
  // Fortnite Aim Trainer
  function fortniteAimTrainer() {
    const container = document.getElementById('game-container');
    container.innerHTML = `
      <h2>Fortnite Aim Trainer</h2>
      <canvas id="fn-canvas" width="400" height="300" style="background:#1e1e2f;border-radius:10px;"></canvas>
      <p>Click on targets as fast as you can! Score: <span id="score">0</span></p>
    `;
    const canvas = document.getElementById('fn-canvas');
    const ctx = canvas.getContext('2d');
    let score = 0;
    let target = {x: 100, y: 100, r: 20};
    let timer = 30; // seconds
  
    function drawTarget() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.beginPath();
      ctx.arc(target.x, target.y, target.r, 0, 2 * Math.PI);
      ctx.fillStyle = "#ff4081";
      ctx.fill();
    }
  
    function moveTarget() {
      target.x = Math.random() * (canvas.width - 40) + 20;
      target.y = Math.random() * (canvas.height - 40) + 20;
      drawTarget();
    }
  
    canvas.onclick = function(e) {
  
      setTimeout(countdown, 1000);
    }
      const rect = canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const dist = Math.sqrt((x - target.x) ** 2 + (y - target.y) ** 2);
      if (dist < target.r) {
        score++;
        document.getElementById('score').textContent = score;
        moveTarget();
      }
    };
  
    function countdown() {
      if (timer <= 0) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = "#fff";
        ctx.font = "2em Arial";
        ctx.fillText(`Time's up! Score: ${score}`, 50, 150);
        return;
      }
      timer--;
    moveTarget();
    countdown();  
  }
#back-btn {
  margin-top: 2em;
  background: #ff4081;
}
