TILE_SIZE = 32
WINDOW_WIDHT = 1280
WINDOW_HEIGHT = 720

MAX_TILES_X = WINDOW_WIDHT / TILE_SIZE
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE) 

-- time in seconds that the snake moves one tile
SNAKE_SPEED = 0.1

local score = 0
local gameOver = false
local gameStart = true

local largeFont = love.graphics.newFont(32)
local hugeFont = love.graphics.newFont(128)

tileGrid = {}

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3

-- value in the grid axis
local snakeX, snakeY = 1, 1
local snakeMoving = 'right'
local snakeTimmer = 0

-- snake data structure
local snakeTiles = {
    {snakeX, snakeY} -- head of the snake
}

function love.load()
    love.window.setTitle('Snake Game')

    love.graphics.setFont(largeFont)
    
    love.window.setMode(WINDOW_WIDHT, WINDOW_HEIGHT, {
        fullscreen = false
    })

    math.randomseed(os.time())
    initializeGrid(̥)
    initializeSnake()

    tileGrid[snakeX][snakeY] = TILE_SNAKE_HEAD
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end

    if not gameOver then 
        if key == 'left' and snakeMoving ~= 'right' then
            snakeMoving = 'left'
        elseif key == 'right' and snakeMoving ~= 'left'then
            snakeMoving = 'right'
        elseif key == 'up' and snakeMoving ~= 'down' then 
            snakeMoving = 'up'
        elseif key == 'down' and snakeMoving ~= 'up' then
            snakeMoving = 'down'
        end
    end 

    if gameOver or gameStart then
        
        -- initialize the game again 
        if key == 'enter' or key == 'return' then
            initializeGrid()
            initializeSnake()
            score = 0
            gameOver = false
            gameStart = false
        end
    end 
end

function love.update(dt)

    if not gameOver then

        snakeTimmer = snakeTimmer + dt
        
        local priorHeadX, priorHeadY = snakeX, snakeY
        
        if snakeTimmer >= SNAKE_SPEED then
            if snakeMoving == 'up' then 
                if snakeY <= 1 then
                    snakeY = MAX_TILES_Y
                else
                    snakeY = snakeY - 1
                end
            elseif snakeMoving == 'down' then 
                if snakeY >= MAX_TILES_Y then
                    snakeY = 1
                else
                    snakeY = snakeY + 1
                end
            elseif snakeMoving == 'left' then 
                if snakeX <= 1 then
                    snakeX = MAX_TILES_X
                else
                    snakeX = snakeX - 1
                end
            else 
                if snakeX >= MAX_TILES_X then
                    snakeX = 1  
                else 
                    snakeX = snakeX + 1
                end
            end

            -- push a new head to the snake data structure
            table.insert(snakeTiles, 1, {snakeX, snakeY})

            -- if the snake collide with its body
            if tileGrid[snakeX][snakeY] == TILE_SNAKE_BODY then
                gameOver = true
                
            end

            -- if we are eating an apple 
            if tileGrid[snakeX][snakeY] == TILE_APPLE then
                
                -- update the score and generate new apple
                score = score + 1
                local appleX, appleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
                tileGrid[appleX][appleY] = TILE_APPLE
            
            -- otherwise pop the tail and erase from the grid
            else 

                local tail = snakeTiles[#snakeTiles]
                tileGrid[tail[1]][tail[2]] = TILE_EMPTY
                table.remove(snakeTiles)

            end

            -- if our snake is greater than one tile long
            if #snakeTiles > 1 then
                
                -- set the prior head value to a body value
                tileGrid[priorHeadX][priorHeadY] = TILE_SNAKE_BODY
            end

            -- update the veiw with the next snake head location
            tileGrid[snakeX][snakeY] = TILE_SNAKE_HEAD
            snakeTimmer = 0
        end  
    end  
end

function love.draw()
    
    if gameStart then 

        love.graphics.setFont(hugeFont)
        love.graphics.printf('SNAKE', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDHT, 'center')
        
        love.graphics.setFont(largeFont)
        love.graphics.printf('Press Enter to start', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDHT, 'center')

    else 
        drawGrid()

        -- print score
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Score: ' .. tostring(score), 10, 10)
    end

    if gameOver then 
        drawGameOver()
    end
end 

function drawGameOver()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDHT, 'center')
    
    love.graphics.setFont(largeFont)
    love.graphics.printf('Press Enter to restart', 0, WINDOW_HEIGHT / 2 + 96, WINDOW_WIDHT, 'center')
end

function drawGrid() 
    love.graphics.setColor(1, 1, 1, 1)
    
    for x = 1, MAX_TILES_X do
        for y = 1, MAX_TILES_Y do
            if tileGrid[x][y] == TILE_EMPTY then
                
                -- change the color to white for the grid
                -- love.graphics.setColor(1, 1, 1, 1)
                -- love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            
            elseif tileGrid[x][y] == TILE_APPLE then 
                
                -- change the color to red for the Apple
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            
            elseif tileGrid[x][y] == TILE_SNAKE_HEAD then 
                -- change the color to Green for the snake head
                love.graphics.setColor(0, 1, 1, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            
            elseif tileGrid[x][y] == TILE_SNAKE_BODY then 
                -- change the color to Green for the snake head
                love.graphics.setColor(0, 1, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function initializeGrid()

    tileGrid = {}
    for x = 1, MAX_TILES_X do
        table.insert(tileGrid, {})
        
        for y = 1, MAX_TILES_Y do 
            table.insert(tileGrid[x], TILE_EMPTY)
        end
    end

    local appleX, appleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
    tileGrid[appleX][appleY] = TILE_APPLE
end

function initializeSnake()
    snakeX, snakeY = 1, 1
    snakeMoving = 'right'
    snakeTiles = {
        {snakeX, snakeY} -- head of the snake
    }
    
end