-- Variables
local player = { x = 200, y = 550, speed = 200, width = 50, height = 50, health = 3}
local bullets = {}
local enemies = {}
local enemySpeed = 50
local enemyTimer = 0
local enemyLimit = 10
local bulletHeight = 10
local enemyWidth = 50
local enemyHeight = 50
local bulletWidth = 10  -- Definir la variable bulletWidth y asignarle un valor de 10
local enemyHealth = 1 
local gameOver = false


-- Cargar imágenes
local playerImg = love.graphics.newImage("player.png")
local bulletImg = love.graphics.newImage("bullet.png")
local enemyImg = love.graphics.newImage("enemy.png")


function love.update(dt)
    -- Movimiento del jugador
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
        checkCollisions()
    end

    -- Disparo de balas
    if love.keyboard.isDown("space") then
        local bullet = { x = player.x + player.width / 2 - bulletWidth / 2, y = player.y }
        table.insert(bullets, bullet)
    end

    -- Creación de enemigos
    enemyTimer = enemyTimer + dt
    if enemyTimer > 1 and #enemies < enemyLimit then
        local enemy = { x = math.random(0, love.graphics.getWidth()), y = 0 }
        table.insert(enemies, enemy)
        enemyTimer = 0
    end

    -- Actualizar posición de balas y enemigos
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - 300 * dt
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + enemySpeed * dt
        if enemy.y > love.graphics.getHeight() then
            table.remove(enemies, i)
        end
    end
end

function love.draw()
    -- Dibujar jugador
    love.graphics.draw(playerImg, player.x, player.y, 0, player.width/playerImg:getWidth(), player.height/playerImg:getHeight())
        
    if not gameOver then
        -- Dibujar contador de vida del jugador
        love.graphics.print("Vida: " .. player.health, 10, 10)
    

    -- Dibujar balas
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImg, bullet.x, bullet.y, 0, bulletWidth/bulletImg:getWidth(), bulletHeight/bulletImg:getHeight())
    end

    -- Dibujar enemigos
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImg, enemy.x, enemy.y, 0, enemyWidth/enemyImg:getWidth(), enemyHeight/enemyImg:getHeight())
    end
else
    -- Mostrar mensaje de Game Over
    love.graphics.print("GAME OVER", 200, 300)

    -- Dibujar botón de reinicio
    love.graphics.rectangle("line", 250, 350, 100, 50)
    love.graphics.print("Reiniciar", 270, 365)
end
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function checkCollisions()
    -- Colisiones entre balas y enemigos
    for i, bullet in ipairs(bullets) do
        for j, enemy in ipairs(enemies) do
            if checkCollision(bullet.x, bullet.y, bulletWidth, bulletHeight, enemy.x, enemy.y, enemyWidth, enemyHeight) then
                print("Colisión bala-enemigo")
                table.remove(bullets, i)
                collapseEnemy(j)
            end
        end
    end

    -- Colisiones entre jugador y enemigos
    for i, enemy in ipairs(enemies) do
        if checkCollision(player.x, player.y, player.width, player.height, enemy.x, enemy.y, enemyWidth, enemyHeight) then
            print("Colisión jugador-enemigo")
            player.health = player.health - 1
            if player.health <= 0 then
                -- Aquí puedes agregar la lógica para reiniciar el juego o mostrar un mensaje de Game Over
                player.x = 200
                player.y = 550
                player.health = 3
            end
        end
    end
end


function collapseEnemy(index)
    table.remove(enemies, index)
end

function love.mousepressed(x, y, button)
    if gameOver and button == 1 then
        if x >= 250 and x <= 350 and y >= 350 and y <= 400 then
            -- Reiniciar el juego
            gameOver = false
            player.x = 200
            player.y = 550
            player.health = 3
            enemies = {}
            bullets = {}
        end
    end
end

