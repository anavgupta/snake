TILE_SIZE = 32
WINDOW_WIDHT = 1280
WINDOW_HEIGHT = 720

SNAKE_SPEED = 100

tileGrid = {}

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3

local snakeX, snakeY = 0, 0
local snakeMoving = 'right'

MAX_TILES_X = WINDOW_WIDHT / TILE_SIZE
MAX_TILES_Y = WINDOW_HEIGHT / TILE_SIZE

function love.load()
    love.window.setTitle('Snake Game')

    love.window.setMode(WINDOW_WIDHT, WINDOW_HEIGHT, {
        fullscreen = false
    })

    math.randomseed(os.time())
    initializeGrid()

end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    end

    if key == 'left' then
        snakeMoving = 'left'
    elseif key == 'right' then
        snakeMoving = 'right'
    elseif key == 'up' then 
        snakeMoving = 'up'
    elseif key == 'down' then
        snakeMoving = 'down'
    end
end

function love.update(dt)
    if snakeMoving == 'right' then
        snakeX = snakeX + SNAKE_SPEED * dt
    elseif snakeMoving == 'left' then
        snakeX = snakeX - SNAKE_SPEED * dt
    elseif snakeMoving == 'up' then
        snakeY = snakeY - SNAKE_SPEED * dt
    elseif snakeMoving == 'down' then 
        snakeY = snakeY + SNAKE_SPEED * dt
    end

end

function love.draw()
    drawGrid()
    drawSnake()
end 


function drawSnake()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('fill', snakeX, snakeY, TILE_SIZE, TILE_SIZE)
end


function drawGrid() 
    love.graphics.setColor(1, 1, 1, 1)
    
    for x = 1, MAX_TILES_X do
        for y = 1, MAX_TILES_Y do
            if tileGrid[x][y] == TILE_EMPTY then
                
                -- change the color to white for the grid
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            
            elseif tileGrid[x][y] == TILE_APPLE then 
                
                -- change the color to red for the Apple
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function initializeGrid()
    for x = 1, MAX_TILES_X do
        table.insert(tileGrid, {})
        
        for y = 1, MAX_TILES_Y do 
            table.insert(tileGrid[x], TILE_EMPTY)
        end
    end

    local appleX, appleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)
    tileGrid[appleX][appleY] = TILE_APPLE
end