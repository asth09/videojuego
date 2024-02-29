-- Variables
local player = { x = 200, y = 550, speed = 200, width = 50, height = 50}
local bullets = {}
local enemies = {}
local enemySpeed = 50
local enemyTimer = 0
local enemyLimit = 10
local bulletHeight = 10
local enemyWidth = 50
local enemyHeight = 50
local bulletWidth = 10  -- Definir la variable bulletWidth y asignarle un valor de 10


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
        local bullet = { x = player.x + playerImg:getWidth() / 2, y = player.y }
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

    -- Dibujar balas
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImg, bullet.x, bullet.y, 0, bulletWidth/bulletImg:getWidth(), bulletHeight/bulletImg:getHeight())
    end

    -- Dibujar enemigos
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImg, enemy.x, enemy.y, 0, enemyWidth/enemyImg:getWidth(), enemyHeight/enemyImg:getHeight())
    end
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function checkCollisions()
    if checkCollision(player.x, player.y, player.width, player.height, enemy.x, enemy.y, enemy.width, enemy.height) then
        -- Realizar acciones cuando hay colisión
    end
end

function checkCollisions()
    -- Colisiones entre balas y enemigos
    for i, bullet in ipairs(bullets) do
        for j, enemy in ipairs(enemies) do
            if checkCollision(bullet.x, bullet.y, bulletWidth, bulletHeight, enemy.x, enemy.y, enemyWidth, enemyHeight) then
                print("Colisión bala-enemigo")
                table.remove(bullets, i)
                table.remove(enemies, j)
            end
        end
    end

    -- Colisiones entre jugador y enemigos
    for i, enemy in ipairs(enemies) do
        if checkCollision(player.x, player.y, player.width, player.height, enemy.x, enemy.y, enemyWidth, enemyHeight) then
            print("Colisión jugador-enemigo")
            -- Aquí puedes agregar la lógica para que el jugador muera
            -- Por ejemplo: reiniciar posición del jugador o terminar el juego
        end
    end
end

