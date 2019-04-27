windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth * 0.75, windowHeight * 0.75

virtualWidth = 384
virtualHeight = 192

push = require 'push'
Class = require 'class'
require 'State'
require 'Player'
require 'Gun'
require 'Bullet'
require 'Box'

state = State()
player = Player(virtualWidth / 10, virtualHeight / 2)
worldBounds = {} -- bounds
world = {} -- obstacles/scenery

function love.load()
    -- math.randomseed(os.time())
    love.window.setTitle('life')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- TODO init stuff

    font = love.graphics.newFont('font.ttf', virtualWidth * 0.08)

    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = true, 
        vsync = true,
        pixelperfect = true
    })

    table.insert(world, Box(virtualWidth / 2, virtualHeight / 5))
    table.insert(world, Box(virtualWidth / 2, virtualHeight - virtualHeight / 10))
end

function love.update(dt)
    if state:isPaused() then
        return
    end
    
    player:handleInput()
    player:update(dt)

    for i,bullet in ipairs(player.bullets) do
        for j,box in ipairs(world) do
            bullet:collidesWith(box)
        end
    end
end

function love.draw()
    love.graphics.clear(0.25, 0.25, 0.25)

    push:apply("start")
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, virtualWidth, virtualHeight)

    player:render()
    for i,box in ipairs(world) do
        box:render()
    end

    -- love.graphics.setColor(1, 1, 1)
    renderCursor()

    push:apply("end")
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(debugInfo(), 5, 5, windowWidth, 'left')
end

function renderCursor()
    local size = size == nil and 3 or size
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    mouseX, mouseY = mouseX ~= nil and mouseX or 0, mouseY ~= nil and mouseY or 0
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle('fill', mouseX, mouseY, size, size)
end

function love.keypressed(key)
    if key == 'space' then
        state:togglePause()
    elseif key == 'escape' then
        love.event.quit()
    elseif key == 'return' then
        --
    end
end

function love.mousepressed(x, y, button)
    -- necessary?
end

function love.resize(w, h)
    push:resize(w, h)
end

function debugInfo()
    local windowDetails = windowWidth .. ' x ' .. windowHeight .. ' | ' .. virtualWidth .. ' x ' .. virtualHeight
    local fps = tostring(love.timer.getFPS())
    local state = state:debugInfo()
    local player = player:debugInfo()
    local world = #world
    return windowDetails .. ' @ ' .. fps .. '\n' .. state .. '\n' .. player .. '\n' .. world
end
